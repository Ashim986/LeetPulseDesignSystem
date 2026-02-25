// DSSettingsRow.swift
// FocusApp — Settings row (56px height)
// Spec: FIGMA_SETUP_GUIDE.md §3.23

import SwiftUI

public struct DSSettingsRow: View {
    var iconName: String
    var title: String
    var subtitle: String?
    var statusText: String?


    public init(
        iconName: String,
        title: String,
        subtitle: String? = nil,
        statusText: String? = nil
    ) {
        self.iconName = iconName
        self.title = title
        self.subtitle = subtitle
        self.statusText = statusText
    }

    public var body: some View {
        HStack(spacing: DSMobileSpacing.space12) {
            // Icon in circle
            ZStack {
                Circle()
                    .fill(DSMobileColor.gray100)
                    .frame(width: 36, height: 36)
                Image(systemName: iconName)
                    .font(.system(size: 16))
                    .foregroundColor(DSMobileColor.gray600)
            }

            // Content
            VStack(alignment: .leading, spacing: DSMobileSpacing.space2) {
                Text(title)
                    .font(DSMobileTypography.bodyStrong)
                    .foregroundColor(DSMobileColor.gray900)

                if let subtitle {
                    Text(subtitle)
                        .font(DSMobileTypography.caption)
                        .foregroundColor(DSMobileColor.gray500)
                }
            }

            Spacer()

            if let statusText {
                Text(statusText)
                    .font(DSMobileTypography.subbody)
                    .foregroundColor(DSMobileColor.gray500)
            }

            // Chevron
            Image(systemName: "chevron.right")
                .font(.system(size: 12))
                .foregroundColor(DSMobileColor.gray400)
        }
        .padding(.horizontal, DSMobileSpacing.space16)
        .frame(height: 56)
    }
}

#Preview {
    VStack(spacing: 0) {
        DSSettingsRow(iconName: "person", title: "Profile", subtitle: "John Doe")
        Divider().padding(.leading, 64)
        DSSettingsRow(iconName: "shield", title: "Security", subtitle: "Password, 2FA")
    }
}
