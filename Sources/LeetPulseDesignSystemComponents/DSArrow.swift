import SwiftUI
import LeetPulseDesignSystemCore

public struct DSArrowConfig: Sendable {
    public let color: Color?
    public let lineWidth: CGFloat
    public let headLength: CGFloat
    public let headWidth: CGFloat
    public let showsHead: Bool

    public init(
        color: Color? = nil,
        lineWidth: CGFloat = 1.6,
        headLength: CGFloat = 8,
        headWidth: CGFloat = 6,
        showsHead: Bool = true
    ) {
        self.color = color
        self.lineWidth = lineWidth
        self.headLength = headLength
        self.headWidth = headWidth
        self.showsHead = showsHead
    }
}

public struct DSArrowRenderModel {
    public let color: Color
    public let lineWidth: CGFloat
    public let headLength: CGFloat
    public let headWidth: CGFloat
    public let showsHead: Bool

    public static func make(config: DSArrowConfig, theme: DSTheme) -> DSArrowRenderModel {
        DSArrowRenderModel(
            color: config.color ?? theme.colors.primary,
            lineWidth: config.lineWidth,
            headLength: config.headLength,
            headWidth: config.headWidth,
            showsHead: config.showsHead
        )
    }
}

public struct DSArrow: View {
    private let start: CGPoint
    private let end: CGPoint
    private let config: DSArrowConfig

    @Environment(\.dsTheme) private var theme

    public init(
        start: CGPoint = CGPoint(x: 0, y: 0.5),
        end: CGPoint = CGPoint(x: 1, y: 0.5),
        config: DSArrowConfig = DSArrowConfig()
    ) {
        self.start = start
        self.end = end
        self.config = config
    }

    public var body: some View {
        let model = DSArrowRenderModel.make(config: config, theme: theme)
        GeometryReader { proxy in
            let startPoint = CGPoint(x: start.x * proxy.size.width, y: start.y * proxy.size.height)
            let endPoint = CGPoint(x: end.x * proxy.size.width, y: end.y * proxy.size.height)
            Canvas { context, _ in
                var path = Path()
                path.move(to: startPoint)
                path.addLine(to: endPoint)
                context.stroke(path, with: .color(model.color), lineWidth: model.lineWidth)

                if model.showsHead {
                    let head = DSArrowGeometry.arrowHead(
                        from: startPoint,
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

enum DSArrowGeometry {
    static func arrowHead(
        from: CGPoint,
        to: CGPoint,
        headLength: CGFloat,
        headWidth: CGFloat
    ) -> Path {
        let points = arrowHeadPoints(from: from, to: to, headLength: headLength, headWidth: headWidth)
        var path = Path()
        path.move(to: points.tip)
        path.addLine(to: points.left)
        path.addLine(to: points.right)
        path.closeSubpath()
        return path
    }

    static func arrowHeadPoints(
        from: CGPoint,
        to: CGPoint,
        headLength: CGFloat,
        headWidth: CGFloat
    ) -> (tip: CGPoint, left: CGPoint, right: CGPoint) {
        let dx = to.x - from.x
        let dy = to.y - from.y
        let length = max(sqrt(dx * dx + dy * dy), 0.001)
        let ux = dx / length
        let uy = dy / length
        let base = CGPoint(x: to.x - ux * headLength, y: to.y - uy * headLength)
        let perp = CGPoint(x: -uy, y: ux)
        let halfWidth = headWidth / 2
        let left = CGPoint(x: base.x + perp.x * halfWidth, y: base.y + perp.y * halfWidth)
        let right = CGPoint(x: base.x - perp.x * halfWidth, y: base.y - perp.y * halfWidth)
        return (tip: to, left: left, right: right)
    }

    static func controlPoint(start: CGPoint, end: CGPoint, offset: CGFloat) -> CGPoint {
        let mid = CGPoint(x: (start.x + end.x) / 2, y: (start.y + end.y) / 2)
        let dx = end.x - start.x
        let dy = end.y - start.y
        let length = max(sqrt(dx * dx + dy * dy), 0.001)
        let perp = CGPoint(x: -dy / length, y: dx / length)
        return CGPoint(x: mid.x + perp.x * offset, y: mid.y + perp.y * offset)
    }
}
