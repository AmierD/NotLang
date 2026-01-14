//
//  MockData.swift
//  NotLang
//
//  Created by Amier Davis on 1/13/26.
//

import Foundation

extension TranslationChunk {
    static let sample = TranslationChunk(
        text: "Je t'aime",
        translation: "I love you",
        isPhrase: true
    )
    static let sample2 = TranslationChunk(
        text: "tellement",
        translation: "so much",
        isPhrase: false
    )
    static let sample3 = TranslationChunk(
        text: "Tout le monde",
        translation: "Everyone",
        isPhrase: true
    )
}

extension LangPost {
    static let sample = LangPost(author: "Amier", content: [.sample, .sample2])
    static let sample2 = LangPost(author: "John", content: [.sample3])
}

extension PostRowView {
    static let sample = PostRowView(langPost: .sample)
    static let sample2 = PostRowView(langPost: .sample2)
}
