import Foundation
import SwiftData

/// Drives the study screen, applying review results to saved chunks.
///
/// The scheduling arithmetic itself lives in ``SpacedRepetitionScheduler``.
/// This type's only job is to bridge that pure calculation to SwiftData:
/// it supplies the current date, copies the resulting schedule onto the
/// `SavedChunk`, and persists it.
@Observable
final class StudyViewModel {

    /// Records a review of `chunk` and persists the new schedule.
    ///
    /// Delegates to ``SpacedRepetitionScheduler/schedule(interval:repetition:easeFactor:difficulty:from:)``
    /// for the SM-2 update, then writes the four scheduling fields back onto
    /// `chunk`. A failed save is logged rather than thrown: a dropped review is
    /// not worth interrupting a study session over, and the next review of the
    /// same chunk will attempt another save.
    ///
    /// - Parameters:
    ///   - chunk: The chunk that was just reviewed.
    ///   - difficulty: How well the learner recalled it.
    ///   - context: The context used to persist the updated chunk.
    func review(
        _ chunk: SavedChunk,
        difficulty: SpacedRepetitionScheduler.Difficulty,
        context: ModelContext
    ) {
        let schedule = SpacedRepetitionScheduler.schedule(
            interval: chunk.interval,
            repetition: chunk.repetition,
            easeFactor: chunk.easeFactor,
            difficulty: difficulty,
            from: Date()
        )

        chunk.interval = schedule.interval
        chunk.repetition = schedule.repetition
        chunk.easeFactor = schedule.easeFactor
        chunk.nextReviewDate = schedule.nextReviewDate

        do {
            try context.save()
        } catch {
            print("StudyViewModel save error: \(error.localizedDescription)")
        }
    }
}
