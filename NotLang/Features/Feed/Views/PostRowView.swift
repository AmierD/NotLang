//
//  PostRowView.swift
//  NotLang
//
//  Created by Amier Davis on 1/12/26.
//

import SwiftUI
import WrappingHStack

struct PostRowView: View, Identifiable {
    let langPost: LangPost
    var id: UUID {
        langPost.id
    }
    
    var body: some View {
        VStack(spacing: 18) {
            HStack {
                Circle()
                    .frame(width: 50)
                Text(langPost.author)
                Spacer()
            }
            FlowLayout(spacing: 3.5, lineSpacing: 4) {
                ForEach(langPost.content) {
                    TranslationChunkView(chunk: $0)
                        .fixedSize()
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            EngagementStackView()
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 35)
                .stroke(Color.gray.opacity(0.2), lineWidth: 5)
                .mask(
                    GeometryReader { geo in
                        ZStack {
                            // Top-Left Corner
                            Rectangle()
                                .frame(width: geo.size.width * 0.09, height: geo.size.height * 0.15)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                            
                            // Bottom-Right Corner
                            Rectangle()
                                .frame(width: geo.size.width * 0.09, height: geo.size.height * 0.15)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                        }
                    }
                )
        )
        .clipShape(RoundedRectangle(cornerRadius: 35))
        .padding(5)
        .background(.white)
    }
}

#Preview {
    PostRowView(langPost: LangPost.bakeryOrder)
}
