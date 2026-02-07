import SwiftUI
import FocusDesignSystemCore
import FocusDesignSystemState

public enum DSButtonStyle: String, Sendable {
    case primary
    case secondary
    case ghost
    case destructive
}

public enum DSButtonSize: String, Sendable {
    case small
    case medium
    case large
}

public enum DSButtonIconPosition: String, Sendable {
    case leading
    case trailing
}

public struct DSButtonConfig {
    public let style: DSButtonStyle
    public let size: DSButtonSize
    public let icon: Image?
    public let iconView: AnyView?
    public let iconPosition: DSButtonIconPosition
    public let isFullWidth: Bool

    public init(
        style: DSButtonStyle = .primary,
        size: DSButtonSize = .medium,
        icon: Image? = nil,
        iconView: AnyView? = nil,
        iconPosition: DSButtonIconPosition = .leading,
        isFullWidth: Bool = false
    ) {
        self.style = style
        self.size = size
        self.icon = icon
        self.iconView = iconView
        self.iconPosition = iconPosition
        self.isFullWidth = isFullWidth
    }

    public init(
        style: DSButtonStyle = .primary,
        size: DSButtonSize = .medium,
        icon: DSImage,
        iconPosition: DSButtonIconPosition = .leading,
        isFullWidth: Bool = false
    ) {
        self.style = style
        self.size = size
        self.icon = nil
        self.iconView = AnyView(icon)
        self.iconPosition = iconPosition
        self.isFullWidth = isFullWidth
    }
}

public struct DSButtonState: Equatable, Sendable {
    public var isEnabled: Bool
    public var isLoading: Bool

    public init(isEnabled: Bool = true, isLoading: Bool = false) {
        self.isEnabled = isEnabled
        self.isLoading = isLoading
    }
}

public enum DSButtonEvent: Sendable {
    case setEnabled(Bool)
    case setLoading(Bool)
}

public struct DSButtonReducer: ReducerProtocol {
    public init() {}

    public mutating func reduce(state: inout DSButtonState, event: DSButtonEvent) {
        switch event {
        case .setEnabled(let value):
            state.isEnabled = value
            if !value {
                state.isLoading = false
            }
        case .setLoading(let value):
            state.isLoading = value
            if value {
                state.isEnabled = false
            }
        }
    }
}

public struct DSButtonRenderModel {
    public let background: Color
    public let foreground: Color
    public let border: Color?
    public let font: Font
    public let padding: EdgeInsets
    public let cornerRadius: CGFloat
    public let opacity: Double
    public let showsSpinner: Bool
    public let spinnerColor: Color
    public let iconColor: Color

    public static func make(
        state: DSButtonState,
        config: DSButtonConfig,
        theme: DSTheme
    ) -> DSButtonRenderModel {
        let (background, foreground, border): (Color, Color, Color?) = {
            switch config.style {
            case .primary:
                return (theme.colors.primary, Color.white, nil)
            case .secondary:
                return (theme.colors.surfaceElevated, theme.colors.textPrimary, theme.colors.border)
            case .ghost:
                return (Color.clear, theme.colors.primary, nil)
            case .destructive:
                return (theme.colors.danger, Color.white, nil)
            }
        }()

        let font: Font = {
            switch config.size {
            case .small: return .system(size: 12, weight: .semibold)
            case .medium: return .system(size: 13, weight: .semibold)
            case .large: return .system(size: 15, weight: .semibold)
            }
        }()

        let padding: EdgeInsets = {
            switch config.size {
            case .small:
                return EdgeInsets(
                    top: theme.spacing.xs,
                    leading: theme.spacing.md,
                    bottom: theme.spacing.xs,
                    trailing: theme.spacing.md
                )
            case .medium:
                return EdgeInsets(
                    top: theme.spacing.sm,
                    leading: theme.spacing.lg,
                    bottom: theme.spacing.sm,
                    trailing: theme.spacing.lg
                )
            case .large:
                return EdgeInsets(
                    top: theme.spacing.md,
                    leading: theme.spacing.xl,
                    bottom: theme.spacing.md,
                    trailing: theme.spacing.xl
                )
            }
        }()

        let opacity = state.isEnabled && !state.isLoading ? 1.0 : 0.6
        let spinnerColor = foreground

        return DSButtonRenderModel(
            background: background,
            foreground: foreground,
            border: border,
            font: font,
            padding: padding,
            cornerRadius: theme.radii.md,
            opacity: opacity,
            showsSpinner: state.isLoading,
            spinnerColor: spinnerColor,
            iconColor: foreground
        )
    }
}

public struct DSButton: View {
    private let title: String?
    private let label: AnyView?
    private let config: DSButtonConfig
    private let state: DSButtonState
    private let action: () -> Void

    @Environment(\.dsTheme) private var theme

    public init(
        _ title: String,
        config: DSButtonConfig = DSButtonConfig(),
        state: DSButtonState = DSButtonState(),
        action: @escaping () -> Void
    ) {
        self.title = title
        self.label = nil
        self.config = config
        self.state = state
        self.action = action
    }

    public init(
        config: DSButtonConfig = DSButtonConfig(),
        state: DSButtonState = DSButtonState(),
        action: @escaping () -> Void,
        @ViewBuilder label: () -> some View
    ) {
        self.title = nil
        self.label = AnyView(label())
        self.config = config
        self.state = state
        self.action = action
    }

    public var body: some View {
        let model = DSButtonRenderModel.make(state: state, config: config, theme: theme)

        Button(action: {
            if state.isEnabled && !state.isLoading {
                action()
            }
        }, label: {
            HStack(spacing: theme.spacing.sm) {
                if model.showsSpinner {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(model.spinnerColor)
                }

                if let label {
                    label
                        .foregroundColor(model.foreground)
                } else if let title {
                    if config.iconPosition == .leading {
                        if let iconView = config.iconView {
                            iconView
                                .foregroundColor(model.iconColor)
                        } else if let icon = config.icon {
                            icon
                                .foregroundColor(model.iconColor)
                        }
                    }

                    Text(title)
                        .font(model.font)
                        .foregroundColor(model.foreground)

                    if config.iconPosition == .trailing {
                        if let iconView = config.iconView {
                            iconView
                                .foregroundColor(model.iconColor)
                        } else if let icon = config.icon {
                            icon
                                .foregroundColor(model.iconColor)
                        }
                    }
                }
            }
            .frame(maxWidth: config.isFullWidth ? .infinity : nil)
            .padding(model.padding)
            .background(model.background)
            .overlay(
                RoundedRectangle(cornerRadius: model.cornerRadius)
                    .stroke(model.border ?? Color.clear, lineWidth: model.border == nil ? 0 : 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: model.cornerRadius))
            .opacity(model.opacity)
        })
        .buttonStyle(.plain)
        .disabled(!state.isEnabled || state.isLoading)
    }
}
