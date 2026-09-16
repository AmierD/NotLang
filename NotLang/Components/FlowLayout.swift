//
//  FlowLayout.swift
//  NotLang
//
//  Created by Amier Davis on 1/30/26.
//

import SwiftUI

/// Arranges its subviews in a horizontal flow, wrapping to the next line when
/// the proposed width is exceeded.
///
/// Suited to tag clouds, word-by-word translations, and any content whose
/// elements have variable widths and should wrap like text.
///
/// To make spacing part of the data rather than of the layout, set ``spacing``
/// to `0` and end each subview's text with a space character.
// TODO: Support alignment, justification, and per-subview spacing.
struct FlowLayout: Layout {
    /// The horizontal distance between adjacent subviews.
    var spacing: CGFloat = 3.5

    /// The vertical distance between consecutive lines of subviews.
    var lineSpacing: CGFloat = 4

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        let result = layout(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        let result = layout(proposal: proposal, subviews: subviews)
        for (index, subview) in subviews.enumerated() {
            let point = result.offsets[index]
            subview.place(
                at: CGPoint(x: point.x + bounds.minX, y: point.y + bounds.minY),
                proposal: .unspecified
            )
        }
    }

    /// Computes the offset of every subview and the total size of the layout.
    private func layout(proposal: ProposedViewSize, subviews: Subviews) -> (
        offsets: [CGPoint], size: CGSize
    ) {
        var offsets: [CGPoint] = []
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var lineHeight: CGFloat = 0
        var maxWidth: CGFloat = 0
        let widthLimit = proposal.width ?? .infinity

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)

            // Check if the current subview exceeds the line width
            if currentX + size.width > widthLimit && currentX > 0 {
                currentX = 0
                currentY += lineHeight + lineSpacing
                lineHeight = 0
            }

            offsets.append(CGPoint(x: currentX, y: currentY))

            // Track the tallest item in the current row
            lineHeight = max(lineHeight, size.height)

            // Advance the horizontal cursor
            currentX += size.width + spacing
            maxWidth = max(maxWidth, currentX)
        }

        return (offsets, CGSize(width: maxWidth, height: currentY + lineHeight))
    }
}
