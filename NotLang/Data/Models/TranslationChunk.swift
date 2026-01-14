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
struct TranslationChunk: Identifiable, Hashable {
    let id: UUID = UUID()
    
    /// Text in the user's TL, represented as a `String`.
    let text: String
    
    /// Translation of the text in the user's NL, represented as a `String`.
    let translation: String
    
    /// Identifier for whether or not this chunk has been deemed a phrase, represented as a `Boolean`.
    ///
    /// This information is useful because it allows us the ability to have separate logic for phrases vs. singular words. For example, a user can have a list of saved phrases and a separate list of words.
    let isPhrase: Bool
}
