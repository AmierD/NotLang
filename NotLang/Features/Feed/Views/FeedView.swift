//
//  FeedView.swift
//  NotLang
//
//  Created by Amier Davis on 1/15/26.
//

import SwiftUI

struct FeedView: View {
    @State var feedViewModel = FeedViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .opacity(feedViewModel.isLoading ? 1 : 0)
                    if feedViewModel.isLoading {
                        Text("Loading")
                            .opacity(0.4)
                    }
                }
                // TODO: make ScrollView refreshable
                ScrollView {
                    LazyVStack() {
                        ForEach(feedViewModel.posts) { post in
                            PostRowView(langPost: post)
                        }
                    }
                }
                .opacity(feedViewModel.isLoading ? 0 : 1)
                .animation(.easeInOut, value: feedViewModel.isLoading)
                
                if feedViewModel.posts.isEmpty && !feedViewModel.isLoading {
                    Text("No posts found")
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
            await feedViewModel.fetchPosts()
        }
    }
}

#Preview {
    FeedView(feedViewModel: FeedViewModel())
}
