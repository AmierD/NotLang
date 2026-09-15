//
//  SavedChunk.swift
//  NotLang
//
//  Created by Amier Davis on 2/7/26.
//

import Foundation
import SwiftData

// TODO: Create chunk protocol

@Model
class SavedChunk: Identifiable {
    var id: UUID
    var text: String
    var translation: String

    /// Days to wait between reviews. See ``SpacedRepetitionScheduler``.
    ///
    /// `0` means the chunk has never been reviewed.
    var interval: Int
    /// Number of consecutive successful reviews, reset by a failed recall.
    var repetition: Int
    /// Per-chunk ease multiplier used to grow ``interval``, clamped to `1.3...3.5`.
    ///
    /// Starts at `2.5` and drifts up or down as the chunk proves easy or hard.
    var easeFactor: Double
    /// The date this chunk next falls due for review.
    var nextReviewDate: Date

    var cleanedText: String {
        text.trimmingCharacters(in: .punctuationCharacters)
    }
    var cleanedTranslation: String {
        translation.trimmingCharacters(in: .punctuationCharacters)
    }

    init(text: String, translation: String) {
        self.id = UUID()
        self.text = text
        self.translation = translation
        // SRS defaults: due now, no prior reps, base ease factor
        self.interval = 0
        self.repetition = 0
        self.easeFactor = 2.5
        self.nextReviewDate = Date()
    }
}
