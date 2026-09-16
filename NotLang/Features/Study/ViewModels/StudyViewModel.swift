import Foundation
import SwiftData

/// Drives the study screen, applying review results to saved chunks.
@Observable
final class StudyViewModel {

    /// Records a review of `chunk` and persists the new schedule.
    ///
    /// A failed save is logged rather than thrown, so a caller is not told when
    /// a review is dropped.
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
