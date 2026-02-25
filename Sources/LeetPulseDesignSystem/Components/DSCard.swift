import SwiftUI

public enum DSCardStyle: String, Sendable {
    case surface
    case elevated
    case outlined
}

public struct DSCardConfig: Sendable {
    public let style: DSCardStyle
    public let padding: CGFloat
    public let cornerRadius: CGFloat?

    public init(style: DSCardStyle = .surface, padding: CGFloat = 16, cornerRadius: CGFloat? = nil) {
        self.style = style
        self.padding = padding
        self.cornerRadius = cornerRadius
    }
}

public struct DSCardState: Equatable, Sendable {
    public var isHighlighted: Bool
    public var isDisabled: Bool

    public init(isHighlighted: Bool = false, isDisabled: Bool = false) {
        self.isHighlighted = isHighlighted
        self.isDisabled = isDisabled
    }
}

public struct DSCardRenderModel {
    public let background: Color
    public let border: Color?
    public let shadow: DSShadow?
    public let opacity: Double
    public let cornerRadius: CGFloat

    public static func make(state: DSCardState, config: DSCardConfig, theme: DSTheme) -> DSCardRenderModel {
        let baseBackground: Color
        let border: Color?
        let shadow: DSShadow?

        switch config.style {
        case .surface:
            baseBackground = theme.colors.surface
            border = nil
            shadow = nil
        case .elevated:
            baseBackground = theme.colors.surfaceElevated
            border = nil
            shadow = theme.shadow
        case .outlined:
            baseBackground = theme.colors.surface
            border = theme.colors.border
            shadow = nil
        }

        let background = state.isHighlighted ? baseBackground.opacity(0.9) : baseBackground
        let opacity = state.isDisabled ? 0.6 : 1.0
        let cornerRadius = config.cornerRadius ?? theme.radii.lg

        return DSCardRenderModel(
            background: background,
            border: border,
            shadow: shadow,
            opacity: opacity,
            cornerRadius: cornerRadius
        )
    }
}

public struct DSCard<Content: View>: View {
    private let config: DSCardConfig
    private let state: DSCardState
    private let content: Content

    @Environment(\.dsTheme) private var theme

    public init(
        config: DSCardConfig = DSCardConfig(),
        state: DSCardState = DSCardState(),
        @ViewBuilder content: () -> Content
    ) {
        self.config = config
        self.state = state
        self.content = content()
    }

    public var body: some View {
        let model = DSCardRenderModel.make(state: state, config: config, theme: theme)
        content
            .padding(config.padding)
            .background(model.background)
            .overlay(
                RoundedRectangle(cornerRadius: model.cornerRadius)
                    .stroke(model.border ?? Color.clear, lineWidth: model.border == nil ? 0 : 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: model.cornerRadius))
            .shadow(
                color: model.shadow?.color ?? .clear,
                radius: model.shadow?.radius ?? 0,
                x: model.shadow?.x ?? 0,
                y: model.shadow?.y ?? 0
            )
            .opacity(model.opacity)
    }
}
