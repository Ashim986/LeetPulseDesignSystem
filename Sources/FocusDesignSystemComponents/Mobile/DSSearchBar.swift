// DSSearchBar.swift
// FocusApp — Search bar (361x44)
// Spec: FIGMA_SETUP_GUIDE.md §3.24

import SwiftUI
import FocusDesignSystemCore

public struct DSSearchBar: View {
    @Binding var text: String
    var placeholder: String = "Search problems..."

    var body: some View {
        HStack(spacing: DSMobileSpacing.space8) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16))
                .foregroundColor(DSMobileColor.gray400)

            if text.isEmpty {
                Text(placeholder)
                    .font(DSMobileTypography.body)
                    .foregroundColor(DSMobileColor.gray400)
            }

            TextField("", text: $text)
                .font(DSMobileTypography.body)
                .foregroundColor(DSMobileColor.textPrimary)

            Spacer()
        }
        .padding(.horizontal, DSMobileSpacing.space12)
        .frame(height: 44)
        .background(DSMobileColor.gray100)
        .cornerRadius(DSMobileRadius.medium)
    }
}

#Preview {
    DSSearchBar(text: .constant(""))
        .padding()
}
