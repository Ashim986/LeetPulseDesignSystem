import SwiftUI
import LeetPulseDesignSystemCore
import LeetPulseDesignSystemState

public enum DSMetricTrend: String, Sendable {
    case positive
    case negative
    case neutral
}

public enum DSMetricCardStyle: String, Sendable {
    case neutral
    case accent
    case success
    case warning
    case danger
}

public struct DSMetricCardConfig: Sendable {
    public let style: DSMetricCardStyle
    public let showsTrendIcon: Bool
    public let padding: CGFloat
    public let cornerRadius: CGFloat?

    public init(
        style: DSMetricCardStyle = .neutral,
        showsTrendIcon: Bool = true,
        padding: CGFloat = 16,
        cornerRadius: CGFloat? = nil
    ) {
        self.style = style
        self.showsTrendIcon = showsTrendIcon
        self.padding = padding
        self.cornerRadius = cornerRadius
    }
}

public struct DSMetricCardState: Equatable, Sendable {
    public var isLoading: Bool
    public var isEnabled: Bool

    public init(isLoading: Bool = false, isEnabled: Bool = true) {
        self.isLoading = isLoading
        self.isEnabled = isEnabled
    }
}

public enum DSMetricCardEvent: Sendable {
    case setLoading(Bool)
    case setEnabled(Bool)
}

public struct DSMetricCardReducer: ReducerProtocol {
    public init() {}

    public mutating func reduce(state: inout DSMetricCardState, event: DSMetricCardEvent) {
        switch event {
        case .setLoading(let value):
            state.isLoading = value
        case .setEnabled(let value):
            state.isEnabled = value
        }
    }
}

public struct DSMetricCardRenderModel {
    public let background: Color
    public let border: Color
    public let titleFont: Font
    public let valueFont: Font
    public let detailFont: Font
    public let titleColor: Color
    public let valueColor: Color
    public let detailColor: Color
    public let trendColor: Color
    public let trendIconName: String?
    public let cornerRadius: CGFloat
    public let opacity: Double

    public static func make(
        state: DSMetricCardState,
        config: DSMetricCardConfig,
        trend: DSMetricTrend?,
        theme: DSTheme
    ) -> DSMetricCardRenderModel {
        let accentColor: Color = {
            switch config.style {
            case .neutral, .accent:
                return theme.colors.primary
            case .success:
                return theme.colors.success
            case .warning:
                return theme.colors.warning
            case .danger:
                return theme.colors.danger
            }
        }()

        let background: Color = {
            switch config.style {
            case .neutral:
                return theme.colors.surfaceElevated
            case .accent:
                return theme.colors.primary.opacity(0.12)
            case .success:
                return theme.colors.success.opacity(0.12)
            case .warning:
                return theme.colors.warning.opacity(0.12)
            case .danger:
                return theme.colors.danger.opacity(0.12)
            }
        }()

        let trendIconName: String? = {
            guard config.showsTrendIcon, let trend else { return nil }
            switch trend {
            case .positive:
                return "arrow.up.right"
            case .negative:
                return "arrow.down.right"
            case .neutral:
                return "minus"
            }
        }()

        let trendColor: Color = {
            guard let trend else { return theme.colors.textSecondary }
            switch trend {
            case .positive:
                return theme.colors.success
            case .negative:
                return theme.colors.danger
            case .neutral:
                return theme.colors.textSecondary
            }
        }()

        return DSMetricCardRenderModel(
            background: background,
            border: theme.colors.border,
            titleFont: theme.typography.caption,
            valueFont: theme.typography.subtitle,
            detailFont: theme.typography.body,
            titleColor: theme.colors.textSecondary,
            valueColor: config.style == .neutral ? theme.colors.textPrimary : accentColor,
            detailColor: theme.colors.textSecondary,
            trendColor: trendColor,
            trendIconName: trendIconName,
            cornerRadius: config.cornerRadius ?? theme.radii.lg,
            opacity: state.isEnabled ? 1.0 : 0.6
        )
    }
}

public struct DSMetricCard: View {
    private let title: String
    private let value: String
    private let detail: String?
    private let trend: DSMetricTrend?
    private let trendLabel: String?
    private let icon: Image?
    private let config: DSMetricCardConfig
    private let state: DSMetricCardState

    @Environment(\.dsTheme) private var theme

    public init(
        title: String,
        value: String,
        detail: String? = nil,
        trend: DSMetricTrend? = nil,
        trendLabel: String? = nil,
        icon: Image? = nil,
        config: DSMetricCardConfig = DSMetricCardConfig(),
        state: DSMetricCardState = DSMetricCardState()
    ) {
        self.title = title
        self.value = value
        self.detail = detail
        self.trend = trend
        self.trendLabel = trendLabel
        self.icon = icon
        self.config = config
        self.state = state
    }

    public var body: some View {
        let model = DSMetricCardRenderModel.make(state: state, config: config, trend: trend, theme: theme)

        VStack(alignment: .leading, spacing: theme.spacing.sm) {
            HStack(spacing: theme.spacing.sm) {
                if let icon {
                    icon
                        .foregroundColor(model.valueColor)
                }

                Text(title)
                    .font(model.titleFont)
                    .foregroundColor(model.titleColor)

                Spacer(minLength: theme.spacing.sm)

                if let trendIconName = model.trendIconName {
                    Image(systemName: trendIconName)
                        .foregroundColor(model.trendColor)
                }

                if let trendLabel {
                    Text(trendLabel)
                        .font(theme.typography.caption)
                        .foregroundColor(model.trendColor)
                }
            }

            if state.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(model.valueColor)
            } else {
                Text(value)
                    .font(model.valueFont)
                    .foregroundColor(model.valueColor)
            }

            if let detail {
                Text(detail)
                    .font(model.detailFont)
                    .foregroundColor(model.detailColor)
            }
        }
        .padding(config.padding)
        .background(model.background)
        .overlay(
            RoundedRectangle(cornerRadius: model.cornerRadius)
                .stroke(model.border, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: model.cornerRadius))
        .opacity(model.opacity)
    }
}
