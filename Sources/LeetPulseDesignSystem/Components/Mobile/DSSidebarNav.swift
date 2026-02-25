// DSSidebarNav.swift
// FocusApp — iPad sidebar navigation (260 x full height)
// Spec: FIGMA_SETUP_GUIDE.md §3.2

import SwiftUI

public enum SidebarItem: String, CaseIterable {
    case today = "Today"
    case plan = "Plan"
    case stats = "Stats"
    case focus = "Focus"
    case coding = "Coding"
    case settings = "Settings"

    var iconName: String {
        switch self {
        case .today: return "house"
        case .plan: return "calendar"
        case .stats: return "chart.bar"
        case .focus: return "bolt.fill"
        case .coding: return "chevron.left.forwardslash.chevron.right"
        case .settings: return "gearshape"
        }
    }
}

public struct DSSidebarNav: View {
    @Binding var selectedItem: SidebarItem


    public init(selectedItem: Binding<SidebarItem>) {
        self._selectedItem = selectedItem
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Title
            Text("FocusApp")
                .font(DSMobileTypography.section)
                .foregroundColor(DSMobileColor.textPrimary)
                .padding(.horizontal, DSMobileSpacing.space24)
                .padding(.top, DSMobileSpacing.space24)

            Spacer().frame(height: DSMobileSpacing.space24)

            // Nav items
            VStack(spacing: DSMobileSpacing.space4) {
                ForEach(SidebarItem.allCases, id: \.self) { item in
                    Button {
                        selectedItem = item
                    } label: {
                        HStack(spacing: DSMobileSpacing.space12) {
                            Image(systemName: item.iconName)
                                .font(.system(size: 18))
                                .frame(width: 20, height: 20)
                            Text(item.rawValue)
                                .font(DSMobileTypography.body)
                        }
                        .foregroundColor(
                            selectedItem == item ? DSMobileColor.purple : DSMobileColor.gray500
                        )
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, DSMobileSpacing.space12)
                        .frame(height: 44)
                        .background(
                            selectedItem == item
                                ? DSMobileColor.purple.opacity(0.1)
                                : Color.clear
                        )
                        .cornerRadius(DSMobileRadius.small)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, DSMobileSpacing.space12)

            Spacer()

            // User profile
            HStack(spacing: DSMobileSpacing.space12) {
                ZStack {
                    Circle()
                        .fill(DSMobileColor.purple)
                        .frame(width: 36, height: 36)
                    Text("JD")
                        .font(DSMobileTypography.subbodyStrong)
                        .foregroundColor(.white)
                }

                VStack(alignment: .leading, spacing: DSMobileSpacing.space2) {
                    Text("John Doe")
                        .font(DSMobileTypography.subbodyStrong)
                        .foregroundColor(DSMobileColor.gray900)
                    Text("Pro Plan")
                        .font(DSMobileTypography.caption)
                        .foregroundColor(DSMobileColor.gray500)
                }
            }
            .padding(DSMobileSpacing.space16)
        }
        .frame(width: 260)
        .background(DSMobileColor.surface)
        .overlay(alignment: .trailing) {
            Rectangle()
                .fill(DSMobileColor.divider)
                .frame(width: 1)
        }
    }
}

#Preview {
    DSSidebarNav(selectedItem: .constant(.today))
        .frame(height: 800)
}
