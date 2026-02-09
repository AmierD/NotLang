//
//  SavedPostsViewModel.swift
//  NotLang
//
//  Created by Amier Davis on 2/8/26.
//

import Foundation
import SwiftData

@Observable
class SavedPostsViewModel {
    func isPostSaved(post: Post, context: ModelContext) -> Bool {
        return (try? checkPostIsSaved(post: post, context: context)) ?? false
    }
    
    func syncLikeStatus(post: Post, isLiked: Bool, context: ModelContext) {
        let currentlySaved = isPostSaved(post: post, context: context)
        
        if isLiked && !currentlySaved {
            savePost(post: post, context: context)
        } else if !isLiked && currentlySaved {
            unsavePost(post: post, context: context)
        }
    }
    
    func savePost(post: Post, context: ModelContext) {
        if let langPost = post as? LangPost {
            let savedPost = SavedPost(from: langPost)
            context.insert(savedPost)
        }
        
        if let savedPost = post as? SavedPost {
            context.insert(savedPost)
        }
        
        try? context.save()
    }
    
    func unsavePost(post: Post, context: ModelContext) {
        let idToMatch = post.id
        try? context.delete(model: SavedPost.self, where: #Predicate { $0.id == idToMatch })
        try? context.save()
    }
    
    func checkPostIsSaved(post: Post, context: ModelContext) throws -> Bool {
        let idToMatch = post.id
        
        let descriptor = FetchDescriptor<SavedPost>(
            predicate: #Predicate { $0.id == idToMatch }
        )
        
        do {
            let count = try context.fetchCount(descriptor)
            return count > 0
        } catch {
            print("SwiftData Fetch Error: \(error.localizedDescription)")
            throw error
        }
    }
}
