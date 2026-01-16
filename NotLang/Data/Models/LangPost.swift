//
//  LangPost.swift
//  NotLang
//
//  Created by Amier Davis on 1/12/26.
//

import Foundation

/// A model for a NotLang post.
struct LangPost: Identifiable {
    let id: UUID = UUID()
    
    /// The username of the author of the post.
    let author: String
    /// The text content of the post, represented as an array of ``TranslationChunk``s.
    let content: [TranslationChunk]
}
