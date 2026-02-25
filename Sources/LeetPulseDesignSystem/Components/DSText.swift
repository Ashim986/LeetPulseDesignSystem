import SwiftUI

public enum DSTextStyle: String, Sendable {
    case title
    case subtitle
    case body
    case caption
    case mono
}

public enum DSTextColor: Sendable {
    case primary
    case secondary
    case accent
    case success
    case warning
    case danger
    case custom(Color)
}

public struct DSText: View {
    private let text: Text
    private let style: DSTextStyle
    private let color: DSTextColor

    @Environment(\.dsTheme) private var theme

    public init(
        _ key: LocalizedStringKey,
        style: DSTextStyle = .body,
        color: DSTextColor = .primary
    ) {
        self.text = Text(key)
        self.style = style
        self.color = color
    }

    public init(
        _ value: String,
        style: DSTextStyle = .body,
        color: DSTextColor = .primary
    ) {
        self.text = Text(value)
        self.style = style
        self.color = color
    }

    public init(
        verbatim value: String,
        style: DSTextStyle = .body,
        color: DSTextColor = .primary
    ) {
        self.text = Text(verbatim: value)
        self.style = style
        self.color = color
    }

    public init(
        _ value: AttributedString,
        style: DSTextStyle = .body,
        color: DSTextColor = .primary
    ) {
        self.text = Text(value)
        self.style = style
        self.color = color
    }

    public var body: some View {
        text
            .font(font(for: style))
            .foregroundColor(color.resolve(theme: theme))
    }

    private func font(for style: DSTextStyle) -> Font {
        switch style {
        case .title:
            return theme.typography.title
        case .subtitle:
            return theme.typography.subtitle
        case .body:
            return theme.typography.body
        case .caption:
            return theme.typography.caption
        case .mono:
            return theme.typography.mono
        }
    }
}

private extension DSTextColor {
    func resolve(theme: DSTheme) -> Color {
        switch self {
        case .primary:
            return theme.colors.textPrimary
        case .secondary:
            return theme.colors.textSecondary
        case .accent:
            return theme.colors.accent
        case .success:
            return theme.colors.success
        case .warning:
            return theme.colors.warning
        case .danger:
            return theme.colors.danger
        case .custom(let color):
            return color
        }
    }
}
