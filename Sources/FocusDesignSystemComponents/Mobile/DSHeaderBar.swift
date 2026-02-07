// DSHeaderBar.swift
// FocusApp — iPhone header bar (393x44)
// Spec: FIGMA_SETUP_GUIDE.md §3.3

import SwiftUI
import FocusDesignSystemCore

public struct DSHeaderBar: View {
    var title: String = "FocusApp"
    var showSettings: Bool = true
    var onSettingsTap: (() -> Void)?

    var body: some View {
        HStack {
            Spacer()

            Text(title)
                .font(DSMobileTypography.bodyStrong)
                .foregroundColor(DSMobileColor.textPrimary)

            Spacer()
        }
        .overlay(alignment: .trailing) {
            if showSettings {
                Button {
                    onSettingsTap?()
                } label: {
                    Image(systemName: "gearshape")
                        .font(.system(size: 20))
                        .foregroundColor(DSMobileColor.gray600)
                        .frame(width: 24, height: 24)
                }
                .buttonStyle(.plain)
                .padding(.trailing, DSMobileSpacing.space16)
            }
        }
        .frame(height: 44)
        .padding(.horizontal, DSMobileSpacing.space16)
        .background(DSMobileColor.background)
    }
}

#Preview {
    DSHeaderBar()
}
