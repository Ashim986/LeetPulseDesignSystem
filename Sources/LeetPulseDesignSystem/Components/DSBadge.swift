import SwiftUI

public enum DSBadgeStyle: String, Sendable {
    case neutral
    case info
    case success
    case warning
    case danger
}

public struct DSBadgeConfig: Sendable {
    public let style: DSBadgeStyle

    public init(style: DSBadgeStyle = .neutral) {
        self.style = style
    }
}

public struct DSBadgeState: Equatable, Sendable {
    public var isEmphasized: Bool

    public init(isEmphasized: Bool = false) {
        self.isEmphasized = isEmphasized
    }
}

public struct DSBadgeRenderModel {
    public let background: Color
    public let foreground: Color
    public let font: Font
    public let padding: EdgeInsets
    public let cornerRadius: CGFloat

    public static func make(state: DSBadgeState, config: DSBadgeConfig, theme: DSTheme) -> DSBadgeRenderModel {
        let palette: (bg: Color, fg: Color) = {
            switch config.style {
            case .neutral:
                return (theme.colors.surfaceElevated, theme.colors.textSecondary)
            case .info:
                return (theme.colors.primary.opacity(0.15), theme.colors.primary)
            case .success:
                return (theme.colors.success.opacity(0.15), theme.colors.success)
            case .warning:
                return (theme.colors.warning.opacity(0.15), theme.colors.warning)
            case .danger:
                return (theme.colors.danger.opacity(0.15), theme.colors.danger)
            }
        }()

        let background = state.isEmphasized ? palette.bg.opacity(0.85) : palette.bg

        return DSBadgeRenderModel(
            background: background,
            foreground: palette.fg,
            font: theme.typography.caption,
            padding: EdgeInsets(top: 2, leading: 8, bottom: 2, trailing: 8),
            cornerRadius: theme.radii.pill
        )
    }
}

public struct DSBadge: View {
    private let text: String
    private let config: DSBadgeConfig
    private let state: DSBadgeState

    @Environment(\.dsTheme) private var theme

    public init(_ text: String, config: DSBadgeConfig = DSBadgeConfig(), state: DSBadgeState = DSBadgeState()) {
        self.text = text
        self.config = config
        self.state = state
    }

    public var body: some View {
        let model = DSBadgeRenderModel.make(state: state, config: config, theme: theme)
        Text(text)
            .font(model.font)
            .foregroundColor(model.foreground)
            .padding(model.padding)
            .background(model.background)
            .clipShape(RoundedRectangle(cornerRadius: model.cornerRadius))
    }
}
