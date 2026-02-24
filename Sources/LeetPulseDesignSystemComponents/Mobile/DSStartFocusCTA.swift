// DSStartFocusCTA.swift
// FocusApp — Start Focus CTA card (361x88)
// Spec: FIGMA_SETUP_GUIDE.md §3.7

import SwiftUI
import LeetPulseDesignSystemCore

public struct DSStartFocusCTA: View {
    var onTap: (() -> Void)?


    public init(onTap: (() -> Void)? = nil) {
        self.onTap = onTap
    }

    public var body: some View {
        Button {
            onTap?()
        } label: {
            VStack(spacing: DSMobileSpacing.space8) {
                ZStack {
                    Circle()
                        .fill(DSMobileColor.purple.opacity(0.1))
                        .frame(width: 40, height: 40)
                    Image(systemName: "arrow.right")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(DSMobileColor.purple)
                }

                Text("Start Focus Session")
                    .font(DSMobileTypography.bodyStrong)
                    .foregroundColor(DSMobileColor.gray900)

                Text("Ready to get in the zone?")
                    .font(DSMobileTypography.caption)
                    .foregroundColor(DSMobileColor.gray500)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 88)
            .background(DSMobileColor.surface)
            .cornerRadius(DSMobileRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: DSMobileRadius.medium)
                    .strokeBorder(
                        DSMobileColor.divider,
                        style: StrokeStyle(lineWidth: 1, dash: [4])
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    DSStartFocusCTA()
        .padding()
}
