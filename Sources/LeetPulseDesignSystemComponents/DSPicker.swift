import LeetPulseDesignSystemCore
import LeetPulseDesignSystemState
import SwiftUI

// MARK: - Picker Style

public enum DSPickerStyle: String, Sendable {
    case chips      // Horizontal scrollable pill buttons (default)
    case inline     // Inline segmented-style row
}

// MARK: - Picker Item

public struct DSPickerItem: Identifiable, Hashable, Sendable {
    public let id: String
    public let title: String
    public let icon: String?

    public init(id: String, title: String, icon: String? = nil) {
        self.id = id
        self.title = title
        self.icon = icon
    }
}

// MARK: - Config

public struct DSPickerConfig: Sendable {
    public let style: DSPickerStyle
    public let isScrollable: Bool
    public let spacing: CGFloat?

    public init(
        style: DSPickerStyle = .chips,
        isScrollable: Bool = true,
        spacing: CGFloat? = nil
    ) {
        self.style = style
        self.isScrollable = isScrollable
        self.spacing = spacing
    }
}

// MARK: - State

public struct DSPickerState: Equatable, Sendable {
    public var selectedId: String
    public var isEnabled: Bool

    public init(selectedId: String, isEnabled: Bool = true) {
        self.selectedId = selectedId
        self.isEnabled = isEnabled
    }
}

// MARK: - Event

public enum DSPickerEvent: Sendable {
    case select(String)
    case setEnabled(Bool)
}

// MARK: - Reducer

public struct DSPickerReducer: ReducerProtocol {
    public init() {}

    public mutating func reduce(state: inout DSPickerState, event: DSPickerEvent) {
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

// MARK: - Render Model

public struct DSPickerRenderModel {
    public let selectedBackground: Color
    public let unselectedBackground: Color
    public let selectedTextColor: Color
    public let unselectedTextColor: Color
    public let selectedBorder: Color
    public let unselectedBorder: Color
    public let font: Font
    public let cornerRadius: CGFloat
    public let opacity: Double

    public static func make(
        state: DSPickerState,
        config: DSPickerConfig,
        theme: DSTheme
    ) -> DSPickerRenderModel {
        let cornerRadius: CGFloat = config.style == .chips
            ? theme.radii.pill
            : theme.radii.md

        return DSPickerRenderModel(
            selectedBackground: theme.colors.primary,
            unselectedBackground: theme.colors.surface,
            selectedTextColor: Color.white,
            unselectedTextColor: theme.colors.textPrimary,
            selectedBorder: Color.clear,
            unselectedBorder: theme.colors.border,
            font: theme.typography.body,
            cornerRadius: cornerRadius,
            opacity: state.isEnabled ? 1.0 : 0.6
        )
    }
}

// MARK: - View

public struct DSPicker: View {
    private let items: [DSPickerItem]
    private let config: DSPickerConfig
    private let state: DSPickerState
    private let onSelect: (String) -> Void

    @Environment(\.dsTheme) private var theme

    public init(
        items: [DSPickerItem],
        config: DSPickerConfig = DSPickerConfig(),
        state: DSPickerState,
        onSelect: @escaping (String) -> Void
    ) {
        self.items = items
        self.config = config
        self.state = state
        self.onSelect = onSelect
    }

    public var body: some View {
        let model = DSPickerRenderModel.make(state: state, config: config, theme: theme)
        let spacing = config.spacing ?? theme.spacing.sm

        if config.isScrollable {
            ScrollView(.horizontal, showsIndicators: false) {
                itemRow(model: model, spacing: spacing)
            }
            .opacity(model.opacity)
        } else {
            itemRow(model: model, spacing: spacing)
                .opacity(model.opacity)
        }
    }

    private func itemRow(model: DSPickerRenderModel, spacing: CGFloat) -> some View {
        HStack(spacing: spacing) {
            ForEach(items) { item in
                let isSelected = item.id == state.selectedId

                Button {
                    if state.isEnabled {
                        onSelect(item.id)
                    }
                } label: {
                    HStack(spacing: theme.spacing.xs) {
                        if let icon = item.icon {
                            Image(systemName: icon)
                                .font(.system(size: 12, weight: .semibold))
                        }
                        Text(item.title)
                            .font(model.font)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(
                        isSelected
                            ? model.selectedTextColor
                            : model.unselectedTextColor
                    )
                    .padding(.horizontal, theme.spacing.md)
                    .frame(height: 36)
                    .background(
                        isSelected
                            ? model.selectedBackground
                            : model.unselectedBackground
                    )
                    .clipShape(
                        RoundedRectangle(cornerRadius: model.cornerRadius)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: model.cornerRadius)
                            .stroke(
                                isSelected
                                    ? model.selectedBorder
                                    : model.unselectedBorder,
                                lineWidth: 1
                            )
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
}
