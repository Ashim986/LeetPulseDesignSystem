import SwiftUI

public struct DSSidebarConfig: Sendable {
    public let showsIcons: Bool
    public let showsBadges: Bool

    public init(showsIcons: Bool = true, showsBadges: Bool = true) {
        self.showsIcons = showsIcons
        self.showsBadges = showsBadges
    }
}

public struct DSSidebarState: Equatable, Sendable {
    public var selectedId: String?
    public var isEnabled: Bool

    public init(selectedId: String? = nil, isEnabled: Bool = true) {
        self.selectedId = selectedId
        self.isEnabled = isEnabled
    }
}

public enum DSSidebarEvent: Sendable {
    case select(String)
    case setEnabled(Bool)
}

public struct DSSidebarReducer: ReducerProtocol {
    public init() {}

    public mutating func reduce(state: inout DSSidebarState, event: DSSidebarEvent) {
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

public struct DSSidebarRenderModel {
    public let background: Color
    public let border: Color
    public let selectedBackground: Color
    public let selectedForeground: Color
    public let unselectedForeground: Color
    public let badgeBackground: Color
    public let badgeForeground: Color
    public let opacity: Double
    public let padding: EdgeInsets
    public let itemSpacing: CGFloat
    public let cornerRadius: CGFloat
    public let labelFont: Font
    public let iconSize: CGFloat
    public let badgeFont: Font

    public static func make(state: DSSidebarState, theme: DSTheme) -> DSSidebarRenderModel {
        DSSidebarRenderModel(
            background: theme.colors.surface,
            border: theme.colors.border,
            selectedBackground: theme.colors.primary.opacity(0.16),
            selectedForeground: theme.colors.primary,
            unselectedForeground: theme.colors.textSecondary,
            badgeBackground: theme.colors.primary,
            badgeForeground: Color.white,
            opacity: state.isEnabled ? 1.0 : 0.6,
            padding: EdgeInsets(
                top: theme.spacing.lg,
                leading: theme.spacing.md,
                bottom: theme.spacing.lg,
                trailing: theme.spacing.md
            ),
            itemSpacing: theme.spacing.sm,
            cornerRadius: theme.radii.lg,
            labelFont: .system(size: 13, weight: .semibold),
            iconSize: 16,
            badgeFont: .system(size: 9, weight: .semibold)
        )
    }
}

public struct DSSidebar: View {
    private let items: [DSNavItem]
    private let config: DSSidebarConfig
    private let state: DSSidebarState
    private let onSelect: (String) -> Void

    @Environment(\.dsTheme) private var theme

    public init(
        items: [DSNavItem],
        config: DSSidebarConfig = DSSidebarConfig(),
        state: DSSidebarState,
        onSelect: @escaping (String) -> Void
    ) {
        self.items = items
        self.config = config
        self.state = state
        self.onSelect = onSelect
    }

    public var body: some View {
        let model = DSSidebarRenderModel.make(state: state, theme: theme)

        VStack(alignment: .leading, spacing: model.itemSpacing) {
            ForEach(items) { item in
                let isSelected = item.id == state.selectedId
                Button(action: {
                    if state.isEnabled && item.isEnabled {
                        onSelect(item.id)
                    }
                }, label: {
                    HStack(spacing: theme.spacing.sm) {
                        if config.showsIcons, let systemImage = item.systemImage {
                            Image(systemName: systemImage)
                                .font(.system(size: model.iconSize, weight: .semibold))
                                .foregroundColor(isSelected ? model.selectedForeground : model.unselectedForeground)
                        }

                        Text(item.title)
                            .font(model.labelFont)
                            .foregroundColor(isSelected ? model.selectedForeground : model.unselectedForeground)

                        Spacer(minLength: 0)

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
                        }
                    }
                    .padding(.vertical, theme.spacing.sm)
                    .padding(.horizontal, theme.spacing.md)
                    .background(
                        RoundedRectangle(cornerRadius: theme.radii.md)
                            .fill(isSelected ? model.selectedBackground : Color.clear)
                    )
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
