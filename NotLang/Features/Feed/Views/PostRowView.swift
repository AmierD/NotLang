//
//  PostRowView.swift
//  NotLang
//
//  Created by Amier Davis on 1/12/26.
//

import SwiftUI
import WrappingHStack

struct PostRowView: View {
    let langPost: LangPost
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Circle()
                    .frame(width: 50)
                Text(langPost.author)
                Spacer()
            }
            
            WrappingHStack(langPost.content, id: \.self, spacing: .constant(1)) {
                TranslationChunkView(chunk: $0)
            }
            
            HStack {
                Spacer()
                Capsule()
                    .frame(height: 1)
                Spacer()
            }
            
            EngagementStackView()
        }
        .background(.blue)
        .padding()
        .background(.green)
        .padding()
        
    }
}


/*
 TODO:
  - add animation (potentially scale) when chunk is tapped
  - add logic for explicit spaces
 */
struct TranslationChunkView: View {
    let chunk: TranslationChunk
    @State private var isShowingTranslation = false
    
    var body: some View {
        Text("\(isShowingTranslation ? chunk.translation : chunk.text)")
            .onTapGesture {
            withAnimation(.spring) {
                isShowingTranslation.toggle()
            }
        }
        .padding(.horizontal, 2)
            .overlay(
                Rectangle()
                    .stroke(
                        Color.black,
                        style: StrokeStyle(lineWidth: 2, dash: [5, 5])
                    )
                    .opacity(chunk.isPhrase ? 0.2 : 0)
            )
            .foregroundStyle(isShowingTranslation ? .indigo : .black)
    }
}

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

#Preview {
    let post = LangPost(
        author: "Amier",
        content: [
            TranslationChunk(text: "Je t'aime",
                             translation: "I love you",
                             isPhrase: true
                            ),
            TranslationChunk(text: "tellement",
                             translation: "so much",
                             isPhrase: false
                            ),
        ]
    )
    PostRowView(langPost: post)
}
