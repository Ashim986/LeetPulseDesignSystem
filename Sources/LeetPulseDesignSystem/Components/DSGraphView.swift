import SwiftUI

public struct DSGraphConfig: Sendable {
    public let nodeSize: CGFloat
    public let pointerFontSize: CGFloat
    public let pointerHorizontalPadding: CGFloat
    public let pointerVerticalPadding: CGFloat
    public let pointerSpacing: CGFloat
    public let bubbleStyle: DSBubbleStyle
    public let edgeColor: Color?
    public let nodeFill: Color?
    public let nodeTextColor: Color?

    public init(
        nodeSize: CGFloat = 30,
        pointerFontSize: CGFloat = 8,
        pointerHorizontalPadding: CGFloat = 6,
        pointerVerticalPadding: CGFloat = 2,
        pointerSpacing: CGFloat = 2,
        bubbleStyle: DSBubbleStyle = .solid,
        edgeColor: Color? = nil,
        nodeFill: Color? = nil,
        nodeTextColor: Color? = nil
    ) {
        self.nodeSize = nodeSize
        self.pointerFontSize = pointerFontSize
        self.pointerHorizontalPadding = pointerHorizontalPadding
        self.pointerVerticalPadding = pointerVerticalPadding
        self.pointerSpacing = pointerSpacing
        self.bubbleStyle = bubbleStyle
        self.edgeColor = edgeColor
        self.nodeFill = nodeFill
        self.nodeTextColor = nodeTextColor
    }
}

public struct DSGraphView: View {
    private let adjacency: [[Int]]
    private let nodeLabels: [String]?
    private let pointers: [DSPointerMarker]
    private let config: DSGraphConfig

    @Environment(\.dsTheme) private var theme

    public init(
        adjacency: [[Int]],
        nodeLabels: [String]? = nil,
        pointers: [DSPointerMarker] = [],
        config: DSGraphConfig = DSGraphConfig()
    ) {
        self.adjacency = adjacency
        self.nodeLabels = nodeLabels
        self.pointers = pointers
        self.config = config
    }

    public var body: some View {
        GeometryReader { proxy in
            let layout = DSGraphLayout(adjacency: adjacency, size: proxy.size, nodeSize: config.nodeSize)
            let pointersByIndex = groupedPointers
            ZStack {
                Canvas { context, _ in
                    for edge in layout.edges {
                        var path = Path()
                        path.move(to: edge.from)
                        path.addLine(to: edge.to)
                        context.stroke(
                            path,
                            with: .color(config.edgeColor ?? theme.colors.border.opacity(0.7)),
                            lineWidth: 1
                        )
                        if edge.directed {
                            let head = DSArrowGeometry.arrowHead(
                                from: edge.from,
                                to: edge.to,
                                headLength: 8,
                                headWidth: 6
                            )
                            context.fill(head, with: .color(theme.colors.textSecondary.opacity(0.7)))
                        }
                    }
                }

                ForEach(layout.nodes) { node in
                    ZStack(alignment: .top) {
                        DSBubble(
                            text: label(for: node.index),
                            config: DSBubbleConfig(
                                size: config.nodeSize,
                                style: config.bubbleStyle,
                                fill: config.nodeFill ?? theme.colors.secondary.opacity(0.3),
                                textColor: config.nodeTextColor ?? Color.white
                            )
                        )

                        if let pointerStack = pointersByIndex[node.index] {
                            let stackHeight = CGFloat(pointerStack.count) * pointerHeight +
                                CGFloat(max(pointerStack.count - 1, 0)) * config.pointerSpacing
                            VStack(spacing: config.pointerSpacing) {
                                ForEach(pointerStack) { pointer in
                                    DSPointerBadge(
                                        text: pointer.name,
                                        config: DSPointerBadgeConfig(
                                            font: .system(size: config.pointerFontSize, weight: .semibold),
                                            backgroundColor: pointer.resolvedColor(theme: theme)
                                        )
                                    )
                                }
                            }
                            .offset(y: -(config.nodeSize / 2 + stackHeight))
                        }
                    }
                    .position(node.position)
                }
            }
            .frame(height: layout.height)
        }
        .frame(height: graphHeight)
    }

    private var pointerHeight: CGFloat {
        config.pointerFontSize + config.pointerVerticalPadding * 2 + 4
    }

    private var graphHeight: CGFloat {
        let base = CGFloat(adjacency.count) * 14
        return max(180, min(260, base))
    }

    private var groupedPointers: [Int: [DSPointerMarker]] {
        var grouped: [Int: [DSPointerMarker]] = [:]
        for pointer in pointers {
            guard let index = pointer.index else { continue }
            grouped[index, default: []].append(pointer)
        }
        return grouped
    }

    private func label(for index: Int) -> String {
        if let labels = nodeLabels, index < labels.count {
            return labels[index]
        }
        return "\(index)"
    }
}

struct DSGraphLayout {
    struct Node: Identifiable {
        let id = UUID()
        let index: Int
        let position: CGPoint
    }

    struct Edge: Identifiable {
        let id = UUID()
        let from: CGPoint
        let to: CGPoint
        let directed: Bool
    }

