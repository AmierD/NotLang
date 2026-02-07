//
//  EngagementStackView.swift
//  NotLang
//
//  Created by Amier Davis on 1/13/26.
//

import SwiftUI

// TODO: Implement tapping eye shows/hides all translations and animates to eye.slash

struct EngagementStackView: View {
    var defaultColor: Color = .gray.opacity(0.7)
    var iconSize: CGFloat = 40
    var iconFont = Font.title.weight(.medium)
    
    var body: some View {
        HStack(spacing: 40) {
            Spacer()
            Button() { } label: {
                Image(systemName: "eye")
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
