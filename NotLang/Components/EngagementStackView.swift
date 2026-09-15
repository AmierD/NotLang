//
//  EngagementStackView.swift
//  NotLang
//
//  Created by Amier Davis on 1/13/26.
//

import SwiftUI

// TODO: Implement tapping eye shows/hides all translations and animates to eye.slash

struct EngagementStackView: View {
    @Binding var liked: Bool
    @Binding var hiddenButtonActive: Bool
    @State private var likePressed = false
    @State private var hiddenPressed = false

    var defaultColor: Color = .gray.opacity(0.7)
    var iconSize: CGFloat = 40
    var iconFont = Font.title.weight(.medium)
    var scaleEffect: CGFloat {
        if likePressed && liked {
            1.2
        } else if likePressed {
            0.9
        } else {
            1
        }
    }
    
    var body: some View {
        HStack(spacing: 40) {
            Spacer()
            Button {
                animateButton(
                    buttonActive: $hiddenButtonActive,
                    pressed: $hiddenPressed
                )
            } label: {
                Image(systemName: hiddenButtonActive ? "eye.slash" : "eye")
                    .font(iconFont)
                    .contentTransition(.symbolEffect(.replace))
            }
            Spacer()
            Button {
                animateButton(buttonActive: $liked, pressed: $likePressed)
            } label: {
                Image(systemName: liked ? "heart.fill" : "heart")
                    .font(iconFont)
                    .foregroundStyle(liked ? .pink : defaultColor)
                    .scaleEffect(scaleEffect)
            }
            Spacer()
        }
        .foregroundStyle(defaultColor)
        .sensoryFeedback(.selection, trigger: liked)
    }

    func animateButton(buttonActive: Binding<Bool>, pressed: Binding<Bool>) {
        withAnimation(.spring(duration: liked ? 0.5 : 0.2)) {
            buttonActive.wrappedValue.toggle()
            pressed.wrappedValue = true
        } completion: {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.4)) {
                pressed.wrappedValue = false
            }
        }
    }
}

#Preview {
    @Previewable @State var liked = false
    @Previewable @State var hiddenButtonActive = false

    EngagementStackView(liked: $liked, hiddenButtonActive: $hiddenButtonActive)
}
