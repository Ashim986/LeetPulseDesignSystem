import SwiftUI
import LeetPulseDesignSystemCore
import LeetPulseDesignSystemState

public struct DSToggleConfig: Sendable {
    public let size: CGFloat

    public init(size: CGFloat = 22) {
        self.size = size
    }
}

public struct DSToggleState: Equatable, Sendable {
    public var isOn: Bool
    public var isEnabled: Bool

    public init(isOn: Bool = false, isEnabled: Bool = true) {
        self.isOn = isOn
        self.isEnabled = isEnabled
    }
}

public enum DSToggleEvent: Sendable {
    case setOn(Bool)
    case toggle
    case setEnabled(Bool)
}

public struct DSToggleReducer: ReducerProtocol {
    public init() {}

    public mutating func reduce(state: inout DSToggleState, event: DSToggleEvent) {
        switch event {
        case .setOn(let value):
            state.isOn = value
        case .toggle:
            if state.isEnabled {
                state.isOn.toggle()
            }
        case .setEnabled(let value):
            state.isEnabled = value
        }
    }
}

public struct DSToggleRenderModel {
    public let trackColor: Color
    public let thumbColor: Color
    public let textColor: Color
    public let opacity: Double
    public let size: CGFloat

    public static func make(state: DSToggleState, config: DSToggleConfig, theme: DSTheme) -> DSToggleRenderModel {
        let trackColor = state.isOn ? theme.colors.primary : theme.colors.border
        let thumbColor = Color.white
        let opacity = state.isEnabled ? 1.0 : 0.6
        return DSToggleRenderModel(
            trackColor: trackColor,
            thumbColor: thumbColor,
            textColor: theme.colors.textPrimary,
            opacity: opacity,
            size: config.size
        )
    }
}

public struct DSToggle: View {
    private let title: String
    private let config: DSToggleConfig
    private let state: DSToggleState
    private let onToggle: (Bool) -> Void

    @Environment(\.dsTheme) private var theme

    public init(
        _ title: String,
        config: DSToggleConfig = DSToggleConfig(),
        state: DSToggleState = DSToggleState(),
        onToggle: @escaping (Bool) -> Void
    ) {
        self.title = title
        self.config = config
        self.state = state
        self.onToggle = onToggle
    }

    public var body: some View {
        let model = DSToggleRenderModel.make(state: state, config: config, theme: theme)
        Button(action: {
            if state.isEnabled {
                onToggle(!state.isOn)
            }
        }, label: {
            HStack(spacing: theme.spacing.sm) {
                Text(title)
                    .font(theme.typography.body)
                    .foregroundColor(model.textColor)

                Spacer(minLength: theme.spacing.sm)

                ZStack(alignment: state.isOn ? .trailing : .leading) {
                    RoundedRectangle(cornerRadius: config.size)
                        .fill(model.trackColor)
                        .frame(width: config.size * 2, height: config.size)

                    Circle()
                        .fill(model.thumbColor)
                        .frame(width: config.size - 6, height: config.size - 6)
                        .padding(3)
                }
            }
            .opacity(model.opacity)
        })
        .buttonStyle(.plain)
        .disabled(!state.isEnabled)
    }
}
