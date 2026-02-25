import SwiftUI

public struct DSTextAreaConfig: Sendable {
    public let minHeight: CGFloat
    public let isResizable: Bool

    public init(minHeight: CGFloat = 120, isResizable: Bool = true) {
        self.minHeight = minHeight
        self.isResizable = isResizable
    }
}

public struct DSTextAreaState: Equatable, Sendable {
    public var isEnabled: Bool
    public var isFocused: Bool

    public init(isEnabled: Bool = true, isFocused: Bool = false) {
        self.isEnabled = isEnabled
        self.isFocused = isFocused
    }
}

public enum DSTextAreaEvent: Sendable {
    case setEnabled(Bool)
    case setFocused(Bool)
}

public struct DSTextAreaReducer: ReducerProtocol {
    public init() {}

    public mutating func reduce(state: inout DSTextAreaState, event: DSTextAreaEvent) {
        switch event {
        case .setEnabled(let value):
            state.isEnabled = value
            if !value {
                state.isFocused = false
            }
        case .setFocused(let value):
            if state.isEnabled {
                state.isFocused = value
            }
        }
    }
}

public struct DSTextAreaRenderModel {
    public let background: Color
    public let border: Color
    public let textColor: Color
    public let font: Font
    public let cornerRadius: CGFloat
    public let opacity: Double

    public static func make(state: DSTextAreaState, theme: DSTheme) -> DSTextAreaRenderModel {
        let border = state.isFocused ? theme.colors.primary : theme.colors.border
        let opacity = state.isEnabled ? 1.0 : 0.6
        return DSTextAreaRenderModel(
            background: theme.colors.surfaceElevated,
            border: border,
            textColor: theme.colors.textPrimary,
            font: theme.typography.body,
            cornerRadius: theme.radii.md,
            opacity: opacity
        )
    }
}

public struct DSTextArea: View {
    private let placeholder: String
    private let config: DSTextAreaConfig
    private let state: DSTextAreaState
    private let onFocusChange: ((Bool) -> Void)?
    @Binding private var text: String

    @Environment(\.dsTheme) private var theme
    @FocusState private var isFocused: Bool

    public init(
        placeholder: String,
        text: Binding<String>,
        config: DSTextAreaConfig = DSTextAreaConfig(),
        state: DSTextAreaState = DSTextAreaState(),
        onFocusChange: ((Bool) -> Void)? = nil
    ) {
        self.placeholder = placeholder
        self._text = text
        self.config = config
        self.state = state
        self.onFocusChange = onFocusChange
    }

    public var body: some View {
        let model = DSTextAreaRenderModel.make(state: state, theme: theme)
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(placeholder)
                    .font(model.font)
                    .foregroundColor(theme.colors.textSecondary)
                    .padding(10)
            }

            TextEditor(text: $text)
                .font(model.font)
                .foregroundColor(model.textColor)
                .padding(6)
                .focused($isFocused)
                .disabled(!state.isEnabled)
        }
        .frame(minHeight: config.minHeight)
        .background(model.background)
        .overlay(
            RoundedRectangle(cornerRadius: model.cornerRadius)
                .stroke(model.border, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: model.cornerRadius))
        .opacity(model.opacity)
        .onChange(of: isFocused) { _, newValue in
            onFocusChange?(newValue)
        }
    }
}
