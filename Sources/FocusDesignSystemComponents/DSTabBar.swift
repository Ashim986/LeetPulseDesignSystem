import SwiftUI
import FocusDesignSystemCore
import FocusDesignSystemState

public struct DSTabBarConfig: Sendable {
    public let showsLabels: Bool
    public let showsIcons: Bool
    public let showsBadges: Bool

    public init(
        showsLabels: Bool = true,
        showsIcons: Bool = true,
        showsBadges: Bool = true
    ) {
        self.showsLabels = showsLabels
        self.showsIcons = showsIcons
        self.showsBadges = showsBadges
    }
}

public struct DSTabBarState: Equatable, Sendable {
    public var selectedId: String?
    public var isEnabled: Bool

    public init(selectedId: String? = nil, isEnabled: Bool = true) {
        self.selectedId = selectedId
        self.isEnabled = isEnabled
    }
}

public enum DSTabBarEvent: Sendable {
    case select(String)
    case setEnabled(Bool)
}

public struct DSTabBarReducer: ReducerProtocol {
    public init() {}

    public mutating func reduce(state: inout DSTabBarState, event: DSTabBarEvent) {
        switch event {
        case .select(let id):
            if state.isEnabled {
                state.selectedId = id
            }
        case .setEnabled(let value):
            state.isEnabled = value
        }
    }
}

public struct DSTabBarRenderModel {
    public let background: Color
    public let border: Color
    public let selectedBackground: Color
    public let selectedForeground: Color
    public let unselectedForeground: Color
    public let badgeBackground: Color
    public let badgeForeground: Color
    public let opacity: Double
    public let padding: EdgeInsets
    public let cornerRadius: CGFloat
    public let itemSpacing: CGFloat
    public let iconSize: CGFloat
    public let labelFont: Font
    public let badgeFont: Font

    public static func make(state: DSTabBarState, theme: DSTheme) -> DSTabBarRenderModel {
        DSTabBarRenderModel(
            background: theme.colors.surface,
            border: theme.colors.border,
            selectedBackground: theme.colors.primary.opacity(0.16),
            selectedForeground: theme.colors.primary,
            unselectedForeground: theme.colors.textSecondary,
            badgeBackground: theme.colors.primary,
            badgeForeground: Color.white,
            opacity: state.isEnabled ? 1.0 : 0.6,
            padding: EdgeInsets(
                top: theme.spacing.sm,
                leading: theme.spacing.md,
                bottom: theme.spacing.sm,
                trailing: theme.spacing.md
            ),
            cornerRadius: theme.radii.lg,
            itemSpacing: theme.spacing.sm,
            iconSize: 18,
            labelFont: .system(size: 11, weight: .semibold),
            badgeFont: .system(size: 9, weight: .semibold)
        )
    }
}

public struct DSTabBar: View {
    private let items: [DSNavItem]
    private let config: DSTabBarConfig
    private let state: DSTabBarState
    private let onSelect: (String) -> Void

    @Environment(\.dsTheme) private var theme

    public init(
        items: [DSNavItem],
        config: DSTabBarConfig = DSTabBarConfig(),
        state: DSTabBarState,
        onSelect: @escaping (String) -> Void
    ) {
        self.items = items
        self.config = config
        self.state = state
        self.onSelect = onSelect
    }

    public var body: some View {
        let model = DSTabBarRenderModel.make(state: state, theme: theme)

        HStack(spacing: model.itemSpacing) {
            ForEach(items) { item in
                let isSelected = item.id == state.selectedId
                Button(action: {
                    if state.isEnabled && item.isEnabled {
                        onSelect(item.id)
                    }
                }, label: {
                    VStack(spacing: theme.spacing.xs) {
                        if config.showsIcons, let systemImage = item.systemImage {
                            Image(systemName: systemImage)
                                .font(.system(size: model.iconSize, weight: .semibold))
                                .foregroundColor(isSelected ? model.selectedForeground : model.unselectedForeground)
                        }

                        if config.showsLabels {
                            Text(item.title)
                                .font(model.labelFont)
                                .foregroundColor(isSelected ? model.selectedForeground : model.unselectedForeground)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, theme.spacing.xs)
                    .padding(.horizontal, theme.spacing.sm)
                    .background(
                        RoundedRectangle(cornerRadius: theme.radii.md)
                            .fill(isSelected ? model.selectedBackground : Color.clear)
                    )
                    // Ensure the whole item surface is tappable, not just glyph bounds.
                    .contentShape(Rectangle())
                    .overlay(alignment: .topTrailing) {
                        if config.showsBadges, let badge = item.badge {
                            Text(badge)
                                .font(model.badgeFont)
                                .foregroundColor(model.badgeForeground)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(
                                    Capsule()
                                        .fill(model.badgeBackground)
                                )
                                .offset(x: 10, y: -8)
                        }
                    }
                })
                .buttonStyle(.plain)
                .opacity(item.isEnabled ? 1.0 : 0.5)
            }
        }
        .padding(model.padding)
        .background(
            RoundedRectangle(cornerRadius: model.cornerRadius)
                .fill(model.background)
        )
        .overlay(
            RoundedRectangle(cornerRadius: model.cornerRadius)
                .stroke(model.border, lineWidth: 1)
        )
        .opacity(model.opacity)
    }
}
