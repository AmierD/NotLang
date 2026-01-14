//
//  ContentView.swift
//  NotLang
//
//  Created by Amier Davis on 1/12/26.
//

import SwiftUI

struct ContentView: View {
    var postRows: [PostRowView]

    var body: some View {
        ScrollView {
            LazyVStack() {
                ForEach(postRows) { post in
                    post
                }
            }
        }
    }
}

#Preview {
    ContentView(postRows: [.sample, .sample2])
}
