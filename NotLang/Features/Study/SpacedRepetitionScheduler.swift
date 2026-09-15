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
/// The ease factor is clamped to the range `1.3...3.5`. The lower bound is the
/// one that matters: without it, a card failed repeatedly would drive its ease
/// toward zero and become unschedulable.
///
/// ## Purity
///
/// ``schedule(interval:repetition:easeFactor:difficulty:from:)`` is a pure
/// function. It reads no stored state, mutates nothing, and takes the current
/// date as the `from` parameter rather than calling `Date()` internally — which
/// is what makes its scheduling behavior directly testable.
///
/// This type is a caseless enum: it is a namespace for the algorithm and is
/// never instantiated.
nonisolated enum SpacedRepetitionScheduler {

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

    /// The scheduling state produced by a single review.
    ///
    /// Every property is a replacement value, not a delta — callers overwrite
    /// the corresponding fields on their stored card wholesale.
    struct Schedule {
        /// Days to wait before this chunk is due again.
        let interval: Int
        /// Count of consecutive successful recalls, reset to `0` by ``Difficulty/again``.
        let repetition: Int
        /// The chunk's updated ease multiplier, clamped to `1.3...3.5`.
        let easeFactor: Double
        /// The date the chunk next falls due.
        let nextReviewDate: Date
    }

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
    ///     the system clock so that callers — tests especially — control it.
    /// - Returns: The chunk's scheduling state after the review.
    static func schedule(
        interval: Int,
        repetition: Int,
        easeFactor: Double,
        difficulty: Difficulty,
        from now: Date
    ) -> Schedule {
        var newInterval = interval
        var newRepetition = repetition
        var newEaseFactor = easeFactor

        switch difficulty {
        case .again:
            // Reset progress, schedule for tomorrow, decrease ease
            newRepetition = 0
            newInterval = 1
            newEaseFactor = max(1.3, newEaseFactor - 0.2)

        case .hard:
            // Slightly penalize ease, keep repetition at least 1, small interval growth
            newRepetition = max(1, newRepetition)
            newEaseFactor = max(1.3, newEaseFactor - 0.15)
            newInterval = max(
                1,
                newInterval > 0 ? Int(round(Double(newInterval) * 1.2)) : 1
            )

        case .good:
            // Normal progression; keep ease stable, multiply by EF
            newRepetition += 1
            newEaseFactor = max(1.3, newEaseFactor)
            if newInterval <= 0 {
                newInterval = 1
            } else {
                newInterval = max(
                    1,
                    Int(round(Double(newInterval) * newEaseFactor))
                )
            }

        case .easy:
            // Best outcome; increase EF slightly, larger interval jump
            newRepetition += 1
            newEaseFactor = min(3.5, newEaseFactor + 0.15)
            if newInterval <= 0 {
                newInterval = 2
            } else {
                newInterval = max(
                    1,
                    Int(round(Double(newInterval) * newEaseFactor))
                )
            }
        }

        let nextReviewDate =
            Calendar.current.date(
                byAdding: .day,
                value: newInterval,
                to: now
            ) ?? now

        return Schedule(
            interval: newInterval,
            repetition: newRepetition,
            easeFactor: newEaseFactor,
            nextReviewDate: nextReviewDate
        )
    }
}
