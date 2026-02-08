//
//  PostRowView.swift
//  NotLang
//
//  Created by Amier Davis on 1/12/26.
//

// TODO: Make show all translations button smart to when all are shown or hidden already

import SwiftUI
import WrappingHStack

struct PostRowView: View, Identifiable {
    let langPost: LangPost
    @State private var liked = false
    @State private var hiddenButtonActive = false
    @State private var showAllTranslations = false
    var id: UUID {
        langPost.id ?? UUID()
    }
    
    var body: some View {
        VStack(spacing: 30) {
            HStack {
                Circle()
                    .frame(width: 50)
                Text(langPost.author)
                Spacer()
            }
            FlowLayout(spacing: 3.5, lineSpacing: 4) {
                ForEach(langPost.content) {
                    TranslationChunkView(chunk: $0, showAll: $showAllTranslations)
                        .fixedSize()
                }
            }
            
            .frame(maxWidth: .infinity, alignment: .leading)
            
            EngagementStackView(liked: $liked, hiddenButtonActive: $hiddenButtonActive)
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.7), value: showAllTranslations)
        .padding()
        .clipShape(RoundedRectangle(cornerRadius: 35))
        .padding(5)
        .background(.white)
        // TODO: Fix animation
        .onChange(of: hiddenButtonActive) {
//            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                showAllTranslations = hiddenButtonActive
//            }
        }
    }
}

#Preview {
    PostRowView(langPost: LangPost.bakeryOrder)
        .environment(FeedViewModel())
        .environment(SavedChunksViewModel())
}
