//
//  EngagementStackView.swift
//  NotLang
//
//  Created by Amier Davis on 1/13/26.
//

import SwiftUI

struct EngagementStackView: View {
    @State var comments: Int
    @State var reposts: Int
    @State var likes: Int
    
    var body: some View {
        HStack {
            Spacer()
            EngagementItemView(systemName: "text.bubble", count: comments)
            Spacer()
            EngagementItemView(systemName: "arrow.2.squarepath", count: reposts)
            Spacer()
            EngagementItemView(systemName: "heart", count: likes)
            Spacer()
        }
    }
}

struct EngagementItemView: View {
    var systemName: String
    var count: Int
    
    var body: some View {
        HStack(spacing: 3) {
            Button() { } label: {
                Image(systemName: systemName)
                    .foregroundStyle(.black)
            }
            Text("\(count)")
                .font(.footnote)
        }
    }
}
