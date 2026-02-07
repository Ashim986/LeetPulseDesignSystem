import SwiftUI
import FocusDesignSystemCore

public enum DSImageTint: Sendable {
    case primary
    case secondary
    case accent
    case success
    case warning
    case danger
    case custom(Color)
}

public struct DSImage: View {
    private let image: Image
    private let tint: DSImageTint?
    private let renderingMode: Image.TemplateRenderingMode

    @Environment(\.dsTheme) private var theme

    public init(
        _ name: String,
        tint: DSImageTint? = nil,
        renderingMode: Image.TemplateRenderingMode = .template
    ) {
        self.image = Image(name)
        self.tint = tint
        self.renderingMode = renderingMode
    }

    public init(
        systemName: String,
        tint: DSImageTint? = nil,
        renderingMode: Image.TemplateRenderingMode = .template
    ) {
        self.image = Image(systemName: systemName)
        self.tint = tint
        self.renderingMode = renderingMode
    }

    #if os(macOS)
    public init(
        nsImage: NSImage,
        tint: DSImageTint? = nil,
        renderingMode: Image.TemplateRenderingMode = .template
    ) {
        self.image = Image(nsImage: nsImage)
        self.tint = tint
        self.renderingMode = renderingMode
    }
    #endif

    #if os(iOS)
    public init(
        uiImage: UIImage,
        tint: DSImageTint? = nil,
        renderingMode: Image.TemplateRenderingMode = .template
    ) {
        self.image = Image(uiImage: uiImage)
        self.tint = tint
        self.renderingMode = renderingMode
    }
    #endif

    public var body: some View {
        let resolvedTint = tint?.resolve(theme: theme)

        if let resolvedTint {
            image
                .renderingMode(.template)
                .foregroundColor(resolvedTint)
        } else {
            image
                .renderingMode(renderingMode)
        }
    }
}

private extension DSImageTint {
    func resolve(theme: DSTheme) -> Color {
        switch self {
        case .primary:
            return theme.colors.primary
        case .secondary:
            return theme.colors.secondary
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
