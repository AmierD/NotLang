//
//  ContentView.swift
//  NotLang
//
//  Created by Amier Davis on 1/12/26.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @State private var feedViewModel = FeedViewModel()
    @State private var savedChunksViewModel = SavedChunksViewModel()
    @State private var savedPostsViewModel = SavedPostsViewModel()
    
    var body: some View {
        TabView {
            Tab("Feed", systemImage: "house") {
                FeedView()
                    .environment(feedViewModel)
                    .environment(savedChunksViewModel)
                    .environment(savedPostsViewModel)
            }
            Tab("Saved", systemImage: "bookmark") {
                SavedChunksView()
                    .environment(savedChunksViewModel)
            }
            Tab("Liked", systemImage: "heart") {
                SavedPostView()
                    .environment(savedPostsViewModel)
                    .environment(savedChunksViewModel)
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let schema = Schema([SavedChunk.self, SavedPost.self])
        let container = try ModelContainer(for: schema, configurations: config)
        
        return ContentView()
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview container: \(error.localizedDescription)")
    }
}
