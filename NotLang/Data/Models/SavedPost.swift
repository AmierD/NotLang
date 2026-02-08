//
//  SavedPost.swift
//  NotLang
//
//  Created by Amier Davis on 2/7/26.
//


import Foundation
import SwiftData

@Model
class SavedPost {
    @Attribute(.unique) var id: UUID
    var author: String
    var topic: String
    var content: [TranslationChunk]
    var dateSaved: Date
    
    init(from post: LangPost) {
        self.id = post.id ?? UUID()
        self.author = post.author
        self.topic = post.topic
        self.content = post.content
        self.dateSaved = Date()
    }
}
