//
//  TranslationChunk.swift
//  NotLang
//
//  Created by Amier Davis on 1/12/26.
//

import Foundation

/// A single piece of text from a post, paired with its translation.
///
/// ``text`` is in the learner's target language; ``translation`` is in their
/// native language.
struct TranslationChunk: Identifiable, Hashable, Codable {
    var id: UUID = UUID()

    /// Text in the learner's target language.
    let text: String

    /// Translation of ``text`` into the learner's native language.
    let translation: String

    let isSaved: Bool = false

    var cleanedText: String {
        text.trimmingCharacters(in: .punctuationCharacters)
    }
    var cleanedTranslation: String {
        translation.trimmingCharacters(in: .punctuationCharacters)
    }

    enum CodingKeys: String, CodingKey {
        case text, translation
    }

    /// Assigns a fresh ``id``; the JSON payload does not carry one.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = UUID()
        self.text = try container.decode(String.self, forKey: .text)
        self.translation = try container.decode(
            String.self,
            forKey: .translation
        )
    }

    init(text: String, translation: String) {
        self.id = UUID()
        self.text = text
        self.translation = translation
    }
}

extension TranslationChunk: Equatable {
    nonisolated static func == (lhs: TranslationChunk, rhs: TranslationChunk) -> Bool {
        lhs.id == rhs.id
    }
}
