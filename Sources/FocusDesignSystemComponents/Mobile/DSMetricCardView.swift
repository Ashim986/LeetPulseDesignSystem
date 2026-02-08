// DSMetricCardView.swift
// FocusApp — Metric card (label + large value)
// Spec: FIGMA_SETUP_GUIDE.md §3.11

import SwiftUI
import FocusDesignSystemCore

public struct DSMetricCardView: View {
    var label: String
    var value: String


    public init(label: String, value: String) {
        self.label = label
        self.value = value
    }

    public var body: some View {
        DSSurfaceCard {
            VStack(spacing: DSMobileSpacing.space4) {
                Text(label)
                    .font(DSMobileTypography.caption)
                    .foregroundColor(DSMobileColor.gray500)

                Text(value)
                    .font(DSMobileTypography.headline)
                    .foregroundColor(DSMobileColor.gray900)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    HStack(spacing: DSMobileSpacing.space8) {
        DSMetricCardView(label: "Total Focus", value: "34h 12m")
        DSMetricCardView(label: "Current Streak", value: "12 Days")
    }
    .padding()
}
