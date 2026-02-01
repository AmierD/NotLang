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
                withAnimation(.spring) {
                    isShowingTranslation.toggle()
                }
            }
            .font(.title2)
            .padding(.horizontal, 2)
            .background {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundStyle(.gray.opacity(0.3))
            }
            .foregroundStyle(isShowingTranslation ? .indigo : .black)
    }
}

#Preview {
    TranslationChunkView(chunk: TranslationChunk.aujourdhui)
}
