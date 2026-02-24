import SwiftUI
import LeetPulseDesignSystemCore
import LeetPulseDesignSystemState

public enum DSSelectStyle: String, Sendable {
    case filled
    case outlined
}

public struct DSSelectItem: Identifiable, Hashable, Sendable {
    public let id: String
    public let title: String
    public let subtitle: String?

    public init(id: String, title: String, subtitle: String? = nil) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
    }
}

public struct DSSelectConfig: Sendable {
    public let style: DSSelectStyle
    public let isCompact: Bool
    public let showsChevron: Bool
    public let minWidth: CGFloat?

    public init(
        style: DSSelectStyle = .filled,
        isCompact: Bool = false,
        showsChevron: Bool = true,
        minWidth: CGFloat? = nil
    ) {
        self.style = style
        self.isCompact = isCompact
        self.showsChevron = showsChevron
        self.minWidth = minWidth
    }
}

public struct DSSelectState: Equatable, Sendable {
    public var selectedId: String?
    public var isEnabled: Bool

    public init(selectedId: String? = nil, isEnabled: Bool = true) {
        self.selectedId = selectedId
        self.isEnabled = isEnabled
    }
}

public enum DSSelectEvent: Sendable {
    case select(String?)
    case setEnabled(Bool)
}

public struct DSSelectReducer: ReducerProtocol {
    public init() {}

    public mutating func reduce(state: inout DSSelectState, event: DSSelectEvent) {
        switch event {
        case .select(let id):
            if state.isEnabled {
                state.selectedId = id
            }
        case .setEnabled(let value):
            state.isEnabled = value
        }
    }
}

public struct DSSelectRenderModel {
    public let background: Color
    public let border: Color
    public let textColor: Color
    public let placeholderColor: Color
    public let font: Font
    public let cornerRadius: CGFloat
    public let opacity: Double
    public let padding: EdgeInsets
    public let chevronColor: Color

    public static func make(state: DSSelectState, config: DSSelectConfig, theme: DSTheme) -> DSSelectRenderModel {
        let background: Color = config.style == .filled ? theme.colors.surfaceElevated : .clear
        let border: Color = theme.colors.border
        let font = theme.typography.body
        let padding: EdgeInsets = {
            if config.isCompact {
                return EdgeInsets(
                    top: theme.spacing.xs,
                    leading: theme.spacing.sm,
                    bottom: theme.spacing.xs,
                    trailing: theme.spacing.sm
                )
            }

            return EdgeInsets(
                top: theme.spacing.sm,
                leading: theme.spacing.md,
                bottom: theme.spacing.sm,
                trailing: theme.spacing.md
            )
        }()

        return DSSelectRenderModel(
            background: background,
            border: border,
            textColor: theme.colors.textPrimary,
            placeholderColor: theme.colors.textSecondary,
            font: font,
            cornerRadius: theme.radii.md,
            opacity: state.isEnabled ? 1.0 : 0.6,
            padding: padding,
            chevronColor: theme.colors.textSecondary
        )
    }
}

public struct DSSelect: View {
    private let placeholder: String
    private let items: [DSSelectItem]
    private let config: DSSelectConfig
    private let state: DSSelectState
    private let onSelect: (DSSelectItem) -> Void

    @Environment(\.dsTheme) private var theme

    public init(
        placeholder: String,
        items: [DSSelectItem],
        config: DSSelectConfig = DSSelectConfig(),
        state: DSSelectState = DSSelectState(),
        onSelect: @escaping (DSSelectItem) -> Void
    ) {
        self.placeholder = placeholder
        self.items = items
        self.config = config
        self.state = state
        self.onSelect = onSelect
    }

    public var body: some View {
        let model = DSSelectRenderModel.make(state: state, config: config, theme: theme)
        let selectedItem = items.first { $0.id == state.selectedId }
        let displayText = selectedItem?.title ?? placeholder
        let displayColor = selectedItem == nil ? model.placeholderColor : model.textColor

        Menu {
            ForEach(items) { item in
                Button(item.title) {
                    onSelect(item)
                }
            }
        } label: {
            HStack(spacing: theme.spacing.sm) {
                VStack(alignment: .leading, spacing: theme.spacing.xs) {
                    Text(displayText)
                        .font(model.font)
                        .foregroundColor(displayColor)

                    if let subtitle = selectedItem?.subtitle {
                        Text(subtitle)
                            .font(theme.typography.caption)
                            .foregroundColor(theme.colors.textSecondary)
                    }
                }

                Spacer(minLength: theme.spacing.sm)

                if config.showsChevron {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(model.chevronColor)
                }
            }
            .padding(model.padding)
            .frame(minWidth: config.minWidth)
            .background(model.background)
            .overlay(
                RoundedRectangle(cornerRadius: model.cornerRadius)
                    .stroke(model.border, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: model.cornerRadius))
            .opacity(model.opacity)
        }
        .disabled(!state.isEnabled)
    }
}
