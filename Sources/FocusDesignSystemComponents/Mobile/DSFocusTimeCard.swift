// DSFocusTimeCard.swift
// FocusApp — Focus time display card (361x100)
// Spec: FIGMA_SETUP_GUIDE.md §3.6

import SwiftUI
import FocusDesignSystemCore

public struct DSFocusTimeCard: View {
    var focusTime: String = "2h 15m"
    var remainingText: String = "35m remaining today"

    var body: some View {
        DSSurfaceCard {
            HStack(spacing: DSMobileSpacing.space12) {
                // Pulse icon in circle
                ZStack {
                    Circle()
                        .fill(DSMobileColor.greenLight)
                        .frame(width: 40, height: 40)
                    Image(systemName: "waveform.path.ecg")
                        .font(.system(size: 18))
                        .foregroundColor(DSMobileColor.green)
                }

                VStack(alignment: .leading, spacing: DSMobileSpacing.space4) {
                    Text("Focus Time")
                        .font(DSMobileTypography.subbodyStrong)
                        .foregroundColor(DSMobileColor.gray500)

                    Text(focusTime)
                        .font(DSMobileTypography.headline)
                        .foregroundColor(DSMobileColor.gray900)

                    Text(remainingText)
                        .font(DSMobileTypography.caption)
                        .foregroundColor(DSMobileColor.gray500)
                }

                Spacer()
            }
        }
    }
}

#Preview {
    DSFocusTimeCard()
        .padding()
}
