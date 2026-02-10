//
//  SavedChunksViewModel.swift
//  NotLang
//
//  Created by Amier Davis on 2/7/26.
//

//
//  SavedChunksViewModel.swift
//  NotLang
//
//  Created by Amier Davis on 2/7/26.
//

import Foundation
import SwiftData

@Observable
class SavedChunksViewModel {
    func saveChunk(_ chunk: TranslationChunk, context: ModelContext) {
        do {
            let alreadySaved = try checkChunkIsSaved(
                chunk: chunk,
                context: context
            )

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

    func checkChunkIsSaved(chunk: TranslationChunk, context: ModelContext)
        throws -> Bool
    {
        let textToMatch = chunk.cleanedText

        var descriptor = FetchDescriptor<SavedChunk>(
            predicate: #Predicate {
                $0.text.localizedStandardContains(textToMatch)
            }
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
        guard let savedChunk = getSavedChunk(for: chunk, context: context)
        else { return }

        context.delete(savedChunk)
    }

    func getSavedChunk(for chunk: TranslationChunk, context: ModelContext)
        -> SavedChunk?
    {
        let textToMatch = chunk.cleanedText
        let descriptor = FetchDescriptor<SavedChunk>(
            predicate: #Predicate {
                $0.text.localizedStandardContains(textToMatch)
            }
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
