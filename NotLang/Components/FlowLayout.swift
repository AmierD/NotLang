//
//  FlowLayout.swift
//  NotLang
//
//  Created by Amier Davis on 1/30/26.
//

import SwiftUI

/// A container view that arranges its subviews in a horizontal flow, wrapping to the next line
/// when the available width is exceeded.
///
/// `FlowLayout` is particularly useful for tag clouds, word-by-word translations, or any
/// content where elements have variable widths and need to behave like text wrapping.
/// 
/// The layout works by calculating the size of each subview and placing them sequentially
/// along the x-axis. When a subview's width plus the current x-offset exceeds the
/// container's proposed width, the layout resets the x-offset and increments the
/// y-offset by the height of the tallest element in the previous line.
///
/// ### Handling Explicit Spaces
/// To implement explicit spaces (where the space is a property of the data rather than
/// a constant layout value):
/// 1. Set the ``spacing`` property to `0`.
/// 2. Include a space character `" "` at the end of your `TranslationChunk.text` string.
/// 3. Alternatively, create a `LayoutValueKey` to identify "space" subviews and
///    conditionally bypass the ``spacing`` logic in the `layout` function.
///
/// ### Modification
/// You can modify this layout to support:
/// - **Alignment**: Adjust the `currentX` starting position to support center or right alignment.
/// - **Justification**: Distribute remaining space on a line between elements.
/// - **Dynamic Spacing**: Use the `Subviews.Indices` to look up specific view types and
///   apply unique spacing logic.
struct FlowLayout: Layout {
    /// The horizontal distance between adjacent subviews.
    var spacing: CGFloat = 3.5
    
    /// The vertical distance between consecutive lines of subviews.
    var lineSpacing: CGFloat = 4

    /// Calculates the total size required to fit all subviews within the proposed dimensions.
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = layout(proposal: proposal, subviews: subviews)
        return result.size
    }

    /// Assigns positions to each subview based on the calculated flow geometry.
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = layout(proposal: proposal, subviews: subviews)
        for (index, subview) in subviews.enumerated() {
            let point = result.offsets[index]
            subview.place(at: CGPoint(x: point.x + bounds.minX, y: point.y + bounds.minY), proposal: .unspecified)
        }
    }

    /// Internal geometry engine that computes the coordinates for every subview.
    ///
    /// - Parameters:
    ///   - proposal: The size proposed by the parent view.
    ///   - subviews: The collection of views to be laid out.
    /// - Returns: A tuple containing an array of `CGPoint` offsets and the total `CGSize` of the layout.
    private func layout(proposal: ProposedViewSize, subviews: Subviews) -> (offsets: [CGPoint], size: CGSize) {
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
