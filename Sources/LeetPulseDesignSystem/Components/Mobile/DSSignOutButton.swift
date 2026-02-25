// DSSignOutButton.swift
// FocusApp — Sign out button (361x48)
// Spec: FIGMA_SETUP_GUIDE.md §3.25

import SwiftUI

public struct DSSignOutButton: View {
    var onTap: (() -> Void)?


    public init(onTap: (() -> Void)? = nil) {
        self.onTap = onTap
    }

    public var body: some View {
        Button {
            onTap?()
        } label: {
            HStack(spacing: DSMobileSpacing.space8) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 16))
                Text("Sign Out")
                    .font(DSMobileTypography.bodyStrong)
            }
            .foregroundColor(DSMobileColor.red)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(DSMobileColor.redLight)
            .cornerRadius(DSMobileRadius.medium)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    DSSignOutButton()
        .padding()
}
