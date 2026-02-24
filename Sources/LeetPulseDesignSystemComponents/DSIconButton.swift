import SwiftUI
import LeetPulseDesignSystemCore
import LeetPulseDesignSystemState

public struct DSIconButtonConfig: Sendable {
    public let style: DSButtonStyle
    public let size: DSButtonSize

    public init(style: DSButtonStyle = .ghost, size: DSButtonSize = .medium) {
        self.style = style
        self.size = size
    }
}

public struct DSIconButton: View {
    private let icon: Image
    private let config: DSIconButtonConfig
    private let state: DSButtonState
    private let action: () -> Void

    @Environment(\.dsTheme) private var theme

    public init(
        icon: Image,
        config: DSIconButtonConfig = DSIconButtonConfig(),
        state: DSButtonState = DSButtonState(),
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.config = config
        self.state = state
        self.action = action
    }

    public var body: some View {
        let buttonConfig = DSButtonConfig(style: config.style, size: config.size)
        let model = DSButtonRenderModel.make(state: state, config: buttonConfig, theme: theme)
        let iconSize = iconPointSize(for: config.size)

        Button(action: {
            if state.isEnabled && !state.isLoading {
                action()
            }
        }, label: {
            ZStack {
                if model.showsSpinner {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(model.spinnerColor)
                } else {
                    icon
                        .font(.system(size: iconSize, weight: .semibold))
                        .foregroundColor(model.iconColor)
                }
            }
            .frame(width: iconSize + model.padding.leading + model.padding.trailing,
                   height: iconSize + model.padding.top + model.padding.bottom)
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

    private func iconPointSize(for size: DSButtonSize) -> CGFloat {
        switch size {
        case .small:
            return 12
        case .medium:
            return 14
        case .large:
            return 16
        }
    }
}
