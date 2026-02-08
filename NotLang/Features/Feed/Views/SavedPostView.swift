//
//  SavedPostView.swift
//  NotLang
//
//  Created by Amier Davis on 2/7/26.
//

import SwiftData
import SwiftUI

struct SavedPostView: View {
    @Query var savedPosts: [SavedPost]
    
    var body: some View {
        NavigationStack {
            if savedPosts.isEmpty {
                VStack(spacing: 10) {
                    Spacer()
                    Text("No liked posts.")
                        .font(.headline)
                    HStack(spacing: 5) {
                        Text("Tap the")
                        Image(systemName: "heart")
                            .font(.subheadline.bold())
                        Text("on a post to like it.")
                    }
                        .font(.subheadline)
                    Spacer()
                    Spacer()
                }
                .foregroundStyle(.gray.opacity(0.5))
                .navigationTitle("Liked Posts")
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: SavedPost.self, configurations: config)
        
        return SavedPostView()
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview container: \(error.localizedDescription)")
    }
}
