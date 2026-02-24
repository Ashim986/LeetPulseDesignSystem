import SwiftUI
import LeetPulseDesignSystemCore
import LeetPulseDesignSystemState

public enum DSListRowStyle: String, Sendable {
    case standard
    case compact
}

public struct DSListRowConfig: Sendable {
    public let style: DSListRowStyle
    public let showsDivider: Bool
    public let showsChevron: Bool
    public let contentPadding: EdgeInsets?

    public init(
        style: DSListRowStyle = .standard,
        showsDivider: Bool = true,
        showsChevron: Bool = false,
        contentPadding: EdgeInsets? = nil
    ) {
        self.style = style
        self.showsDivider = showsDivider
        self.showsChevron = showsChevron
        self.contentPadding = contentPadding
    }
}

public struct DSListRowState: Equatable, Sendable {
    public var isEnabled: Bool
    public var isSelected: Bool
    public var isHighlighted: Bool

    public init(isEnabled: Bool = true, isSelected: Bool = false, isHighlighted: Bool = false) {
        self.isEnabled = isEnabled
        self.isSelected = isSelected
        self.isHighlighted = isHighlighted
    }
}

public enum DSListRowEvent: Sendable {
    case setEnabled(Bool)
    case setSelected(Bool)
    case setHighlighted(Bool)
}

public struct DSListRowReducer: ReducerProtocol {
    public init() {}

    public mutating func reduce(state: inout DSListRowState, event: DSListRowEvent) {
        switch event {
        case .setEnabled(let value):
            state.isEnabled = value
        case .setSelected(let value):
            state.isSelected = value
        case .setHighlighted(let value):
            state.isHighlighted = value
        }
    }
}

public struct DSListRowRenderModel {
    public let background: Color
    public let titleFont: Font
    public let subtitleFont: Font
    public let titleColor: Color
    public let subtitleColor: Color
    public let leadingIconColor: Color
    public let accessoryColor: Color
    public let dividerColor: Color
    public let padding: EdgeInsets
    public let opacity: Double

    public static func make(state: DSListRowState, config: DSListRowConfig, theme: DSTheme) -> DSListRowRenderModel {
        let baseBackground = theme.colors.surface
        let selectedBackground = theme.colors.primary.opacity(0.12)
        let highlightedBackground = theme.colors.surfaceElevated

        let background: Color = {
            if state.isSelected {
                return selectedBackground
            }
            if state.isHighlighted {
                return highlightedBackground
            }
            return baseBackground
        }()

        let padding: EdgeInsets = {
            if let contentPadding = config.contentPadding {
                return contentPadding
            }

            switch config.style {
            case .standard:
                return EdgeInsets(
                    top: theme.spacing.md,
                    leading: theme.spacing.lg,
                    bottom: theme.spacing.md,
                    trailing: theme.spacing.lg
                )
            case .compact:
                return EdgeInsets(
                    top: theme.spacing.sm,
                    leading: theme.spacing.md,
                    bottom: theme.spacing.sm,
                    trailing: theme.spacing.md
                )
            }
        }()

        return DSListRowRenderModel(
            background: background,
            titleFont: theme.typography.body,
            subtitleFont: theme.typography.caption,
            titleColor: theme.colors.textPrimary,
            subtitleColor: theme.colors.textSecondary,
            leadingIconColor: theme.colors.secondary,
            accessoryColor: theme.colors.textSecondary,
            dividerColor: theme.colors.border,
            padding: padding,
            opacity: state.isEnabled ? 1.0 : 0.6
        )
    }
}

public struct DSListRow<Accessory: View>: View {
    private let title: String
    private let subtitle: String?
    private let leadingIcon: Image?
    private let config: DSListRowConfig
    private let state: DSListRowState
    private let accessory: Accessory

    @Environment(\.dsTheme) private var theme

    public init(
        title: String,
        subtitle: String? = nil,
        leadingIcon: Image? = nil,
        config: DSListRowConfig = DSListRowConfig(),
        state: DSListRowState = DSListRowState(),
        @ViewBuilder accessory: () -> Accessory
    ) {
        self.title = title
        self.subtitle = subtitle
        self.leadingIcon = leadingIcon
        self.config = config
        self.state = state
        self.accessory = accessory()
    }

    public var body: some View {
        let model = DSListRowRenderModel.make(state: state, config: config, theme: theme)

        VStack(spacing: 0) {
            HStack(spacing: theme.spacing.sm) {
                if let leadingIcon {
                    leadingIcon
                        .foregroundColor(model.leadingIconColor)
                }

                VStack(alignment: .leading, spacing: theme.spacing.xs) {
                    Text(title)
                        .font(model.titleFont)
                        .foregroundColor(model.titleColor)

                    if let subtitle {
                        Text(subtitle)
                            .font(model.subtitleFont)
                            .foregroundColor(model.subtitleColor)
                    }
                }

                Spacer(minLength: theme.spacing.sm)

                accessory

                if config.showsChevron {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(model.accessoryColor)
                }
            }
            .padding(model.padding)
            .background(model.background)
            .opacity(model.opacity)

            if config.showsDivider {
                Divider()
                    .background(model.dividerColor)
            }
        }
    }
}

public extension DSListRow where Accessory == EmptyView {
    init(
        title: String,
        subtitle: String? = nil,
        leadingIcon: Image? = nil,
        config: DSListRowConfig = DSListRowConfig(),
        state: DSListRowState = DSListRowState()
    ) {
        self.init(
            title: title,
            subtitle: subtitle,
            leadingIcon: leadingIcon,
            config: config,
            state: state
        ) {
            EmptyView()
        }
    }
}
