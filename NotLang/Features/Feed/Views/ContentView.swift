//
//  ContentView.swift
//  NotLang
//
//  Created by Amier Davis on 1/12/26.
//

import SwiftUI

struct ContentView: View {
    var feedViewModel = FeedViewModel()

    var body: some View {
        ScrollView {
            LazyVStack() {
                ForEach(feedViewModel.posts) { post in
                    PostRowView(langPost: post)
                }
            }
        }
        .task {
            await feedViewModel.fetchPosts()
        }
    }
}

#Preview {
    ContentView()
}
