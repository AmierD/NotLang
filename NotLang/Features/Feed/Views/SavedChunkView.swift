//
//  SavedChunkView.swift
//  NotLang
//
//  Created by Amier Davis on 2/7/26.
//

import SwiftData
import SwiftUI

struct SavedChunkView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(SavedChunksViewModel.self) var savedChunksViewModel
    let chunk: SavedChunk
    
    @State private var isShowingTranslation = false
    @State private var isAnimating = false
    
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .foregroundStyle(isShowingTranslation ? .blue : .gray.opacity(0.2))
            VStack {
                Text(isShowingTranslation ? chunk.translation : chunk.text)
                    .font(.largeTitle)
                    .foregroundStyle(isShowingTranslation ? .white : .black)
                    .scaleEffect(x: isShowingTranslation ? -1 : 1)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.5)
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 200)
        .padding()
        
        .rotation3DEffect(
            Angle(degrees: isAnimating ? 180 : 0),
            axis: (x: 0.0, y: 1.0, z: 0.0)
        )
        .onTapGesture(perform: handleClick)
        .contextMenu {
            Button("Unsave", systemImage: "bookmark.slash", role: .destructive) {
                modelContext.delete(chunk)
            }
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
        .environment(SavedChunksViewModel())
}
