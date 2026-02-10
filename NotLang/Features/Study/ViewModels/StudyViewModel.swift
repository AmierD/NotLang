import Foundation
import SwiftData

@Observable
final class StudyViewModel {
    enum Difficulty: Int {
        case again = 1
        case hard = 2
        case good = 3
        case easy = 4
    }

    /// Apply a simplified SM-2 style update to the given chunk based on the selected difficulty.
    /// - Parameters:
    ///   - chunk: The SavedChunk being reviewed.
    ///   - difficulty: User-rated difficulty for this review.
    ///   - context: ModelContext used to persist changes.
    func review(
        _ chunk: SavedChunk,
        difficulty: Difficulty,
        context: ModelContext
    ) {
        let now = Date()
        var interval = chunk.interval
        var repetition = chunk.repetition
        var ef = chunk.easeFactor

        switch difficulty {
        case .again:
            // Reset progress, schedule for tomorrow, decrease ease
            repetition = 0
            interval = 1
            ef = max(1.3, ef - 0.2)

        case .hard:
            // Slightly penalize ease, keep repetition at least 1, small interval growth
            repetition = max(1, repetition)
            ef = max(1.3, ef - 0.15)
            interval = max(
                1,
                interval > 0 ? Int(round(Double(interval) * 1.2)) : 1
            )

        case .good:
            // Normal progression; keep ease stable, multiply by EF
            repetition += 1
            ef = max(1.3, ef + 0.0)
            if interval <= 0 {
                interval = 1
            } else {
                interval = max(1, Int(round(Double(interval) * ef)))
            }

        case .easy:
            // Best outcome; increase EF slightly, larger interval jump
            repetition += 1
            ef = min(3.5, ef + 0.15)
            if interval <= 0 {
                interval = 2
            } else {
                interval = max(1, Int(round(Double(interval) * ef)))
            }
        }

        chunk.repetition = repetition
        chunk.easeFactor = ef
        chunk.interval = interval
        if let due = Calendar.current.date(
            byAdding: .day,
            value: interval,
            to: now
        ) {
            chunk.nextReviewDate = due
        } else {
            chunk.nextReviewDate = now
        }

        do {
            try context.save()
        } catch {
            print("StudyViewModel save error: \(error.localizedDescription)")
        }
    }
}
