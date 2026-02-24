import SwiftUI
import LeetPulseDesignSystemCore
import LeetPulseDesignSystemState

public enum DSHeaderAlignment: String, Sendable {
    case leading
    case center
}

public struct DSHeaderConfig: Sendable {
    public let alignment: DSHeaderAlignment
    public let showsDivider: Bool

    public init(alignment: DSHeaderAlignment = .leading, showsDivider: Bool = false) {
        self.alignment = alignment
        self.showsDivider = showsDivider
    }
}

public struct DSHeaderState: Equatable, Sendable {
    public var isLoading: Bool

    public init(isLoading: Bool = false) {
        self.isLoading = isLoading
    }
}

public enum DSHeaderEvent: Sendable {
    case setLoading(Bool)
}

public struct DSHeaderReducer: ReducerProtocol {
    public init() {}

    public mutating func reduce(state: inout DSHeaderState, event: DSHeaderEvent) {
        switch event {
        case .setLoading(let value):
            state.isLoading = value
        }
    }
}

public struct DSHeaderRenderModel {
    public let titleFont: Font
    public let subtitleFont: Font
    public let titleColor: Color
    public let subtitleColor: Color
    public let alignment: HorizontalAlignment

    public static func make(state: DSHeaderState, config: DSHeaderConfig, theme: DSTheme) -> DSHeaderRenderModel {
        let alignment: HorizontalAlignment = config.alignment == .center ? .center : .leading
        return DSHeaderRenderModel(
            titleFont: theme.typography.title,
            subtitleFont: theme.typography.body,
            titleColor: theme.colors.textPrimary,
            subtitleColor: theme.colors.textSecondary,
            alignment: alignment
        )
    }
}

public struct DSHeader<Accessory: View>: View {
    private let title: String
    private let subtitle: String?
    private let config: DSHeaderConfig
    private let state: DSHeaderState
    private let accessory: Accessory

    @Environment(\.dsTheme) private var theme

    public init(
        title: String,
        subtitle: String? = nil,
        config: DSHeaderConfig = DSHeaderConfig(),
        state: DSHeaderState = DSHeaderState(),
        @ViewBuilder accessory: () -> Accessory
    ) {
        self.title = title
        self.subtitle = subtitle
        self.config = config
        self.state = state
        self.accessory = accessory()
    }

    public var body: some View {
        let model = DSHeaderRenderModel.make(state: state, config: config, theme: theme)
        VStack(alignment: model.alignment, spacing: theme.spacing.xs) {
            HStack(alignment: .center) {
                VStack(alignment: model.alignment, spacing: theme.spacing.xs) {
                    Text(title)
                        .font(model.titleFont)
                        .foregroundColor(model.titleColor)

                    if let subtitle {
                        Text(subtitle)
                            .font(model.subtitleFont)
                            .foregroundColor(model.subtitleColor)
                    }
                }
                Spacer(minLength: theme.spacing.sm)
                accessory
            }

            if config.showsDivider {
                Divider()
                    .background(theme.colors.border)
            }

            if state.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(theme.colors.primary)
            }
        }
    }
}

public extension DSHeader where Accessory == EmptyView {
    init(
        title: String,
        subtitle: String? = nil,
        config: DSHeaderConfig = DSHeaderConfig(),
        state: DSHeaderState = DSHeaderState()
    ) {
        self.init(title: title, subtitle: subtitle, config: config, state: state) {
            EmptyView()
        }
    }
}
