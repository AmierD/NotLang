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
    @Environment(SavedChunksViewModel.self) var savedChunksViewModel
    @Environment(\.modelContext) var modelContext
    @Query private var savedMatches: [SavedChunk]
    
    private let chunk: TranslationChunk
    @State private var isShowingTranslation = false
    @State private var isPressed = false
    
    private var isSaved: Bool {
        !savedMatches.isEmpty
    }
    
    init(chunk: TranslationChunk) {
        self.chunk = chunk
        let textToMatch = chunk.cleanedText
        _savedMatches = Query(filter: #Predicate<SavedChunk> { $0.text.localizedStandardContains(textToMatch) })
    }
    
    var body: some View {
        HStack {
            if isSaved {
                Image(systemName: "bookmark.fill")
                    .font(.caption)
                    .scaleEffect(isSaved ? 1 : 0.5)
                    .frame(width: isSaved ? nil : 0)
            }
            
            Text(isShowingTranslation ? chunk.translation : chunk.text)
                .font(.title2)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .foregroundStyle(textColor)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(backgroundColor)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSaved && !isShowingTranslation ? Color.yellow : Color.clear, lineWidth: 2)
        )
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .onTapGesture {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                isShowingTranslation.toggle()
                isPressed = false
            }
        }
        .onTapGesture(count: 2) {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                handleSave()
            }
        }
        .sensoryFeedback(.selection, trigger: isShowingTranslation)
        .sensoryFeedback(.selection, trigger: isSaved)
    }
    
    private var backgroundColor: Color {
        if isShowingTranslation { return .blue }
        return isSaved ? Color.yellow.opacity(0.2) : Color.gray.opacity(0.2)
    }
    
    private var textColor: Color {
        if isShowingTranslation { return .white }
        return isSaved ? .yellow : .primary
    }

    private func handleSave() {
        if isSaved {
            savedChunksViewModel.unsaveChunk(chunk, context: modelContext)
        } else {
            savedChunksViewModel.saveChunk(chunk, context: modelContext)
        }
        
        try? modelContext.save()
    }
    
    private func handleTap() {
        withAnimation(.easeInOut(duration: 0.1)) { isPressed = true }
    }
}

#Preview {
    TranslationChunkView(chunk: TranslationChunk.aujourdhui)
        .environment(SavedChunksViewModel())
        .modelContainer(for: SavedChunk.self)
}
