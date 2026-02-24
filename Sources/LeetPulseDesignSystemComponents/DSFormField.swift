import SwiftUI
import LeetPulseDesignSystemCore

public struct DSFormFieldConfig: Sendable {
    public let spacing: CGFloat

    public init(spacing: CGFloat = 6) {
        self.spacing = spacing
    }
}

public struct DSFormFieldState: Equatable, Sendable {
    public var validationMessage: String?

    public init(validationMessage: String? = nil) {
        self.validationMessage = validationMessage
    }
}

public struct DSFormFieldRenderModel {
    public let titleFont: Font
    public let titleColor: Color
    public let helperFont: Font
    public let helperColor: Color
    public let validationFont: Font
    public let validationColor: Color
    public let showsValidation: Bool

    public static func make(state: DSFormFieldState, theme: DSTheme) -> DSFormFieldRenderModel {
        DSFormFieldRenderModel(
            titleFont: theme.typography.caption,
            titleColor: theme.colors.textSecondary,
            helperFont: theme.typography.caption,
            helperColor: theme.colors.textSecondary,
            validationFont: theme.typography.caption,
            validationColor: theme.colors.danger,
            showsValidation: state.validationMessage != nil
        )
    }
}

public struct DSFormField<Content: View>: View {
    private let title: String?
    private let helperText: String?
    private let config: DSFormFieldConfig
    private let state: DSFormFieldState
    private let content: Content

    @Environment(\.dsTheme) private var theme

    public init(
        title: String? = nil,
        helperText: String? = nil,
        config: DSFormFieldConfig = DSFormFieldConfig(),
        state: DSFormFieldState = DSFormFieldState(),
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.helperText = helperText
        self.config = config
        self.state = state
        self.content = content()
    }

    public var body: some View {
        let model = DSFormFieldRenderModel.make(state: state, theme: theme)
        VStack(alignment: .leading, spacing: config.spacing) {
            if let title {
                Text(title)
                    .font(model.titleFont)
                    .foregroundColor(model.titleColor)
            }

            content

            if let helperText {
                Text(helperText)
                    .font(model.helperFont)
                    .foregroundColor(model.helperColor)
            }

            if model.showsValidation, let message = state.validationMessage {
                Text(message)
                    .font(model.validationFont)
                    .foregroundColor(model.validationColor)
            }
        }
    }
}
