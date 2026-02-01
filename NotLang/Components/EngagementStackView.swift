//
//  EngagementStackView.swift
//  NotLang
//
//  Created by Amier Davis on 1/13/26.
//

import SwiftUI

struct EngagementStackView: View {
    var defaultColor: Color = .gray.opacity(0.7)
    
    var body: some View {
        HStack {
            Spacer()
            Button() { } label: {
                Image(systemName: "bookmark")
            }
            Spacer()
            Button() { } label: {
                Image(systemName: "heart")
            }
            Spacer()
        }
        .foregroundStyle(defaultColor)
    }
}

#Preview {
    EngagementStackView()
}
