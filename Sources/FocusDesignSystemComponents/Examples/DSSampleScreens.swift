import SwiftUI
import FocusDesignSystemCore

public struct DSSampleMobileAppView: View {
    @State private var selectedTab = "today"

    public init() {}

    public var body: some View {
        let items = [
            DSNavItem(id: "today", title: "Today", systemImage: "house"),
            DSNavItem(id: "plan", title: "Plan", systemImage: "calendar"),
            DSNavItem(id: "stats", title: "Stats", systemImage: "chart.bar"),
            DSNavItem(id: "focus", title: "Focus", systemImage: "bolt"),
            DSNavItem(id: "coding", title: "Coding", systemImage: "chevron.left.slash.chevron.right")
        ]

        DSTabScaffold(items: items, state: .init(selectedId: selectedTab)) { id in
            selectedTab = id
        } content: {
            sampleContent(for: selectedTab)
                .padding(.horizontal, 16)
                .padding(.top, 20)
        }
    }

    @ViewBuilder
    private func sampleContent(for id: String) -> some View {
        switch id {
        case "today":
            DSSampleTodayView()
        case "plan":
            DSSamplePlanView()
        case "stats":
            DSSampleStatsView()
        case "focus":
            DSSampleFocusView()
        case "coding":
            DSSampleCodingView()
        default:
            DSSampleTodayView()
        }
    }
}

public struct DSSampleTabletAppView: View {
    @State private var selectedSection = "today"

    public init() {}

    public var body: some View {
        let items = [
            DSNavItem(id: "today", title: "Today", systemImage: "house"),
            DSNavItem(id: "plan", title: "Plan", systemImage: "calendar"),
            DSNavItem(id: "stats", title: "Stats", systemImage: "chart.bar"),
            DSNavItem(id: "focus", title: "Focus", systemImage: "bolt"),
            DSNavItem(id: "coding", title: "Coding", systemImage: "chevron.left.slash.chevron.right")
        ]

        DSSidebarScaffold(items: items, state: .init(selectedId: selectedSection)) { id in
            selectedSection = id
        } content: {
            sampleContent(for: selectedSection)
        } detail: {
            DSSampleDetailPanelView(section: selectedSection)
        }
    }

    @ViewBuilder
    private func sampleContent(for id: String) -> some View {
        switch id {
        case "today":
            DSSampleTodayView()
        case "plan":
            DSSamplePlanView()
        case "stats":
            DSSampleStatsView()
        case "focus":
            DSSampleFocusView()
        case "coding":
            DSSampleCodingView()
        default:
            DSSampleTodayView()
        }
    }
}

public struct DSSampleTodayView: View {
    @Environment(\.dsTheme) private var theme

    public init() {}

    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            DSHeader(title: "Good Morning", subtitle: "Saturday, Feb 7")

            DSCard(config: .init(style: .elevated)) {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Daily Goal")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(theme.colors.textSecondary)
                        Text("4 / 6 tasks")
                            .font(.system(size: 18, weight: .bold))
                        Text("Keep the streak alive")
                            .font(.system(size: 12))
                            .foregroundColor(theme.colors.textSecondary)
                    }
                    Spacer()
                    DSProgressRing(state: .init(progress: 0.66))
                }
            }

            DSSectionHeader(title: "Today’s Plan")

            VStack(spacing: 10) {
                DSListRow(title: "Complete Two Sum", subtitle: "Arrays & Hashing") {
                    DSBadge("Easy", config: .init(style: .success))
                }
                DSListRow(title: "Review DFS", subtitle: "Graph Theory") {
                    DSBadge("Medium", config: .init(style: .warning))
                }
                DSListRow(title: "Drink Water", subtitle: "Health Habit") {
                    DSBadge("1/4", config: .init(style: .neutral))
                }
            }
        }
    }
}

public struct DSSamplePlanView: View {
    @Environment(\.dsTheme) private var theme

    public init() {}

    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            DSHeader(title: "Study Plan", subtitle: "February 2026")

            DSCard(config: .init(style: .outlined)) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Schedule for Today")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(theme.colors.textPrimary)
                    DSListRow(title: "09:00 AM", subtitle: "Morning Review") {
                        DSBadge("Core", config: .init(style: .info))
                    }
                    DSListRow(title: "10:30 AM", subtitle: "Graph Theory") {
                        DSBadge("Focus", config: .init(style: .success))
                    }
                    DSListRow(title: "02:00 PM", subtitle: "Mock Interview") {
                        DSBadge("Optional", config: .init(style: .neutral))
                    }
                }
            }
        }
    }
}

public struct DSSampleStatsView: View {
    @Environment(\.dsTheme) private var theme

    public init() {}

    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            DSHeader(title: "Your Statistics", subtitle: "Weekly overview")

            HStack(spacing: 12) {
                DSMetricCard(title: "Focus Time", value: "34h", detail: "This week", trend: .positive, trendLabel: "+12%")
                DSMetricCard(title: "Problems", value: "45", detail: "Solved", trend: .positive, trendLabel: "+8")
            }

            DSCard(config: .init(style: .outlined)) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Average Difficulty")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(theme.colors.textPrimary)
                    DSBadge("Medium", config: .init(style: .warning))
                }
            }
        }
    }
}

public struct DSSampleFocusView: View {
    @Environment(\.dsTheme) private var theme

    public init() {}

    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            DSHeader(title: "Deep Work Session", subtitle: "Stay focused and track progress")

            DSCard(config: .init(style: .elevated)) {
                VStack(spacing: 16) {
                    DSProgressRing(state: .init(progress: 0.4))
                    Text("25:00")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(theme.colors.textPrimary)
                    DSButton("Start", config: .init(style: .primary, size: .large)) {}
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}

public struct DSSampleCodingView: View {
    @Environment(\.dsTheme) private var theme

    public init() {}

    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            DSHeader(title: "Coding", subtitle: "LeetCode practice")

            DSCard(config: .init(style: .outlined)) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 8) {
                        Text("Two Sum")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(theme.colors.textPrimary)
                        DSBadge("Easy", config: .init(style: .success))
                    }

                    DSSegmentedControl(
                        items: [
                            DSSegmentItem(id: "desc", title: "Desc"),
                            DSSegmentItem(id: "solution", title: "Solution"),
                            DSSegmentItem(id: "code", title: "Code")
                        ],
                        state: .init(selectedId: "code"),
                        onSelect: { _ in }
                    )

                    DSEmptyState(
                        title: "Start coding",
                        message: "Pick a problem and run your tests."
                    )
                }
            }
        }
    }
}

public struct DSSampleDetailPanelView: View {
    let section: String
    @Environment(\.dsTheme) private var theme

    public init(section: String) {
        self.section = section
    }

    public var body: some View {
        DSCard(config: .init(style: .outlined)) {
            VStack(alignment: .leading, spacing: 10) {
                Text("Details")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(theme.colors.textPrimary)
                Text("Selected section: \(section.capitalized)")
                    .font(.system(size: 12))
                    .foregroundColor(theme.colors.textSecondary)
                DSButton("Open", config: .init(style: .secondary, size: .small)) {}
            }
        }
    }
}
