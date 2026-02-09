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
    let navigationTitle = "Liked Posts"
    
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
                .navigationTitle(navigationTitle)
            } else {
                ScrollView {
                    ForEach(savedPosts) { post in
                        PostRowView(post: post)
                    }
                }
                .navigationTitle(navigationTitle)
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: SavedPost.self, configurations: config)
        
        let mocks = [
            LangPost.bakeryOrder,
            LangPost.cityLove
        ]
        
        return Group {
            SavedPostView()
                .modelContainer(container)
                .environment(SavedChunksViewModel())
                .environment(SavedPostsViewModel())
            
            Button("Add Mocks") {
                for post in mocks {
                    let newSavedPost = SavedPost(from: post)
                    container.mainContext.insert(newSavedPost)
                }
                
                try? container.mainContext.save()
            }
        }
    } catch {
        return Text("Failed to create preview container: \(error.localizedDescription)")
    }
}
