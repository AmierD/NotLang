//
//  TranslationChunkView.swift
//  NotLang
//
//  Created by Amier Davis on 1/13/26.
//

import SwiftData
import SwiftUI

/*
 TODO:
  - add animation (potentially scale) when chunk is tapped
  - add logic for explicit spaces
 */
/// A view showcasing a ``TranslationChunk``.
///
/// > Important: Spaces are currently to be implemented as implicit (meaning that spaces are not included in a translation chunk, and as a result all translation chunks are given equal spacing between eachother as dictated by the spacing of the view they are in) to expedite shipment of MVP. However, this should be updated to be explicit so that the LLM can (more reliably) decide spacing.
struct TranslationChunkView: View {
    @Environment(FeedViewModel.self) var feedViewModel
    @Environment(\.modelContext) var modelContext
    
    let chunk: TranslationChunk
    
    @Query private var savedMatches: [SavedChunk]
    @State private var isShowingTranslation = false
    
    init(chunk: TranslationChunk) {
        self.chunk = chunk
        let textToMatch = chunk.cleanedText
        _savedMatches = Query(filter: #Predicate<SavedChunk> { $0.text == textToMatch })
    }
    
    var isSaved: Bool {
        !savedMatches.isEmpty
    }
    
    var body: some View {
        Text("\(isShowingTranslation ? chunk.translation : chunk.text)")
            .onTapGesture {
                withAnimation(.spring(duration: 0.3, bounce: 0.4)) {
                    isShowingTranslation.toggle()
                }
            }
            .font(.title2)
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(isShowingTranslation ? .blue : .gray.opacity(0.3))
            }
            .foregroundStyle(isShowingTranslation ? .white : .black)
            .shadow(color: isShowingTranslation ? .blue.opacity(0.3) : .clear, radius: isShowingTranslation ? 6 : 0)
            .sensoryFeedback(.selection, trigger: isShowingTranslation)
            .contextMenu {
                Button {
                    isSaved ? feedViewModel.unsaveChunk(chunk, context: modelContext) :
                    feedViewModel.saveChunk(chunk, context: modelContext)
                } label: {
                    Image(systemName: isSaved ? "bookmark.slash" : "bookmark")
                    Text(isSaved ? "Unsave" : "Save")
                }
            }
            .id("\(chunk.cleanedText)-\(isSaved)")
    }
}

#Preview {
    @Previewable @State var feedViewModel = FeedViewModel()
    
    TranslationChunkView(chunk: TranslationChunk.aujourdhui)
        .environment(feedViewModel)
        .modelContainer(for: SavedChunk.self)
}
