//
//  EngagementStackView.swift
//  NotLang
//
//  Created by Amier Davis on 1/13/26.
//

import SwiftUI

struct EngagementStackView: View {
    var defaultColor: Color = .gray.opacity(0.7)
    var iconSize: CGFloat = 40
    var iconFont = Font.title.weight(.medium)
    
    var body: some View {
        HStack(spacing: 40) {
            Spacer()
            Button() { } label: {
                Image(systemName: "bookmark")
                    .font(iconFont)
            }
            Spacer()
            Button() { } label: {
                Image(systemName: "heart")
                    .font(iconFont)
            }
            Spacer()
        }
        .foregroundStyle(defaultColor)
    }
}

#Preview {
    EngagementStackView()
}
