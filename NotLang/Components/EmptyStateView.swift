//
//  EmptyStateView.swift
//  NotLang
//
//  Created by Amier Davis on 2/9/26.
//

import SwiftUI

struct EmptyStateView: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 10) {
            Spacer()
            Text(title)
                .font(.headline)
            Text(subtitle)
                .font(.subheadline)
            Spacer()
            Spacer()
        }
        .foregroundStyle(.gray.opacity(0.5))
    }
}
