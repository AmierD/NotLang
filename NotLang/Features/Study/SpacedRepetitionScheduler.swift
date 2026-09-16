//
//  SpacedRepetitionScheduler.swift
//  NotLang
//
//  Created by Amier Davis on 9/15/26.
//

import Foundation

/// A simplified implementation of the **SM-2** spaced repetition algorithm.
///
/// SM-2 schedules a flashcard by tracking three numbers and updating them each
/// time the learner grades their own recall:
///
/// - term ``Schedule/interval``: how many days to wait before showing the card again.
/// - term ``Schedule/repetition``: how many times in a row the card has been recalled successfully.
/// - term ``Schedule/easeFactor``: a per-card multiplier describing how easy the card is.
///   Easy cards grow their interval faster than hard ones.
///
/// On each review the grade decides what happens to all three. A failed recall
/// resets progress and nudges the ease factor down; a successful one multiplies
/// the interval by the ease factor, so well-known cards drift further and
/// further into the future while troublesome ones stay in rotation.
///
/// The ease factor is clamped to ``minimumEaseFactor``...``maximumEaseFactor``.
/// The lower bound is the one that matters: without it, a card failed repeatedly
/// would drive its ease toward zero and become unschedulable.
///
/// ## The ordering invariant
///
/// For any card state, the grades schedule strictly further out as they get easier:
///
/// ```
/// hard < good < easy
/// ```
///
/// This is guaranteed rather than incidental. Letting each grade derive its own
/// multiplier does not produce it: at the ease factor floor the multipliers
/// converge, and integer rounding then collapses two grades onto the same number
/// of days - so pressing Hard and pressing Good would schedule identically, and
/// the buttons would stop meaning anything.
/// ``intervalCandidates(interval:easeFactor:)`` therefore enforces the ordering
/// explicitly, after computing the raw values.
///
/// ``Difficulty/again`` sits outside this chain. It always schedules one day out,
/// so it may tie with ``Difficulty/hard`` on a chunk that has not been reviewed yet.
///
/// ## Purity
///
/// ``schedule(interval:repetition:easeFactor:difficulty:from:)`` is a pure
/// function. It reads no stored state, mutates nothing, and takes the current
/// date as the `from` parameter rather than calling `Date()` internally - which
/// is what makes its scheduling behavior directly testable.
///
/// This type is a caseless enum: it is a namespace for the algorithm and is
/// never instantiated.
nonisolated enum SpacedRepetitionScheduler {

    // MARK: - Tuning constants

    /// The lowest an ease factor may fall, however often a chunk is failed.
    ///
    /// A chunk at this ease still grows its interval, just slowly. Without a
    /// floor, repeated failures would drive the multiplier toward zero and the
    /// chunk would never be scheduled forward again.
    static let minimumEaseFactor = 1.3

    /// The highest an ease factor may rise, however often a chunk is easy.
    ///
    /// Caps how quickly a well-known chunk can disappear into the future.
    static let maximumEaseFactor = 3.5

    /// The fixed multiplier ``Difficulty/hard`` applies to the current interval.
    ///
    /// Unlike the other grades, Hard ignores the chunk's ease factor: a
    /// struggled-through recall should grow the interval by roughly the same
    /// small amount whatever the chunk's history.
    private static let hardIntervalMultiplier = 1.2

    // MARK: - Types

    /// How well the learner recalled a chunk, graded by the learner themselves.
    ///
    /// The raw values run from hardest to easiest so the grades can be compared
    /// and persisted as integers.
    enum Difficulty: Int {
        /// Recall failed. Resets the repetition count and schedules the chunk for tomorrow.
        case again = 1
        /// Recalled, but with effort. Grows the interval slowly and lowers the ease factor.
        case hard = 2
        /// Recalled correctly. The normal path: the interval is multiplied
        /// by the ease factor.
        case good = 3
        /// Recalled effortlessly. Like ``good``, but also raises the ease factor.
        case easy = 4
    }

    /// One value per ``Difficulty``, addressable by grade.
    ///
    /// Parts of the algorithm have to work out what *every* grade would do before
    /// they can answer for one of them: the ordering invariant is a relationship
    /// between grades, so the grades cannot be computed in isolation. This type
    /// carries such a set of four and hands back whichever was asked for.
    ///
    /// It is generic over `Value` so one type serves whatever is being computed -
    /// `ByDifficulty<Int>` holds four intervals, `ByDifficulty<Double>` would hold
    /// four ease factors. Writing it once keeps the `switch` over ``Difficulty``
    /// in a single place instead of repeating it at every call site.
    struct ByDifficulty<Value> {
        /// The value for ``Difficulty/again``.
        let again: Value
        /// The value for ``Difficulty/hard``.
        let hard: Value
        /// The value for ``Difficulty/good``.
        let good: Value
        /// The value for ``Difficulty/easy``.
        let easy: Value

        /// The value corresponding to `difficulty`.
        subscript(difficulty: Difficulty) -> Value {
            switch difficulty {
            case .again: again
            case .hard: hard
            case .good: good
            case .easy: easy
            }
        }
    }

    /// The scheduling state produced by a single review.
    ///
    /// Every property is a replacement value, not a delta - callers overwrite
    /// the corresponding fields on their stored chunk wholesale.
    struct Schedule {
        /// Days to wait before this chunk is due again.
        let interval: Int
        /// Count of consecutive successful recalls, reset to `0` by ``Difficulty/again``.
        let repetition: Int
        /// The chunk's updated ease multiplier, clamped to
        /// ``minimumEaseFactor``...``maximumEaseFactor``.
        let easeFactor: Double
        /// The date the chunk next falls due.
        let nextReviewDate: Date
    }

    // MARK: - Scheduling

    /// Applies one review to a chunk's scheduling state.
    ///
    /// The returned values depend only on the arguments, so a given set of
    /// inputs always produces the same schedule.
    ///
    /// - Parameters:
    ///   - interval: The chunk's current interval in days. Pass `0` for a chunk
    ///     that has never been reviewed.
    ///   - repetition: The chunk's current count of consecutive successful recalls.
    ///   - easeFactor: The chunk's current ease multiplier. New chunks start at `2.5`.
    ///   - difficulty: How well the learner recalled the chunk.
    ///   - now: The moment the review took place. Injected rather than read from
    ///     the system clock so that callers - tests especially - control it.
    /// - Returns: The chunk's scheduling state after the review.
    static func schedule(
        interval: Int,
        repetition: Int,
        easeFactor: Double,
        difficulty: Difficulty,
        from now: Date
    ) -> Schedule {
        let newInterval = intervalCandidates(
            interval: interval,
            easeFactor: easeFactor
        )[difficulty]

        let nextReviewDate =
            Calendar.current.date(
                byAdding: .day,
                value: newInterval,
                to: now
            ) ?? now

        return Schedule(
            interval: newInterval,
            repetition: updatedRepetition(for: difficulty, from: repetition),
            easeFactor: updatedEaseFactor(for: difficulty, from: easeFactor),
            nextReviewDate: nextReviewDate
        )
    }

    // MARK: - Components

    /// The interval every grade would schedule for a chunk in the given state.
    ///
    /// Raw values come from each grade's own multiplier and are then forced into
    /// `hard < good < easy` by raising any grade that fails to clear the one below
    /// it. Hard anchors the chain, so a grade is only ever pushed further out,
    /// never pulled in.
    ///
    /// - Parameters:
    ///   - interval: The chunk's current interval in days, or `0` if never reviewed.
    ///   - easeFactor: The chunk's ease multiplier *before* this review adjusts it.
    ///     Every candidate is derived from this same starting value, which is what
    ///     makes comparing them meaningful.
    /// - Returns: One interval per grade, in days.
    private static func intervalCandidates(
        interval: Int,
        easeFactor: Double
    ) -> ByDifficulty<Int> {
        // A failed recall always comes back tomorrow.
        let again = 1

        let hard = multiplyInterval(
            interval,
            by: hardIntervalMultiplier,
            whenUnreviewed: 1
        )

        // Good and Easy each multiply by the ease factor this review would leave
        // them with, so Easy's boost actually reaches the interval.
        let goodCandidate = multiplyInterval(
            interval,
            by: updatedEaseFactor(for: .good, from: easeFactor),
            whenUnreviewed: 1
        )
        let easyCandidate = multiplyInterval(
            interval,
            by: updatedEaseFactor(for: .easy, from: easeFactor),
            whenUnreviewed: 2
        )

        // Enforce hard < good < easy. Each clamp reads the already-clamped value
        // below it, so raising one grade carries through to the next.
        let good = max(goodCandidate, hard + 1)
        let easy = max(easyCandidate, good + 1)

        return ByDifficulty(again: again, hard: hard, good: good, easy: easy)
    }

    /// Grows `interval` by `multiplier`, rounded to whole days.
    ///
    /// - Parameters:
    ///   - interval: The chunk's current interval in days.
    ///   - multiplier: The multiplier to apply.
    ///   - whenUnreviewed: The interval to use when `interval` is `0`. Multiplying
    ///     zero would leave the chunk permanently due, so a never-reviewed chunk
    ///     takes a fixed starting interval instead.
    /// - Returns: The new interval, never less than one day.
    private static func multiplyInterval(
        _ interval: Int,
        by multiplier: Double,
        whenUnreviewed: Int
    ) -> Int {
        guard interval > 0 else { return whenUnreviewed }
        return max(1, Int(round(Double(interval) * multiplier)))
    }

    /// The ease factor a chunk is left with after being graded `difficulty`.
    ///
    /// Each grade contributes a fixed adjustment, and the result is then clamped
    /// to ``minimumEaseFactor``...``maximumEaseFactor``. Keeping the per-grade
    /// delta separate from the clamp means the permitted range is stated once and
    /// applies uniformly, rather than each grade carrying its own half of the bound.
    ///
    /// - Parameters:
    ///   - difficulty: How well the learner recalled the chunk.
    ///   - easeFactor: The chunk's ease multiplier before this review.
    /// - Returns: The updated ease multiplier, within the permitted range.
    private static func updatedEaseFactor(
        for difficulty: Difficulty,
        from easeFactor: Double
    ) -> Double {
        let delta: Double =
            switch difficulty {
            case .again: -0.20
            case .hard: -0.15
            case .good: 0
            case .easy: 0.15
            }

        return min(maximumEaseFactor, max(minimumEaseFactor, easeFactor + delta))
    }

    /// The repetition count a chunk is left with after being graded `difficulty`.
    ///
    /// - Parameters:
    ///   - difficulty: How well the learner recalled the chunk.
    ///   - repetition: The chunk's streak of successful recalls before this review.
    /// - Returns: The updated streak: reset by ``Difficulty/again``, incremented
    ///   by a clean recall.
    private static func updatedRepetition(
        for difficulty: Difficulty,
        from repetition: Int
    ) -> Int {
        switch difficulty {
        case .again: 0
        case .hard: max(1, repetition)
        case .good, .easy: repetition + 1
        }
    }
}
