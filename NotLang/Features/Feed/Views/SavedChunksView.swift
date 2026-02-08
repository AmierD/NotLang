//
//  SavedChunksView.swift
//  NotLang
//
//  Created by Amier Davis on 2/7/26.
//

import SwiftData
import SwiftUI

// TODO: Add delete functionality
// TODO: Add screen for no saved chunks

struct SavedChunksView: View {
    @Query var savedChunks: [SavedChunk]
    
    var body: some View {
        if savedChunks.isEmpty {
            VStack(spacing: 10) {
                Text("No saved chunks.")
                    .font(.headline)
                Text("Double tap a chunk in your feed to save it.")
                    .font(.subheadline)
            }
            .foregroundStyle(.gray.opacity(0.5))
            
        } else {
            ScrollView {
                ForEach(savedChunks) { chunk in
                    SavedChunkView(chunk: chunk)
                }
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: SavedChunk.self, configurations: config)
        
        let mocks = [
            SavedChunk(text: "Bonjour", translation: "Hello"),
            SavedChunk(text: "Bibliothèque", translation: "Library"),
            SavedChunk(text: "Pomme de terre", translation: "Potato")
        ]
        
        return Group {
            SavedChunksView()
                .modelContainer(container)
                .environment(SavedChunksViewModel())
            Button("Add") {
                for chunk in mocks {
                    container.mainContext.insert(chunk)
                }
            }
        }
    } catch {
        return Text("Failed to create preview container: \(error.localizedDescription)")
    }
}
