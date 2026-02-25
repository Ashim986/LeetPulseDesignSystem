import SwiftUI

public enum DSToastStyle: String, Sendable {
    case info
    case success
    case warning
    case error
}

public struct DSToastConfig: Sendable {
    public let style: DSToastStyle
    public let showsIcon: Bool
    public let isCompact: Bool
    public let cornerRadius: CGFloat?

    public init(
        style: DSToastStyle = .info,
        showsIcon: Bool = true,
        isCompact: Bool = false,
        cornerRadius: CGFloat? = nil
    ) {
        self.style = style
        self.showsIcon = showsIcon
        self.isCompact = isCompact
        self.cornerRadius = cornerRadius
    }
}

public struct DSToastState: Equatable, Sendable {
    public var isVisible: Bool
    public var isEnabled: Bool

    public init(isVisible: Bool = false, isEnabled: Bool = true) {
        self.isVisible = isVisible
        self.isEnabled = isEnabled
    }
}

public enum DSToastEvent: Sendable {
    case setVisible(Bool)
    case setEnabled(Bool)
}

public struct DSToastReducer: ReducerProtocol {
    public init() {}

    public mutating func reduce(state: inout DSToastState, event: DSToastEvent) {
        switch event {
        case .setVisible(let value):
            state.isVisible = value
        case .setEnabled(let value):
            state.isEnabled = value
        }
    }
}

public struct DSToastRenderModel {
    public let background: Color
    public let border: Color
    public let titleFont: Font
    public let messageFont: Font
    public let titleColor: Color
    public let messageColor: Color
    public let iconColor: Color
    public let iconName: String
    public let opacity: Double
    public let cornerRadius: CGFloat
    public let padding: EdgeInsets

    public static func make(state: DSToastState, config: DSToastConfig, theme: DSTheme) -> DSToastRenderModel {
        let accent: Color = {
            switch config.style {
            case .info:
                return theme.colors.primary
            case .success:
                return theme.colors.success
            case .warning:
                return theme.colors.warning
            case .error:
                return theme.colors.danger
            }
        }()

        let iconName: String = {
            switch config.style {
            case .info:
                return "info.circle"
            case .success:
                return "checkmark.circle"
            case .warning:
                return "exclamationmark.triangle"
            case .error:
                return "xmark.octagon"
            }
        }()

        let padding: EdgeInsets = {
            if config.isCompact {
                return EdgeInsets(
                    top: theme.spacing.xs,
                    leading: theme.spacing.sm,
                    bottom: theme.spacing.xs,
                    trailing: theme.spacing.sm
                )
            }

            return EdgeInsets(
                top: theme.spacing.sm,
                leading: theme.spacing.md,
                bottom: theme.spacing.sm,
                trailing: theme.spacing.md
            )
        }()

        return DSToastRenderModel(
            background: accent.opacity(0.12),
            border: accent.opacity(0.4),
            titleFont: theme.typography.subtitle,
            messageFont: theme.typography.body,
            titleColor: theme.colors.textPrimary,
            messageColor: theme.colors.textSecondary,
            iconColor: accent,
            iconName: iconName,
            opacity: state.isEnabled ? 1.0 : 0.6,
            cornerRadius: config.cornerRadius ?? theme.radii.md,
            padding: padding
        )
    }
}

public struct DSToast: View {
    private let title: String?
    private let message: String
    private let actionTitle: String?
    private let config: DSToastConfig
    private let state: DSToastState
    private let onAction: (() -> Void)?

    @Environment(\.dsTheme) private var theme

    public init(
        title: String? = nil,
        message: String,
        actionTitle: String? = nil,
        config: DSToastConfig = DSToastConfig(),
        state: DSToastState = DSToastState(),
        onAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.config = config
        self.state = state
        self.onAction = onAction
    }

    public var body: some View {
        if state.isVisible {
            let model = DSToastRenderModel.make(state: state, config: config, theme: theme)
            HStack(alignment: .top, spacing: theme.spacing.sm) {
                if config.showsIcon {
                    Image(systemName: model.iconName)
                        .foregroundColor(model.iconColor)
                }

                VStack(alignment: .leading, spacing: theme.spacing.xs) {
                    if let title {
                        Text(title)
                            .font(model.titleFont)
                            .foregroundColor(model.titleColor)
                    }

                    Text(message)
                        .font(model.messageFont)
                        .foregroundColor(model.messageColor)
                }

                Spacer(minLength: theme.spacing.sm)

                if let actionTitle, let onAction {
                    Button(actionTitle) {
                        onAction()
                    }
                    .font(theme.typography.caption)
                    .foregroundColor(model.iconColor)
                    .buttonStyle(.plain)
                }
            }
            .padding(model.padding)
            .background(model.background)
            .overlay(
                RoundedRectangle(cornerRadius: model.cornerRadius)
                    .stroke(model.border, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: model.cornerRadius))
            .opacity(model.opacity)
        }
    }
}
