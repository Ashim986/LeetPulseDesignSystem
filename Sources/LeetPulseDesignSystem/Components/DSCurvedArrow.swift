import SwiftUI

public struct DSCurvedArrowConfig: Sendable {
    public let color: Color?
    public let lineWidth: CGFloat
    public let headLength: CGFloat
    public let headWidth: CGFloat
    public let curveOffset: CGFloat
    public let showsHead: Bool

    public init(
        color: Color? = nil,
        lineWidth: CGFloat = 1.6,
        headLength: CGFloat = 8,
        headWidth: CGFloat = 6,
        curveOffset: CGFloat = 20,
        showsHead: Bool = true
    ) {
        self.color = color
        self.lineWidth = lineWidth
        self.headLength = headLength
        self.headWidth = headWidth
        self.curveOffset = curveOffset
        self.showsHead = showsHead
    }
}

public struct DSCurvedArrowRenderModel {
    public let color: Color
    public let lineWidth: CGFloat
    public let headLength: CGFloat
    public let headWidth: CGFloat
    public let curveOffset: CGFloat
    public let showsHead: Bool

    public static func make(config: DSCurvedArrowConfig, theme: DSTheme) -> DSCurvedArrowRenderModel {
        DSCurvedArrowRenderModel(
            color: config.color ?? theme.colors.primary,
            lineWidth: config.lineWidth,
            headLength: config.headLength,
            headWidth: config.headWidth,
            curveOffset: config.curveOffset,
            showsHead: config.showsHead
        )
    }
}

public struct DSCurvedArrow: View {
    private let start: CGPoint
    private let end: CGPoint
    private let config: DSCurvedArrowConfig

    @Environment(\.dsTheme) private var theme

    public init(
        start: CGPoint = CGPoint(x: 0, y: 0.5),
        end: CGPoint = CGPoint(x: 1, y: 0.5),
        config: DSCurvedArrowConfig = DSCurvedArrowConfig()
    ) {
        self.start = start
        self.end = end
        self.config = config
    }

    public var body: some View {
        let model = DSCurvedArrowRenderModel.make(config: config, theme: theme)
        GeometryReader { proxy in
            let startPoint = CGPoint(x: start.x * proxy.size.width, y: start.y * proxy.size.height)
            let endPoint = CGPoint(x: end.x * proxy.size.width, y: end.y * proxy.size.height)
            let controlPoint = DSArrowGeometry.controlPoint(
                start: startPoint,
                end: endPoint,
                offset: model.curveOffset
            )
            Canvas { context, _ in
                var path = Path()
                path.move(to: startPoint)
                path.addQuadCurve(to: endPoint, control: controlPoint)
                context.stroke(path, with: .color(model.color), lineWidth: model.lineWidth)

                if model.showsHead {
                    let head = DSArrowGeometry.arrowHead(
                        from: controlPoint,
                        to: endPoint,
                        headLength: model.headLength,
                        headWidth: model.headWidth
                    )
                    context.fill(head, with: .color(model.color))
                }
            }
        }
    }
}
