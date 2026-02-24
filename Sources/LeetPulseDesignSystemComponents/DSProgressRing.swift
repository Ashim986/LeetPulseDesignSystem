import SwiftUI
import LeetPulseDesignSystemCore
import LeetPulseDesignSystemState

public enum DSProgressRingStyle: String, Sendable {
    case primary
    case secondary
}

public struct DSProgressRingConfig: Sendable {
    public let size: CGFloat
    public let lineWidth: CGFloat
    public let style: DSProgressRingStyle
    public let showsTrack: Bool

    public init(size: CGFloat = 44, lineWidth: CGFloat = 4, style: DSProgressRingStyle = .primary, showsTrack: Bool = true) {
        self.size = size
        self.lineWidth = lineWidth
        self.style = style
        self.showsTrack = showsTrack
    }
}

public struct DSProgressRingState: Equatable, Sendable {
    public var progress: Double?

    public init(progress: Double? = nil) {
        self.progress = progress
    }
}

public enum DSProgressRingEvent: Sendable {
    case setProgress(Double?)
}

public struct DSProgressRingReducer: ReducerProtocol {
    public init() {}

    public mutating func reduce(state: inout DSProgressRingState, event: DSProgressRingEvent) {
        switch event {
        case .setProgress(let value):
            state.progress = value
        }
    }
}

public struct DSProgressRingRenderModel {
    public let progress: Double?
    public let stroke: Color
    public let track: Color
    public let size: CGFloat
    public let lineWidth: CGFloat

    public static func make(state: DSProgressRingState, config: DSProgressRingConfig, theme: DSTheme) -> DSProgressRingRenderModel {
        let progress = state.progress.map { min(max($0, 0), 1) }
        let stroke: Color = config.style == .primary ? theme.colors.primary : theme.colors.accent
        let track = theme.colors.border

        return DSProgressRingRenderModel(
            progress: progress,
            stroke: stroke,
            track: track,
            size: config.size,
            lineWidth: config.lineWidth
        )
    }
}

public struct DSProgressRing: View {
    private let config: DSProgressRingConfig
    private let state: DSProgressRingState

    @Environment(\.dsTheme) private var theme

    public init(config: DSProgressRingConfig = DSProgressRingConfig(), state: DSProgressRingState = DSProgressRingState()) {
        self.config = config
        self.state = state
    }

    public var body: some View {
        let model = DSProgressRingRenderModel.make(state: state, config: config, theme: theme)
        ZStack {
            if config.showsTrack {
                Circle()
                    .stroke(model.track, lineWidth: model.lineWidth)
            }

            if let progress = model.progress {
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        model.stroke,
                        style: StrokeStyle(lineWidth: model.lineWidth, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
            } else {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(model.stroke)
            }
        }
        .frame(width: model.size, height: model.size)
    }
}
