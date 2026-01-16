//
//  FeedViewModel.swift
//  NotLang
//
//  Created by Amier Davis on 1/15/26.
//

import Observation

@Observable
/// Handles data to be presented to the feed.
///
/// >Important: The async ``fetchPosts()`` logic is only **simulating** loading. Real loading logic is yet to be implemented.
class FeedViewModel {
    var isLoading: Bool = false
    
    var posts: [LangPost] = []
    
    // TODO: Add logic for fetching new posts
    func fetchPosts() async {
        isLoading = true
        
        try? await Task.sleep(for: .seconds(2))
        
        self.posts.append(LangPost.sample)
        self.posts.append(LangPost.sample2)
        isLoading = false
    }
}
