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

    let author: String

    let topic: String

    let content: [TranslationChunk]

    enum CodingKeys: String, CodingKey {
        case id, author, topic, content
    }

    /// Requires an `id` in the payload; decoding throws without one.
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
