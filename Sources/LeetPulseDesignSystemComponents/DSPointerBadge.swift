import SwiftUI
import LeetPulseDesignSystemCore

public struct DSPointerBadgeConfig: Sendable {
    public let font: Font
    public let textColor: Color
    public let backgroundColor: Color
    public let horizontalPadding: CGFloat
    public let verticalPadding: CGFloat

    public init(
        font: Font = .system(size: 8, weight: .semibold),
        textColor: Color = .white,
        backgroundColor: Color = .blue,
        horizontalPadding: CGFloat = 6,
        verticalPadding: CGFloat = 2
    ) {
        self.font = font
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
    }
}

public struct DSPointerBadgeRenderModel {
    public let font: Font
    public let textColor: Color
    public let backgroundColor: Color
    public let horizontalPadding: CGFloat
    public let verticalPadding: CGFloat

    public static func make(config: DSPointerBadgeConfig, theme: DSTheme) -> DSPointerBadgeRenderModel {
        DSPointerBadgeRenderModel(
            font: config.font,
            textColor: config.textColor,
            backgroundColor: config.backgroundColor,
            horizontalPadding: config.horizontalPadding,
            verticalPadding: config.verticalPadding
        )
    }
}

public struct DSPointerBadge: View {
    private let text: String
    private let config: DSPointerBadgeConfig

    @Environment(\.dsTheme) private var theme

    public init(
        text: String,
        config: DSPointerBadgeConfig = DSPointerBadgeConfig()
    ) {
        self.text = text
        self.config = config
    }

    public var body: some View {
        let model = DSPointerBadgeRenderModel.make(config: config, theme: theme)
        Text(text)
            .font(model.font)
            .foregroundColor(model.textColor)
            .padding(.horizontal, model.horizontalPadding)
            .padding(.vertical, model.verticalPadding)
            .background(
                Capsule()
                    .fill(model.backgroundColor)
            )
    }
}

public struct DSPointerMarker: Identifiable, Hashable, Sendable {
    public let id: String
    public let name: String
    public let index: Int?
    public let nodeId: String?
    public let color: Color?

    public init(
        name: String,
        index: Int? = nil,
        nodeId: String? = nil,
        color: Color? = nil
    ) {
        self.id = "\(name)-\(index ?? -1)-\(nodeId ?? "none")"
        self.name = name
        self.index = index
        self.nodeId = nodeId
        self.color = color
    }

    public func resolvedColor(theme: DSTheme) -> Color {
        color ?? DSPointerPalette.color(for: name, theme: theme)
    }
}

public struct DSPointerMotion: Identifiable, Hashable, Sendable {
    public let id: String
    public let name: String
    public let fromIndex: Int
    public let toIndex: Int
    public let color: Color?

    public init(
        name: String,
        fromIndex: Int,
        toIndex: Int,
        color: Color? = nil
    ) {
        self.id = "\(name)-\(fromIndex)-\(toIndex)"
        self.name = name
        self.fromIndex = fromIndex
        self.toIndex = toIndex
        self.color = color
    }

    public func resolvedColor(theme: DSTheme) -> Color {
        color ?? DSPointerPalette.color(for: name, theme: theme)
    }
}

public struct DSTreePointerMotion: Identifiable, Hashable, Sendable {
    public let id: String
    public let name: String
    public let fromId: String
    public let toId: String
    public let color: Color?

    public init(
        name: String,
        fromId: String,
        toId: String,
        color: Color? = nil
    ) {
        self.id = "\(name)-\(fromId)-\(toId)"
        self.name = name
        self.fromId = fromId
        self.toId = toId
        self.color = color
    }

    public func resolvedColor(theme: DSTheme) -> Color {
        color ?? DSPointerPalette.color(for: name, theme: theme)
    }
}

public enum DSPointerPalette {
    public static func color(for name: String, theme: DSTheme) -> Color {
        let palette: [Color] = [
            theme.colors.accent,
            theme.colors.primary,
            theme.colors.success,
            theme.colors.warning,
            theme.colors.danger,
            theme.colors.secondary
        ]
        let index = abs(name.lowercased().hashValue) % palette.count
        return palette[index].opacity(0.9)
    }
}
