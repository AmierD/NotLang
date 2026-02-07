//
//  SavedChunksView.swift
//  NotLang
//
//  Created by Amier Davis on 2/7/26.
//

import SwiftData
import SwiftUI

struct SavedChunksView: View {
    @Query var savedChunks: [SavedChunk]
    
    var body: some View {
        ScrollView {
            ForEach(savedChunks) { chunk in
                SavedChunkView(chunk: chunk)
            }
            // TODO: Add delete functionality
        }
    }
}

#Preview {
    SavedChunksView()
        .modelContainer(for: SavedChunk.self)
}
