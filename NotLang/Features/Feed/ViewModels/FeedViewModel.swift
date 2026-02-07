//
//  FeedViewModel.swift
//  NotLang
//
//  Created by Amier Davis on 1/15/26.
//

import Foundation
import Observation
import SwiftData

@Observable
/// Handles data to be presented to the feed.
///
/// >Important: The async ``fetchPosts()`` logic is only **simulating** loading. Real loading logic is yet to be implemented.
class FeedViewModel {
    var isLoading: Bool = false
    var posts: [LangPost] = []
    
    var showingAlert = false
    var errorTitle = ""
    var errorDescription = ""
    
    func fetchPosts() async {
        isLoading = true
        try? await Task.sleep(for: .seconds(1))
        let newPosts = try? await APIService.shared.fetchPosts()
        assert(newPosts != nil, "fetchPosts failed in FeedViewModel")
        
        self.posts = newPosts ?? [LangPost]()
        isLoading = false
    }
    
    func saveChunk(_ chunk: TranslationChunk, context: ModelContext) {
        do {
            let alreadySaved = try checkChunkIsSaved(chunk: chunk, context: context)
            
            guard !alreadySaved else {
                print("Chunk already exists; skipping save.")
                return
            }
            
            let savedChunk = SavedChunk(
                text: chunk.cleanedText,
                translation: chunk.cleanedTranslation
            )
            
            context.insert(savedChunk)
            
            try context.save()
            
        } catch {
            print("SwiftData Error: \(error.localizedDescription)")
        }
    }
    
    func checkChunkIsSaved(chunk: TranslationChunk, context: ModelContext) throws -> Bool {
        let textToMatch = chunk.cleanedText
        
        var descriptor = FetchDescriptor<SavedChunk>(
            predicate: #Predicate { $0.text == textToMatch }
        )
        
        descriptor.fetchLimit = 1
        
        do {
            let count = try context.fetchCount(descriptor)
            return count > 0
        } catch {
            print("SwiftData Fetch Error: \(error.localizedDescription)")
            throw error
        }
    }
    
    func unsaveChunk(_ chunk: TranslationChunk, context: ModelContext) {
        guard let savedChunk = getSavedChunk(for: chunk, context: context) else { return }
        
        context.delete(savedChunk)
    }
    
    func getSavedChunk(for chunk: TranslationChunk, context: ModelContext) -> SavedChunk? {
        let textToMatch = chunk.cleanedText
        let descriptor = FetchDescriptor<SavedChunk>(
            predicate: #Predicate { $0.text == textToMatch }
        )
        
        do {
            let matches = try context.fetch(descriptor)
            return matches.first
        } catch {
            print("Error fetching saved chunk: \(error)")
            return nil
        }
    }
}
