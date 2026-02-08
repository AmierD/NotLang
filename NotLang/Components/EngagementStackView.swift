//
//  EngagementStackView.swift
//  NotLang
//
//  Created by Amier Davis on 1/13/26.
//

import SwiftUI

// TODO: Implement tapping eye shows/hides all translations and animates to eye.slash

struct EngagementStackView: View {
    @State private var liked = false
    @State private var isPressed = false
    var defaultColor: Color = .gray.opacity(0.7)
    var iconSize: CGFloat = 40
    var iconFont = Font.title.weight(.medium)
    var scaleEffect: CGFloat {
        if isPressed && liked {
            1.2
        } else if isPressed {
            0.9
        } else {
            1
        }
    }
    
    var body: some View {
        HStack(spacing: 40) {
            Spacer()
            Button() { } label: {
                Image(systemName: "eye")
                    .font(iconFont)
            }
            Spacer()
            Button() {
                withAnimation(.spring(duration: liked ? 0.5 : 0.2)) {
                    liked.toggle()
                    isPressed = true
                } completion: {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.4)) {
                        isPressed = false
                    }
                }
            } label: {
                Image(systemName: liked ? "heart.fill" : "heart")
                    .font(iconFont)
                    .foregroundStyle(liked ? .pink : .gray)
                    .scaleEffect(scaleEffect)
            }
            Spacer()
        }
        .foregroundStyle(defaultColor)
    }
}

#Preview {
    EngagementStackView()
}
