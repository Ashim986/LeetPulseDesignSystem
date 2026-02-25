import SwiftUI

public struct DSSectionHeaderConfig: Sendable {
    public let showsDivider: Bool
    public let isUppercase: Bool

    public init(showsDivider: Bool = false, isUppercase: Bool = false) {
        self.showsDivider = showsDivider
        self.isUppercase = isUppercase
    }
}

public struct DSSectionHeaderState: Equatable, Sendable {
    public var isEnabled: Bool

    public init(isEnabled: Bool = true) {
        self.isEnabled = isEnabled
    }
}

public enum DSSectionHeaderEvent: Sendable {
    case setEnabled(Bool)
}

public struct DSSectionHeaderReducer: ReducerProtocol {
    public init() {}

    public mutating func reduce(state: inout DSSectionHeaderState, event: DSSectionHeaderEvent) {
        switch event {
        case .setEnabled(let value):
            state.isEnabled = value
        }
    }
}

public struct DSSectionHeaderRenderModel {
    public let titleFont: Font
    public let titleColor: Color
    public let actionFont: Font
    public let actionColor: Color
    public let opacity: Double

    public static func make(state: DSSectionHeaderState, theme: DSTheme) -> DSSectionHeaderRenderModel {
        DSSectionHeaderRenderModel(
            titleFont: theme.typography.caption,
            titleColor: theme.colors.textSecondary,
            actionFont: theme.typography.caption,
            actionColor: theme.colors.primary,
            opacity: state.isEnabled ? 1.0 : 0.6
        )
    }
}

public struct DSSectionHeader: View {
    private let title: String
    private let actionTitle: String?
    private let config: DSSectionHeaderConfig
    private let state: DSSectionHeaderState
    private let onAction: (() -> Void)?

    @Environment(\.dsTheme) private var theme

    public init(
        title: String,
        actionTitle: String? = nil,
        config: DSSectionHeaderConfig = DSSectionHeaderConfig(),
        state: DSSectionHeaderState = DSSectionHeaderState(),
        onAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.actionTitle = actionTitle
        self.config = config
        self.state = state
        self.onAction = onAction
    }

    public var body: some View {
        let model = DSSectionHeaderRenderModel.make(state: state, theme: theme)
        let displayTitle = config.isUppercase ? title.uppercased() : title

        VStack(alignment: .leading, spacing: theme.spacing.xs) {
            HStack {
                Text(displayTitle)
                    .font(model.titleFont)
                    .foregroundColor(model.titleColor)

                Spacer(minLength: theme.spacing.sm)

                if let actionTitle, let onAction {
                    Button(actionTitle) {
                        onAction()
                    }
                    .font(model.actionFont)
                    .foregroundColor(model.actionColor)
                    .buttonStyle(.plain)
                }
            }
            .opacity(model.opacity)

            if config.showsDivider {
                Divider()
                    .background(theme.colors.border)
            }
        }
    }
}
