//
//  FeedView.swift
//  NotLang
//
//  Created by Amier Davis on 1/15/26.
//

import SwiftUI

struct FeedView: View {
    @Environment(FeedViewModel.self) var feedViewModel
    
    static var appLaunched = false

    var body: some View {
        @Bindable var viewModel = feedViewModel
        
        NavigationStack {
            ZStack {
                VStack {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .opacity(feedViewModel.isLoading ? 1 : 0)
                    if feedViewModel.isLoading {
                        Text("Loading posts")
                            .opacity(0.4)
                    }
                }
                ScrollView {
                    LazyVStack(spacing: 50) {
                        ForEach(feedViewModel.posts) { post in
                            PostRowView(post: post)
                        }
                    }
                }
                .opacity(feedViewModel.isLoading ? 0 : 1)
                .animation(.easeInOut, value: feedViewModel.isLoading)
                .refreshable {
                    await feedViewModel.fetchPosts()
                }
                
                if feedViewModel.posts.isEmpty && !feedViewModel.isLoading {
                    Text("No posts found, please try again later.")
                        .opacity(0.4)
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Not Lang")
                        .font(.largeTitle.weight(.heavy))
                }
            }
        }
        .task {
            if feedViewModel.posts.isEmpty { await feedViewModel.fetchPosts() }
        }
    }
}

#Preview {
    FeedView()
        .environment(FeedViewModel())
        .environment(SavedChunksViewModel())
        .environment(SavedPostsViewModel())
}
