//
//  FeedViewModel.swift
//  NotLang
//
//  Created by Amier Davis on 1/15/26.
//

import Foundation
import Observation
import SwiftData

@Observable
/// Handles data to be presented to the feed.
///
/// >Important: The async ``fetchPosts()`` logic is only **simulating** loading. Real loading logic is yet to be implemented.
class FeedViewModel {
    var isLoading: Bool = false
    var posts: [LangPost] = []
    
    func fetchPosts() async {
        isLoading = true
        try? await Task.sleep(for: .seconds(1))
        let newPosts = try? await APIService.shared.fetchPosts()
        assert(newPosts != nil, "fetchPosts failed in FeedViewModel")
        
        self.posts = newPosts ?? [LangPost]()
        isLoading = false
    }
}
