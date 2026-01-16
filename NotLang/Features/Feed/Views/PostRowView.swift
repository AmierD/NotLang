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
        VStack(spacing: 10) {
            HStack {
                Circle()
                    .frame(width: 50)
                Text(langPost.author)
                Spacer()
            }
            
            WrappingHStack(langPost.content, id: \.self, spacing: .constant(3.5)) {
                TranslationChunkView(chunk: $0)
            }
            
            HStack {
                Spacer()
                Capsule()
                    .frame(height: 1)
                Spacer()
            }
            
            EngagementStackView(
                comments: Int.random(in: 1...40),
                reposts: Int.random(in: 1...25),
                likes: Int.random(in: 20...500)
            )
        }
        .background(.blue)
        .padding()
        .background(.blue)
        .clipShape(RoundedRectangle(cornerRadius: 35))
        .padding()
        
        
    }
}

#Preview {
    PostRowView(langPost: .sample)
}
