import SwiftUI

public struct DSEmptyStateConfig: Sendable {
    public let icon: Image?
    public let showsAction: Bool

    public init(icon: Image? = nil, showsAction: Bool = false) {
        self.icon = icon
        self.showsAction = showsAction
    }
}

public struct DSEmptyStateState: Equatable, Sendable {
    public var isLoading: Bool
    public var isActionEnabled: Bool

    public init(isLoading: Bool = false, isActionEnabled: Bool = true) {
        self.isLoading = isLoading
        self.isActionEnabled = isActionEnabled
    }
}

public enum DSEmptyStateEvent: Sendable {
    case setLoading(Bool)
    case setActionEnabled(Bool)
}

public struct DSEmptyStateReducer: ReducerProtocol {
    public init() {}

    public mutating func reduce(state: inout DSEmptyStateState, event: DSEmptyStateEvent) {
        switch event {
        case .setLoading(let value):
            state.isLoading = value
        case .setActionEnabled(let value):
            state.isActionEnabled = value
        }
    }
}

public struct DSEmptyStateRenderModel {
    public let titleFont: Font
    public let bodyFont: Font
    public let titleColor: Color
    public let bodyColor: Color

    public static func make(theme: DSTheme) -> DSEmptyStateRenderModel {
        DSEmptyStateRenderModel(
            titleFont: theme.typography.subtitle,
            bodyFont: theme.typography.body,
            titleColor: theme.colors.textPrimary,
            bodyColor: theme.colors.textSecondary
        )
    }
}

public struct DSEmptyState: View {
    private let title: String
    private let message: String
    private let actionTitle: String?
    private let config: DSEmptyStateConfig
    private let state: DSEmptyStateState
    private let onAction: (() -> Void)?

    @Environment(\.dsTheme) private var theme

    public init(
        title: String,
        message: String,
        actionTitle: String? = nil,
        config: DSEmptyStateConfig = DSEmptyStateConfig(),
        state: DSEmptyStateState = DSEmptyStateState(),
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
        let model = DSEmptyStateRenderModel.make(theme: theme)
        VStack(spacing: theme.spacing.sm) {
            if let icon = config.icon {
                icon
                    .foregroundColor(theme.colors.secondary)
            }

            Text(title)
                .font(model.titleFont)
                .foregroundColor(model.titleColor)

            Text(message)
                .font(model.bodyFont)
                .foregroundColor(model.bodyColor)
                .multilineTextAlignment(.center)

            if config.showsAction, let actionTitle, let onAction {
                DSButton(
                    actionTitle,
                    config: DSButtonConfig(style: .primary, size: .medium),
                    state: DSButtonState(isEnabled: state.isActionEnabled, isLoading: state.isLoading),
                    action: onAction
                )
            }
        }
        .padding(theme.spacing.lg)
    }
}
