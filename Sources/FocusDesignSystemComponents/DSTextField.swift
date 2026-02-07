import SwiftUI
import FocusDesignSystemCore
import FocusDesignSystemState

public enum DSTextFieldStyle: String, Sendable {
    case filled
    case outlined
}

public enum DSTextFieldSize: String, Sendable {
    case small
    case medium
    case large
}

public enum DSTextFieldValidation: Equatable, Sendable {
    case none
    case valid
    case invalid(String?)
}

public struct DSTextFieldConfig: Sendable {
    public let style: DSTextFieldStyle
    public let size: DSTextFieldSize
    public let isSecure: Bool

    public init(style: DSTextFieldStyle = .filled, size: DSTextFieldSize = .medium, isSecure: Bool = false) {
        self.style = style
        self.size = size
        self.isSecure = isSecure
    }
}

public struct DSTextFieldState: Equatable, Sendable {
    public var isEnabled: Bool
    public var isFocused: Bool
    public var validation: DSTextFieldValidation

    public init(isEnabled: Bool = true, isFocused: Bool = false, validation: DSTextFieldValidation = .none) {
        self.isEnabled = isEnabled
        self.isFocused = isFocused
        self.validation = validation
    }
}

public enum DSTextFieldEvent: Sendable {
    case setEnabled(Bool)
    case setFocused(Bool)
    case setValidation(DSTextFieldValidation)
}

public struct DSTextFieldReducer: ReducerProtocol {
    public init() {}

    public mutating func reduce(state: inout DSTextFieldState, event: DSTextFieldEvent) {
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
        case .setValidation(let value):
            state.validation = value
        }
    }
}

public struct DSTextFieldRenderModel {
    public let background: Color
    public let border: Color
    public let textColor: Color
    public let placeholderColor: Color
    public let font: Font
    public let padding: EdgeInsets
    public let cornerRadius: CGFloat
    public let opacity: Double
    public let showsValidationMessage: Bool
    public let validationMessage: String?

    public static func make(
        state: DSTextFieldState,
        config: DSTextFieldConfig,
        theme: DSTheme
    ) -> DSTextFieldRenderModel {
        let background: Color = config.style == .filled ? theme.colors.surfaceElevated : Color.clear
        let baseBorder = theme.colors.border
        let border: Color = {
            switch state.validation {
            case .none:
                return state.isFocused ? theme.colors.primary : baseBorder
            case .valid:
                return theme.colors.success
            case .invalid:
                return theme.colors.danger
            }
        }()

        let font: Font = {
            switch config.size {
            case .small: return .system(size: 12)
            case .medium: return .system(size: 13)
            case .large: return .system(size: 15)
            }
        }()

        let padding: EdgeInsets = {
            switch config.size {
            case .small:
                return EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10)
            case .medium:
                return EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
            case .large:
                return EdgeInsets(top: 10, leading: 14, bottom: 10, trailing: 14)
            }
        }()

        let opacity = state.isEnabled ? 1.0 : 0.6
        let showsValidationMessage = {
            if case .invalid(let message) = state.validation {
                return message != nil
            }
            return false
        }()
        let validationMessage: String? = {
            if case .invalid(let message) = state.validation {
                return message
            }
            return nil
        }()

        return DSTextFieldRenderModel(
            background: background,
            border: border,
            textColor: theme.colors.textPrimary,
            placeholderColor: theme.colors.textSecondary,
            font: font,
            padding: padding,
            cornerRadius: theme.radii.md,
            opacity: opacity,
            showsValidationMessage: showsValidationMessage,
            validationMessage: validationMessage
        )
    }
}

public struct DSTextField: View {
    private let title: String?
    private let placeholder: String
    private let config: DSTextFieldConfig
    private let state: DSTextFieldState
    private let validator: DSValidator?
    private let validationPolicy: DSTextInputValidationPolicy
    private let onValidation: ((DSValidationResult) -> Void)?
    private let onFocusChange: ((Bool) -> Void)?
    @Binding private var text: String

    @Environment(\.dsTheme) private var theme
    @FocusState private var isFocused: Bool

    public init(
        title: String? = nil,
        placeholder: String,
        text: Binding<String>,
        config: DSTextFieldConfig = DSTextFieldConfig(),
        state: DSTextFieldState = DSTextFieldState(),
        validator: DSValidator? = nil,
        validationPolicy: DSTextInputValidationPolicy = .manual,
        onValidation: ((DSValidationResult) -> Void)? = nil,
        onFocusChange: ((Bool) -> Void)? = nil
    ) {
        self.title = title
        self.placeholder = placeholder
        self._text = text
        self.config = config
        self.state = state
        self.validator = validator
        self.validationPolicy = validationPolicy
        self.onValidation = onValidation
        self.onFocusChange = onFocusChange
    }

    public var body: some View {
        let model = DSTextFieldRenderModel.make(state: state, config: config, theme: theme)

        VStack(alignment: .leading, spacing: theme.spacing.xs) {
            if let title {
                Text(title)
                    .font(theme.typography.caption)
                    .foregroundColor(theme.colors.textSecondary)
            }

            inputField(model: model)
                .opacity(model.opacity)
                .overlay(
                    RoundedRectangle(cornerRadius: model.cornerRadius)
                        .stroke(model.border, lineWidth: 1)
                )
                .background(model.background)
                .clipShape(RoundedRectangle(cornerRadius: model.cornerRadius))

            if model.showsValidationMessage, let message = model.validationMessage {
                Text(message)
                    .font(theme.typography.caption)
                    .foregroundColor(theme.colors.danger)
            }
        }
        .onChange(of: text) { _, _ in
            validateIfNeeded(trigger: .onChange)
        }
        .onChange(of: isFocused) { _, newValue in
            if !newValue {
                validateIfNeeded(trigger: .onBlur)
            }
            onFocusChange?(newValue)
        }
        .onSubmit {
            validateIfNeeded(trigger: .onSubmit)
        }
    }

    @ViewBuilder
    private func inputField(model: DSTextFieldRenderModel) -> some View {
        if config.isSecure {
            SecureField(placeholder, text: $text)
                .font(model.font)
                .foregroundColor(model.textColor)
                .padding(model.padding)
                .focused($isFocused)
                .disabled(!state.isEnabled)
        } else {
            TextField(placeholder, text: $text)
                .font(model.font)
                .foregroundColor(model.textColor)
                .padding(model.padding)
                .focused($isFocused)
                .disabled(!state.isEnabled)
        }
    }

    private func validateIfNeeded(trigger: DSTextInputValidationPolicy) {
        guard validationPolicy == trigger, let validator else { return }
        let result = validator.validate(text)
        onValidation?(result)
    }
}

public extension DSTextFieldValidation {
    init(result: DSValidationResult) {
        switch result {
        case .valid:
            self = .valid
        case .invalid(let message):
            self = .invalid(message)
        }
    }
}
