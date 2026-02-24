import SwiftUI
import LeetPulseDesignSystemCore
import LeetPulseDesignSystemState

public enum DSAlertStyle: String, Sendable {
    case info
    case success
    case warning
    case error
}

public struct DSAlertConfig: Sendable {
    public let style: DSAlertStyle
    public let showsIcon: Bool
    public let cornerRadius: CGFloat?

    public init(style: DSAlertStyle = .info, showsIcon: Bool = true, cornerRadius: CGFloat? = nil) {
        self.style = style
        self.showsIcon = showsIcon
        self.cornerRadius = cornerRadius
    }
}

public struct DSAlertState: Equatable, Sendable {
    public var isPresented: Bool
    public var isProcessing: Bool
    public var isEnabled: Bool

    public init(isPresented: Bool = false, isProcessing: Bool = false, isEnabled: Bool = true) {
        self.isPresented = isPresented
        self.isProcessing = isProcessing
        self.isEnabled = isEnabled
    }
}

public enum DSAlertEvent: Sendable {
    case setPresented(Bool)
    case setProcessing(Bool)
    case setEnabled(Bool)
}

public struct DSAlertReducer: ReducerProtocol {
    public init() {}

    public mutating func reduce(state: inout DSAlertState, event: DSAlertEvent) {
        switch event {
        case .setPresented(let value):
            state.isPresented = value
        case .setProcessing(let value):
            state.isProcessing = value
        case .setEnabled(let value):
            state.isEnabled = value
        }
    }
}

public struct DSAlertRenderModel {
    public let background: Color
    public let border: Color
    public let titleFont: Font
    public let messageFont: Font
    public let titleColor: Color
    public let messageColor: Color
    public let iconColor: Color
    public let iconName: String
    public let primaryButtonStyle: DSButtonStyle
    public let opacity: Double
    public let cornerRadius: CGFloat

    public static func make(state: DSAlertState, config: DSAlertConfig, theme: DSTheme) -> DSAlertRenderModel {
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
                return "checkmark.seal"
            case .warning:
                return "exclamationmark.triangle"
            case .error:
                return "xmark.octagon"
            }
        }()

        let primaryButtonStyle: DSButtonStyle = config.style == .error ? .destructive : .primary

        return DSAlertRenderModel(
            background: theme.colors.surfaceElevated,
            border: accent.opacity(0.4),
            titleFont: theme.typography.subtitle,
            messageFont: theme.typography.body,
            titleColor: theme.colors.textPrimary,
            messageColor: theme.colors.textSecondary,
            iconColor: accent,
            iconName: iconName,
            primaryButtonStyle: primaryButtonStyle,
            opacity: state.isEnabled ? 1.0 : 0.6,
            cornerRadius: config.cornerRadius ?? theme.radii.lg
        )
    }
}

public struct DSAlert: View {
    private let title: String
    private let message: String
    private let primaryActionTitle: String
    private let secondaryActionTitle: String?
    private let config: DSAlertConfig
    private let state: DSAlertState
    private let onPrimaryAction: (() -> Void)?
    private let onSecondaryAction: (() -> Void)?

    @Environment(\.dsTheme) private var theme

    public init(
        title: String,
        message: String,
        primaryActionTitle: String,
        secondaryActionTitle: String? = nil,
        config: DSAlertConfig = DSAlertConfig(),
        state: DSAlertState = DSAlertState(),
        onPrimaryAction: (() -> Void)? = nil,
        onSecondaryAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.primaryActionTitle = primaryActionTitle
        self.secondaryActionTitle = secondaryActionTitle
        self.config = config
        self.state = state
        self.onPrimaryAction = onPrimaryAction
        self.onSecondaryAction = onSecondaryAction
    }

    public var body: some View {
        if state.isPresented {
            let model = DSAlertRenderModel.make(state: state, config: config, theme: theme)
            VStack(alignment: .leading, spacing: theme.spacing.sm) {
                HStack(spacing: theme.spacing.sm) {
                    if config.showsIcon {
                        Image(systemName: model.iconName)
                            .foregroundColor(model.iconColor)
                    }

                    Text(title)
                        .font(model.titleFont)
                        .foregroundColor(model.titleColor)

                    Spacer(minLength: theme.spacing.sm)
                }

                Text(message)
                    .font(model.messageFont)
                    .foregroundColor(model.messageColor)

                HStack(spacing: theme.spacing.sm) {
                    if let secondaryActionTitle, let onSecondaryAction {
                        DSButton(
                            secondaryActionTitle,
                            config: DSButtonConfig(style: .secondary, size: .small),
                            state: DSButtonState(isEnabled: state.isEnabled && !state.isProcessing),
                            action: onSecondaryAction
                        )
                    }

                    DSButton(
                        primaryActionTitle,
                        config: DSButtonConfig(style: model.primaryButtonStyle, size: .small),
                        state: DSButtonState(
                            isEnabled: state.isEnabled && !state.isProcessing,
                            isLoading: state.isProcessing
                        ),
                        action: {
                            onPrimaryAction?()
                        }
                    )
                }
            }
            .padding(theme.spacing.lg)
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
