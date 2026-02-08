// DSSurfaceCard.swift
// FocusApp — Surface card container
// Spec: FIGMA_SETUP_GUIDE.md §3.4

import SwiftUI
import FocusDesignSystemCore

public struct DSSurfaceCard<Content: View>: View {
    var cornerRadius: CGFloat = DSMobileRadius.medium
    var padding: CGFloat = DSMobileSpacing.space16
    @ViewBuilder var content: () -> Content


    public init(
        cornerRadius: CGFloat = DSMobileRadius.medium,
        padding: CGFloat = DSMobileSpacing.space16,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.content = content
    }

    public var body: some View {
        content()
            .padding(padding)
            .background(DSMobileColor.surface)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(DSMobileColor.divider, lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
    }
}

#Preview {
    DSSurfaceCard {
        Text("Hello")
    }
    .padding()
}
