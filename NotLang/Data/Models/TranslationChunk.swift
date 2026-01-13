//
//  TranslationChunk.swift
//  NotLang
//
//  Created by Amier Davis on 1/12/26.
//

import Foundation

struct TranslationChunk: Identifiable, Hashable {
    let id: UUID = UUID()
    
    let text: String
    let translation: String
    let isPhrase: Bool
}
