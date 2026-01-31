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
        TabView {
            Tab("Home", systemImage: "house") {
                FeedView()
            }
        }
    }
}

#Preview {
    ContentView()
}
