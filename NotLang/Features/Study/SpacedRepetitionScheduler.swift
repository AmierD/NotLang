//
//  SpacedRepetitionScheduler.swift
//  NotLang
//
//  Created by Amier Davis on 9/15/26.
//

import Foundation

/// A simplified implementation of the **SM-2** spaced repetition algorithm.
///
/// Each review updates three numbers on a chunk:
///
/// - term ``Schedule/interval``: days to wait before showing the chunk again.
/// - term ``Schedule/repetition``: consecutive successful recalls.
/// - term ``Schedule/easeFactor``: a per-chunk multiplier, clamped to
///   ``minimumEaseFactor``...``maximumEaseFactor``, setting how fast the
///   interval grows.
///
/// A successful recall multiplies the interval by the ease factor, so well-known
/// chunks drift further and further into the future. A failed one resets the
/// interval and lowers the ease factor.
///
/// For any chunk state the grades are strictly ordered: `hard < good < easy`.
/// ``Difficulty/again`` sits outside that chain and always schedules one day out,
/// so it may tie with ``Difficulty/hard`` on a chunk that has never been reviewed.
nonisolated enum SpacedRepetitionScheduler {

    // MARK: - Tuning constants

    /// The lowest an ease factor may fall, which keeps a repeatedly failed chunk
    /// schedulable.
    static let minimumEaseFactor = 1.3

    /// The highest an ease factor may rise.
    static let maximumEaseFactor = 3.5

    /// The fixed multiplier ``Difficulty/hard`` applies in place of the ease factor.
    private static let hardIntervalMultiplier = 1.2

    // MARK: - Types

    /// How well the learner recalled a chunk, graded by the learner themselves.
    enum Difficulty: Int {
        /// Recall failed. Resets the repetition count and schedules one day out.
        case again = 1
        /// Recalled with effort. Grows the interval slowly and lowers the ease factor.
        case hard = 2
        /// Recalled correctly. Multiplies the interval by the ease factor.
        case good = 3
        /// Recalled effortlessly. Like ``good``, and raises the ease factor.
        case easy = 4
    }

    /// One value per ``Difficulty``, addressable by grade.
    struct ByDifficulty<Value> {
        let again: Value
        let hard: Value
        let good: Value
        let easy: Value

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
    /// Every property is a replacement value, not a delta.
    struct Schedule {
        /// Days to wait before this chunk is due again.
        let interval: Int
        /// Consecutive successful recalls, reset to `0` by ``Difficulty/again``.
        let repetition: Int
        /// The updated ease multiplier, within
        /// ``minimumEaseFactor``...``maximumEaseFactor``.
        let easeFactor: Double
        /// The date the chunk next falls due.
        let nextReviewDate: Date
    }

    // MARK: - Scheduling

    /// Applies one review to a chunk's scheduling state.
    ///
    /// - Parameters:
    ///   - interval: The chunk's current interval in days. Pass `0` for a chunk
    ///     that has never been reviewed.
    ///   - repetition: The chunk's current streak of successful recalls.
    ///   - easeFactor: The chunk's current ease multiplier. New chunks start at `2.5`.
    ///   - difficulty: How well the learner recalled the chunk.
    ///   - now: The moment the review took place.
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

    /// The interval every grade would schedule for a chunk in the given state,
    /// forced into `hard < good < easy`.
    ///
    /// - Parameter easeFactor: The chunk's ease multiplier *before* this review
    ///   adjusts it, so every candidate derives from the same starting value.
    private static func intervalCandidates(
        interval: Int,
        easeFactor: Double
    ) -> ByDifficulty<Int> {
        let again = 1

        let hard = multiplyInterval(
            interval,
            by: hardIntervalMultiplier,
            whenUnreviewed: 1
        )

        // Good and Easy multiply by the ease factor this review would leave them
        // with, so Easy's boost actually reaches the interval.
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

        // Each clamp reads the already-clamped value below it, so raising one
        // grade carries through to the next.
        let good = max(goodCandidate, hard + 1)
        let easy = max(easyCandidate, good + 1)

        return ByDifficulty(again: again, hard: hard, good: good, easy: easy)
    }

    /// Grows `interval` by `multiplier`, rounded to whole days, never returning
    /// less than a day.
    ///
    /// - Parameter whenUnreviewed: Used when `interval` is `0`, since multiplying
    ///   zero would leave the chunk permanently due.
    private static func multiplyInterval(
        _ interval: Int,
        by multiplier: Double,
        whenUnreviewed: Int
    ) -> Int {
        guard interval > 0 else { return whenUnreviewed }
        return max(1, Int(round(Double(interval) * multiplier)))
    }

    /// The ease factor a chunk is left with after being graded `difficulty`.
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
