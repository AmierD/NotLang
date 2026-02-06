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
                    TranslationChunkView(chunk: $0)
                        .fixedSize()
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            EngagementStackView()
        }
        .padding()
        .clipShape(RoundedRectangle(cornerRadius: 35))
        .padding(5)
        .background(.white)
    }
}

#Preview {
    PostRowView(langPost: LangPost.bakeryOrder)
}
