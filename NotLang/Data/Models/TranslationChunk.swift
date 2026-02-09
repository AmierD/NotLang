//
//  TranslationChunk.swift
//  NotLang
//
//  Created by Amier Davis on 1/12/26.
//

import Foundation

/// A model for a singular piece of text in a post.
///
/// Included in this model, in addition to the `text` in the user's set Target Language (TL), is the translation of the `text` to the user's Native Language (NL).
struct TranslationChunk: Identifiable, Hashable, Codable {
    var id: UUID = UUID()
    
    /// Text in the user's TL, represented as a `String`.
    let text: String
    
    /// Translation of the text in the user's NL, represented as a `String`.
    let translation: String
    
    let isSaved: Bool = false
    
    var cleanedText: String { text.trimmingCharacters(in: .punctuationCharacters) }
    var cleanedTranslation: String { translation.trimmingCharacters(in: .punctuationCharacters) }
    
    /// Helper enum for the curstom intializer used by the JSONDecoder.
    enum CodingKeys: String, CodingKey {
        case text, translation
    }
    
    /// Custom initializer to be used by the JSON Decoder.
    ///
    /// Allows the JSON to be decoded without an id parameter so that swift can create a UUID for the ``TranslationChunk``.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = UUID()
        self.text = try container.decode(String.self, forKey: .text)
        self.translation = try container.decode(String.self, forKey: .translation)
    }
    
    /// Intializer for manual creation of ``TranslationChunk`` objects.
    init(text: String, translation: String) {
        self.id = UUID()
        self.text = text
        self.translation = translation
    }
}
