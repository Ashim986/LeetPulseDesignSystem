import SwiftUI
import LeetPulseDesignSystemCore
import LeetPulseDesignSystemState

public enum DSBubbleStyle: String, Sendable {
    case solid
}

public enum DSBubbleChangeType: String, Sendable {
    case added
    case removed
    case modified
    case unchanged
}

public struct DSBubbleConfig: Sendable {
    public let size: CGFloat
    public let style: DSBubbleStyle
    public let fill: Color?
    public let textColor: Color?
    public let highlightColor: Color?
    public let highlightLineWidth: CGFloat
    public let changeLineWidth: CGFloat
    public let changeOverlayOpacity: Double
    public let font: Font?

    public init(
        size: CGFloat = 30,
        style: DSBubbleStyle = .solid,
        fill: Color? = nil,
        textColor: Color? = nil,
        highlightColor: Color? = nil,
        highlightLineWidth: CGFloat = 2,
        changeLineWidth: CGFloat = 1.5,
        changeOverlayOpacity: Double = 0.25,
        font: Font? = nil
    ) {
        self.size = size
        self.style = style
        self.fill = fill
        self.textColor = textColor
        self.highlightColor = highlightColor
        self.highlightLineWidth = highlightLineWidth
        self.changeLineWidth = changeLineWidth
        self.changeOverlayOpacity = changeOverlayOpacity
        self.font = font
    }
}

public struct DSBubbleState: Equatable, Sendable {
    public var isHighlighted: Bool
    public var changeType: DSBubbleChangeType?

    public init(isHighlighted: Bool = false, changeType: DSBubbleChangeType? = nil) {
        self.isHighlighted = isHighlighted
        self.changeType = changeType
    }
}

public enum DSBubbleEvent: Sendable {
    case setHighlighted(Bool)
    case setChangeType(DSBubbleChangeType?)
}

public struct DSBubbleReducer: ReducerProtocol {
    public init() {}

    public mutating func reduce(state: inout DSBubbleState, event: DSBubbleEvent) {
        switch event {
        case .setHighlighted(let value):
            state.isHighlighted = value
        case .setChangeType(let value):
            state.changeType = value
        }
    }
}

public struct DSBubbleRenderModel {
    public let fill: Color
    public let textColor: Color
    public let highlightColor: Color
    public let highlightShadowColor: Color
    public let highlightLineWidth: CGFloat
    public let changeStrokeColor: Color?
    public let changeFillColor: Color?
    public let changeLineWidth: CGFloat
    public let font: Font

    public static func make(
        text: String,
        state: DSBubbleState,
        config: DSBubbleConfig,
        theme: DSTheme
    ) -> DSBubbleRenderModel {
        let fill = config.fill ?? theme.colors.secondary.opacity(0.3)
        let textColor = config.textColor ?? Color.white
        let highlightColor = config.highlightColor ?? theme.colors.accent
        let highlightShadowColor = highlightColor.opacity(0.6)

        let font = config.font ?? .system(
            size: max(8, config.size * 0.33),
            weight: .semibold
        )

        let changeStrokeColor: Color?
        let changeFillColor: Color?

        switch state.changeType {
        case .added:
            changeStrokeColor = theme.colors.success
            changeFillColor = nil
        case .removed:
            changeStrokeColor = nil
            changeFillColor = theme.colors.danger.opacity(config.changeOverlayOpacity)
        case .modified:
            changeStrokeColor = theme.colors.warning
            changeFillColor = nil
        case .unchanged, .none:
            changeStrokeColor = nil
            changeFillColor = nil
        }

        return DSBubbleRenderModel(
            fill: fill,
            textColor: textColor,
            highlightColor: highlightColor,
            highlightShadowColor: highlightShadowColor,
            highlightLineWidth: config.highlightLineWidth,
            changeStrokeColor: changeStrokeColor,
            changeFillColor: changeFillColor,
            changeLineWidth: config.changeLineWidth,
            font: font
        )
    }
}

public struct DSBubble: View {
    private let text: String
    private let config: DSBubbleConfig
    private let state: DSBubbleState

    @Environment(\.dsTheme) private var theme

    public init(
        text: String,
        config: DSBubbleConfig = DSBubbleConfig(),
        state: DSBubbleState = DSBubbleState()
    ) {
        self.text = text
        self.config = config
        self.state = state
    }

    public var body: some View {
        let model = DSBubbleRenderModel.make(text: text, state: state, config: config, theme: theme)

        ZStack {
            Circle()
                .fill(model.fill)

            Text(text)
                .font(model.font)
                .foregroundColor(model.textColor)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                .padding(.horizontal, 4)
        }
        .frame(width: config.size, height: config.size)
        .overlay(highlightOverlay(model: model))
    }

    @ViewBuilder
    private func highlightOverlay(model: DSBubbleRenderModel) -> some View {
        if state.isHighlighted {
            Circle()
                .stroke(model.highlightColor, lineWidth: model.highlightLineWidth)
                .shadow(color: model.highlightShadowColor, radius: 4)
        }

        if let changeStrokeColor = model.changeStrokeColor {
            Circle()
                .stroke(changeStrokeColor, lineWidth: model.changeLineWidth)
                .shadow(color: changeStrokeColor.opacity(0.5), radius: 3)
        }

        if let changeFillColor = model.changeFillColor {
            Circle()
                .fill(changeFillColor)
        }
    }
}
