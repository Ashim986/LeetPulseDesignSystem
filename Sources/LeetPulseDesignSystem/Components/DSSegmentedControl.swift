import SwiftUI

public struct DSSegmentItem: Identifiable, Equatable, Sendable {
    public let id: String
    public let title: String

    public init(id: String, title: String) {
        self.id = id
        self.title = title
    }
}

public struct DSSegmentedControlConfig: Sendable {
    public let isFullWidth: Bool

    public init(isFullWidth: Bool = true) {
        self.isFullWidth = isFullWidth
    }
}

public struct DSSegmentedControlState: Equatable, Sendable {
    public var selectedId: String
    public var isEnabled: Bool

    public init(selectedId: String, isEnabled: Bool = true) {
        self.selectedId = selectedId
        self.isEnabled = isEnabled
    }
}

public enum DSSegmentedControlEvent: Sendable {
    case select(String)
    case setEnabled(Bool)
}

public struct DSSegmentedControlReducer: ReducerProtocol {
    public init() {}

    public mutating func reduce(state: inout DSSegmentedControlState, event: DSSegmentedControlEvent) {
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

public struct DSSegmentedRenderModel {
    public let background: Color
    public let selectedBackground: Color
    public let textColor: Color
    public let selectedTextColor: Color
    public let cornerRadius: CGFloat
    public let opacity: Double

    public static func make(state: DSSegmentedControlState, theme: DSTheme) -> DSSegmentedRenderModel {
        DSSegmentedRenderModel(
            background: theme.colors.surfaceElevated,
            selectedBackground: theme.colors.primary,
            textColor: theme.colors.textSecondary,
            selectedTextColor: Color.white,
            cornerRadius: theme.radii.md,
            opacity: state.isEnabled ? 1.0 : 0.6
        )
    }
}

public struct DSSegmentedControl: View {
    private let items: [DSSegmentItem]
    private let config: DSSegmentedControlConfig
    private let state: DSSegmentedControlState
    private let onSelect: (String) -> Void

    @Environment(\.dsTheme) private var theme

    public init(
        items: [DSSegmentItem],
        config: DSSegmentedControlConfig = DSSegmentedControlConfig(),
        state: DSSegmentedControlState,
        onSelect: @escaping (String) -> Void
    ) {
        self.items = items
        self.config = config
        self.state = state
        self.onSelect = onSelect
    }

    public var body: some View {
        let model = DSSegmentedRenderModel.make(state: state, theme: theme)
        HStack(spacing: 0) {
            ForEach(items) { item in
                let isSelected = item.id == state.selectedId
                Button(action: {
                    if state.isEnabled {
                        onSelect(item.id)
                    }
                }, label: {
                    Text(item.title)
                        .font(theme.typography.body)
                        .foregroundColor(isSelected ? model.selectedTextColor : model.textColor)
                        .frame(maxWidth: config.isFullWidth ? .infinity : nil)
                        .padding(.vertical, theme.spacing.sm)
                        .background(isSelected ? model.selectedBackground : Color.clear)
                })
                .buttonStyle(.plain)
            }
        }
        .background(model.background)
        .clipShape(RoundedRectangle(cornerRadius: model.cornerRadius))
        .opacity(model.opacity)
    }
}
