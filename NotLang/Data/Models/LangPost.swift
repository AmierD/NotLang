//
//  LangPost.swift
//  NotLang
//
//  Created by Amier Davis on 1/12/26.
//

import Foundation

/// A model for a NotLang post.
struct LangPost: Identifiable, Codable, Post {
    var id: UUID

    /// The username of the author of the post.
    let author: String

    /// The topic that this post most closely relates to.
    let topic: String

    /// The text content of the post, represented as an array of ``TranslationChunk``s.
    let content: [TranslationChunk]

    /// Helper enum for the curstom intializer used by the JSONDecoder.
    enum CodingKeys: String, CodingKey {
        case id, author, topic, content
    }

    /// Custom initializer to be used by the JSON Decoder.
    ///
    /// Allows the JSON to be decoded without an id parameter so that swift can create a UUID for the ``LangPost``.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(UUID.self, forKey: .id)

        self.author = try container.decode(String.self, forKey: .author)
        self.topic = try container.decode(String.self, forKey: .topic)
        self.content = try container.decode(
            [TranslationChunk].self,
            forKey: .content
        )
    }

    /// Intializer for manual creation of ``LangPost`` objects.
    init(author: String, topic: String, content: [TranslationChunk]) {
        self.id = UUID()
        self.author = author
        self.topic = topic
        self.content = content
    }
}

extension LangPost: Equatable {
    nonisolated static func == (lhs: LangPost, rhs: LangPost) -> Bool {
        lhs.id == rhs.id
    }
}
