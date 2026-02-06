//
//  TranslationChunkView.swift
//  NotLang
//
//  Created by Amier Davis on 1/13/26.
//

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
    let chunk: TranslationChunk
    @State private var isShowingTranslation = false
    
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
    }
}

#Preview {
    TranslationChunkView(chunk: TranslationChunk.aujourdhui)
}
