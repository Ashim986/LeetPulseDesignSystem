// DSStreakBadge.swift
// FocusApp — Streak badge (orange pill)
// Spec: FIGMA_SETUP_GUIDE.md §3.10

import SwiftUI

public struct DSStreakBadge: View {
    var streakDays: Int = 12


    public init(streakDays: Int = 12) {
        self.streakDays = streakDays
    }

    public var body: some View {
        HStack(spacing: DSMobileSpacing.space4) {
            Text("🔥")
                .font(.system(size: 14))

            Text("\(streakDays) Day Streak")
                .font(DSMobileTypography.subbodyStrong)
                .foregroundColor(DSMobileColor.streakText)
        }
        .padding(.horizontal, DSMobileSpacing.space12)
        .padding(.vertical, DSMobileSpacing.space8)
        .background(DSMobileColor.streakBg)
        .cornerRadius(DSMobileRadius.full)
        .overlay(
            Capsule()
                .stroke(DSMobileColor.streakBorder, lineWidth: 1)
        )
    }
}

#Preview {
    DSStreakBadge()
}