    let nodes: [Node]
    let edges: [Edge]
    let height: CGFloat

    init(adjacency: [[Int]], size: CGSize, nodeSize: CGFloat) {
        let count = adjacency.count
        let safeWidth = max(size.width, nodeSize * 4)
        let safeHeight = max(size.height, nodeSize * 4)

        let adjacencySets: [Set<Int>] = adjacency.map { Set($0) }
        let isUndirected = DSGraphLayout.isGraphUndirected(adjacency: adjacencySets)

        let positions: [CGPoint]
        if count <= 6 {
            positions = DSGraphLayout.circularLayout(
                count: count,
                center: CGPoint(x: safeWidth / 2, y: safeHeight / 2),
                radius: max(10, min(safeWidth, safeHeight) * 0.5 - nodeSize)
            )
        } else {
            positions = DSGraphLayout.forceDirectedLayout(
                adjacency: adjacency,
                width: safeWidth,
                height: safeHeight,
                nodeSize: nodeSize
            )
        }

        var nodes: [Node] = []
        for index in 0..<count {
            nodes.append(Node(index: index, position: positions[index]))
        }

        var edges: [Edge] = []
        for index in 0..<count {
            for neighbor in adjacency[index] {
                guard neighbor >= 0, neighbor < count else { continue }
                if isUndirected && neighbor < index { continue }
                edges.append(Edge(
                    from: positions[index],
                    to: positions[neighbor],
                    directed: !isUndirected
                ))
            }
        }

        self.nodes = nodes
        self.edges = edges
        self.height = safeHeight
    }

    static func circularLayout(
        count: Int,
        center: CGPoint,
        radius: CGFloat
    ) -> [CGPoint] {
        (0..<count).map { index in
            let angle = (Double(index) / Double(max(count, 1))) * (2 * .pi) - .pi / 2
            return CGPoint(
                x: center.x + CGFloat(cos(angle)) * radius,
                y: center.y + CGFloat(sin(angle)) * radius
            )
        }
    }

    static func forceDirectedLayout(
        adjacency: [[Int]],
        width: CGFloat,
        height: CGFloat,
        nodeSize: CGFloat,
        iterations: Int = 50
    ) -> [CGPoint] {
        let count = adjacency.count
        guard count > 0 else { return [] }

        let area = width * height
        let optimalDistance = sqrt(area / CGFloat(count)) * 0.8
        let margin = nodeSize

        var positions = circularLayout(
            count: count,
            center: CGPoint(x: width / 2, y: height / 2),
            radius: min(width, height) * 0.35
        )

        var temperature = width / 4

        for _ in 0..<iterations {
            var displacements = Array(repeating: CGPoint.zero, count: count)

            for nodeIndex in 0..<count {
                for otherIndex in (nodeIndex + 1)..<count {
                    let dx = positions[nodeIndex].x - positions[otherIndex].x
                    let dy = positions[nodeIndex].y - positions[otherIndex].y
                    let dist = max(sqrt(dx * dx + dy * dy), 0.01)
                    let force = (optimalDistance * optimalDistance) / dist
                    let fx = (dx / dist) * force
                    let fy = (dy / dist) * force
                    displacements[nodeIndex].x += fx
                    displacements[nodeIndex].y += fy
                    displacements[otherIndex].x -= fx
                    displacements[otherIndex].y -= fy
                }
            }

            for nodeIndex in 0..<count {
                for neighborIndex in adjacency[nodeIndex] {
                    guard neighborIndex >= 0, neighborIndex < count, neighborIndex > nodeIndex else { continue }
                    let dx = positions[nodeIndex].x - positions[neighborIndex].x
                    let dy = positions[nodeIndex].y - positions[neighborIndex].y
                    let dist = max(sqrt(dx * dx + dy * dy), 0.01)
                    let force = (dist * dist) / optimalDistance
                    let fx = (dx / dist) * force
                    let fy = (dy / dist) * force
                    displacements[nodeIndex].x -= fx
                    displacements[nodeIndex].y -= fy
                    displacements[neighborIndex].x += fx
                    displacements[neighborIndex].y += fy
                }
            }

            for nodeIndex in 0..<count {
                let dx = displacements[nodeIndex].x
                let dy = displacements[nodeIndex].y
                let dist = max(sqrt(dx * dx + dy * dy), 0.01)
                let limitedDist = min(dist, temperature)
                positions[nodeIndex].x += (dx / dist) * limitedDist
                positions[nodeIndex].y += (dy / dist) * limitedDist
                positions[nodeIndex].x = max(margin, min(width - margin, positions[nodeIndex].x))
                positions[nodeIndex].y = max(margin, min(height - margin, positions[nodeIndex].y))
            }

            temperature *= 0.9
        }

        return positions
    }

    static func isGraphUndirected(adjacency: [Set<Int>]) -> Bool {
        for (index, neighbors) in adjacency.enumerated() {
            for neighbor in neighbors {
                guard neighbor >= 0, neighbor < adjacency.count else { continue }
                if !adjacency[neighbor].contains(index) {
                    return false
                }
            }
        }
        return true
    }
}
