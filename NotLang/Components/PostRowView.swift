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
    @Environment(\.modelContext) var modelContext
    @Environment(SavedPostsViewModel.self) var savedPostsViewModel
    let post: Post
    @State private var liked = false
    @State private var hiddenButtonActive = false
    @State private var showAllTranslations = false

    var firstletter: String {
        String(post.author.first ?? "X")
    }

    var id: UUID {
        post.id
    }

    var body: some View {
        VStack(spacing: 30) {
            HStack {
                ZStack {
                    Circle()
                        .foregroundStyle(Color.randomNonWhite())
                    Text(firstletter)
                        .foregroundStyle(.white)
                        .font(.title)
                        .fontDesign(.rounded)
                }
                .frame(width: 50)
                Text(post.author)
                Spacer()
            }
            FlowLayout(spacing: 3.5, lineSpacing: 4) {
                ForEach(post.content) {
                    TranslationChunkView(
                        chunk: $0,
                        showAll: $showAllTranslations
                    )
                    .fixedSize()
                }
            }

            .frame(maxWidth: .infinity, alignment: .leading)

            EngagementStackView(
                liked: $liked,
                hiddenButtonActive: $hiddenButtonActive
            )
        }
        .animation(
            .spring(response: 0.35, dampingFraction: 0.7),
            value: showAllTranslations
        )
        .padding()
        .clipShape(RoundedRectangle(cornerRadius: 35))
        .padding(5)
        .background(.white)
        // TODO: Fix animation
        .onChange(of: hiddenButtonActive) {
            showAllTranslations = hiddenButtonActive
        }
        .onChange(of: liked) { oldValue, newValue in
            savedPostsViewModel.syncLikeStatus(
                post: post,
                isLiked: newValue,
                context: modelContext
            )
        }
        .task {
            liked = savedPostsViewModel.isPostSaved(
                post: post,
                context: modelContext
            )
        }
    }
}

#Preview {
    PostRowView(post: LangPost.bakeryOrder)
        .environment(FeedViewModel())
        .environment(SavedChunksViewModel())
        .environment(SavedPostsViewModel())
}
