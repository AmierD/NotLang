//
//  SavedChunkView.swift
//  NotLang
//
//  Created by Amier Davis on 2/7/26.
//

import SwiftUI

struct SavedChunkView: View {
    let chunk: SavedChunk
    
    @State private var isShowingTranslation = false
    @State private var isAnimating = false
    
    var body: some View {
        Button(action: handleClick) {
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .foregroundStyle(isShowingTranslation ? .blue : .gray.opacity(0.2))
                VStack {
                    Text(isShowingTranslation ? chunk.translation : chunk.text)
                        .font(.largeTitle)
                        .foregroundStyle(isShowingTranslation ? .white : .black)
                        .scaleEffect(x: isShowingTranslation ? -1 : 1)
                }
                .padding()
            }
            .frame(width: .infinity, height: 200)
            .padding()
            
            .rotation3DEffect(
                Angle(degrees: isAnimating ? 180 : 0),
                axis: (x: 0.0, y: 1.0, z: 0.0)
            )
        }
    }
    
    func handleClick() {
        withAnimation {
            isShowingTranslation.toggle()
            isAnimating.toggle()
        }
    }
}

#Preview {
    SavedChunkView(chunk: SavedChunk(text: "Bonbon", translation: "Candy"))
}
