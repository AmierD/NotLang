//
//  Post.swift
//  NotLang
//
//  Created by Amier Davis on 2/8/26.
//

import Foundation

/// The fields common to a post however it is stored.
///
/// Implemented by ``LangPost``, decoded from the feed API, and ``SavedPost``,
/// persisted with SwiftData.
protocol Post {
    var id: UUID { get set }

    /// The username of the author of the post.
    var author: String { get }

    /// The topic that this post most closely relates to.
    var topic: String { get }

    /// The body of the post, in reading order.
    var content: [TranslationChunk] { get }
}
