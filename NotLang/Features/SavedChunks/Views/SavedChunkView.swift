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
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .foregroundStyle(Color.yellow.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(.yellow, lineWidth: 4)
                )
            VStack {
                HStack {
                    Text(chunk.text)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.leading)
                        .minimumScaleFactor(0.5)
                    Spacer()
                    Image(systemName: "bookmark.fill")
                        .font(.title)
                        .foregroundStyle(.yellow)
                }
                HStack {
                    Text(chunk.translation)
                        .font(.title2)
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.leading)
                        .minimumScaleFactor(0.5)
                    Spacer()
                }
                Spacer()
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: 100, maxHeight: 120)
        .padding(.trailing)
    }
}

#Preview {
    SavedChunkView(chunk: SavedChunk(text: "Bonbon", translation: "Candy"))
        .environment(SavedChunksViewModel())
}
