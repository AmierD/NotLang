//
//  EngagementStackView.swift
//  NotLang
//
//  Created by Amier Davis on 1/13/26.
//

import SwiftUI

struct EngagementStackView: View {
    var body: some View {
        HStack {
            Spacer()
            EngagementItemView(systemName: "text.bubble", count: 13)
            Spacer()
            EngagementItemView(systemName: "arrow.2.squarepath", count: 2)
            Spacer()
            EngagementItemView(systemName: "heart", count: 34)
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
