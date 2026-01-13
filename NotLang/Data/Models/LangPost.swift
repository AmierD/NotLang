//
//  LangPost.swift
//  NotLang
//
//  Created by Amier Davis on 1/12/26.
//

import Foundation

struct LangPost: Identifiable {
    let id: UUID = UUID()
    
    let author: String
    let content: [TranslationChunk]
}
