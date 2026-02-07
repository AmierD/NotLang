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
    
    var cleanedText: String { text.trimmingCharacters(in: .punctuationCharacters) }
    var cleanedTranslation: String { translation.trimmingCharacters(in: .punctuationCharacters) }
    
    init(text: String, translation: String) {
        self.id = UUID()
        self.text = text
        self.translation = translation
    }
}
