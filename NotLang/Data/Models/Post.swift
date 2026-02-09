//
//  Post.swift
//  NotLang
//
//  Created by Amier Davis on 2/8/26.
//

import Foundation

/// A protocol for a NotLang post.
protocol Post {
    var id: UUID { get set }
    
    /// The username of the author of the post.
    var author: String { get }
    
    /// The topic that this post most closely relates to.
    var topic: String { get }
    
    /// The text content of the post, represented as an array of ``TranslationChunk``s.
    var content: [TranslationChunk] { get }
}
