// DSBottomTabBar.swift
// FocusApp — iPhone bottom tab bar (393x83)
// Spec: FIGMA_SETUP_GUIDE.md §3.1

import SwiftUI
import LeetPulseDesignSystemCore

public enum AppTab: String, CaseIterable {
    case today = "Today"
    case plan = "Plan"
    case stats = "Stats"
    case focus = "Focus"
    case coding = "Coding"

    var iconName: String {
        switch self {
        case .today: return "house"
        case .plan: return "calendar"
        case .stats: return "chart.bar"
        case .focus: return "bolt.fill"
        case .coding: return "chevron.left.forwardslash.chevron.right"
        }
    }

    var activeIconName: String {
        switch self {
        case .today: return "house.fill"
        case .plan: return "calendar"
        case .stats: return "chart.bar.fill"
        case .focus: return "bolt.fill"
        case .coding: return "chevron.left.forwardslash.chevron.right"
        }
    }
}

public struct DSBottomTabBar: View {
    @Binding var selectedTab: AppTab


    public init(selectedTab: Binding<AppTab>) {
        self._selectedTab = selectedTab
    }

    public var body: some View {
        VStack(spacing: 0) {
            // Top border
            Rectangle()
                .fill(DSMobileColor.divider)
                .frame(height: 0.5)

            HStack(spacing: 0) {
                ForEach(AppTab.allCases, id: \.self) { tab in
                    Button {
                        selectedTab = tab
                    } label: {
                        VStack(spacing: DSMobileSpacing.space4) {
                            Image(systemName: selectedTab == tab ? tab.activeIconName : tab.iconName)
                                .font(.system(size: 24))
                                .frame(width: 24, height: 24)

                            Text(tab.rawValue)
                                .font(DSMobileTypography.micro)
                        }
                        .foregroundColor(selectedTab == tab ? DSMobileColor.purple : DSMobileColor.gray400)
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.top, DSMobileSpacing.space8)
            .padding(.bottom, 34) // Safe area
        }
        .background(DSMobileColor.surface)
    }
}

#Preview {
    DSBottomTabBar(selectedTab: .constant(.today))
}
