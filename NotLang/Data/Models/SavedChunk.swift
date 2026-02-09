//
//  SavedChunk.swift
//  NotLang
//
//  Created by Amier Davis on 2/7/26.
//

import SwiftData
import Foundation

// TODO: Create chunk protocol

@Model
class SavedChunk: Identifiable {
    var id: UUID
    var text: String
    var translation: String
    
    /// Spaced repetition: days until the next review
    var interval: Int
    /// Spaced repetition: number of consecutive successful reviews
    var repetition: Int
    /// Spaced repetition: ease multiplier for scheduling (starts at 2.5)
    var easeFactor: Double
    /// The date when this chunk is due for review
    var nextReviewDate: Date
    
    var cleanedText: String { text.trimmingCharacters(in: .punctuationCharacters) }
    var cleanedTranslation: String { translation.trimmingCharacters(in: .punctuationCharacters) }
    
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

