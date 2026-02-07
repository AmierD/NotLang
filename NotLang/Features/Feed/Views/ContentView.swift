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
    
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                FeedView()
                    .environment(feedViewModel)
            }
            Tab("Saved", systemImage: "bookmark") {
                SavedChunksView()
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: SavedChunk.self)
}
