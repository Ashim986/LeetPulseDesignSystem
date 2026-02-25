import SwiftUI

public struct DSTreeNode: Identifiable, Hashable, Sendable {
    public let id: String
    public let label: String
    public let left: String?
    public let right: String?

    public init(id: String, label: String, left: String? = nil, right: String? = nil) {
        self.id = id
        self.label = label
        self.left = left
        self.right = right
    }
}

public struct DSTree: Equatable, Sendable {
    public let nodes: [DSTreeNode]
    public let rootId: String?

    public init(nodes: [DSTreeNode], rootId: String?) {
        self.nodes = nodes
        self.rootId = rootId
    }
}

public struct DSTreeGraphConfig: Sendable {
    public let nodeSize: CGFloat
    public let pointerFontSize: CGFloat
    public let pointerHorizontalPadding: CGFloat
    public let pointerVerticalPadding: CGFloat
    public let bubbleStyle: DSBubbleStyle
    public let levelSpacing: CGFloat
    public let pointerSpacing: CGFloat
    public let edgeColor: Color?
    public let nodeFill: Color?
    public let nodeTextColor: Color?

    public init(
        nodeSize: CGFloat = 30,
        pointerFontSize: CGFloat = 8,
        pointerHorizontalPadding: CGFloat = 6,
        pointerVerticalPadding: CGFloat = 2,
        bubbleStyle: DSBubbleStyle = .solid,
        levelSpacing: CGFloat = 50,
        pointerSpacing: CGFloat = 2,
        edgeColor: Color? = nil,
        nodeFill: Color? = nil,
        nodeTextColor: Color? = nil
    ) {
        self.nodeSize = nodeSize
        self.pointerFontSize = pointerFontSize
        self.pointerHorizontalPadding = pointerHorizontalPadding
        self.pointerVerticalPadding = pointerVerticalPadding
        self.bubbleStyle = bubbleStyle
        self.levelSpacing = levelSpacing
        self.pointerSpacing = pointerSpacing
        self.edgeColor = edgeColor
        self.nodeFill = nodeFill
        self.nodeTextColor = nodeTextColor
    }
}

public struct DSTreeGraphView: View {
    private let tree: DSTree
    private let pointers: [DSPointerMarker]
    private let pointerMotions: [DSTreePointerMotion]
    private let highlightedNodeIds: Set<String>
    private let config: DSTreeGraphConfig

    @Environment(\.dsTheme) private var theme

    public init(
        tree: DSTree,
        pointers: [DSPointerMarker] = [],
        pointerMotions: [DSTreePointerMotion] = [],
        highlightedNodeIds: Set<String> = [],
        config: DSTreeGraphConfig = DSTreeGraphConfig()
    ) {
        self.tree = tree
        self.pointers = pointers
        self.pointerMotions = pointerMotions
        self.highlightedNodeIds = highlightedNodeIds
        self.config = config
    }

    public var body: some View {
        GeometryReader { proxy in
            let layout = DSTreeLayout(
                tree: tree,
                size: proxy.size,
                nodeSize: config.nodeSize,
                levelSpacing: config.levelSpacing
            )
            let topPadding = pointerMotions.isEmpty ? 0 : config.nodeSize * 0.8
            let bottomPadding = pointerMotions.count >= 3 ? config.nodeSize * 0.6 : 0
            let yOffset = topPadding
            let pointersById = groupedPointers
            let positions = Dictionary(uniqueKeysWithValues: layout.nodes.map {
                ($0.id, CGPoint(x: $0.position.x, y: $0.position.y + yOffset))
            })

            ZStack {
                Canvas { context, _ in
                    for edge in layout.edges {
                        var path = Path()
                        let from = CGPoint(x: edge.from.x, y: edge.from.y + yOffset)
                        let to = CGPoint(x: edge.to.x, y: edge.to.y + yOffset)
                        path.move(to: from)
                        path.addLine(to: to)
                        context.stroke(
                            path,
                            with: .color(config.edgeColor ?? theme.colors.border.opacity(0.7)),
                            lineWidth: 1
                        )
                    }

                    for (index, motion) in pointerMotions.enumerated() {
                        guard let from = positions[motion.fromId],
                              let to = positions[motion.toId],
                              from != to else { continue }
                        let useBottom = index >= 2
                        let laneIndex = max(0, useBottom ? index - 2 : index)
                        drawPointerMotion(
                            context: &context,
                            from: from,
                            to: to,
                            color: motion.resolvedColor(theme: theme),
                            laneIndex: laneIndex,
                            useBottom: useBottom
                        )
                    }
                }

                ForEach(layout.nodes) { node in
                    ZStack(alignment: .top) {
                        DSBubble(
                            text: node.label,
                            config: DSBubbleConfig(
                                size: config.nodeSize,
                                style: config.bubbleStyle,
                                fill: config.nodeFill ?? theme.colors.secondary.opacity(0.3),
                                textColor: config.nodeTextColor ?? Color.white
                            ),
                            state: DSBubbleState(isHighlighted: highlightedNodeIds.contains(node.id))
                        )

                        if let pointerStack = pointersById[node.id] {
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
                    .position(CGPoint(x: node.position.x, y: node.position.y + yOffset))
                }
            }
            .frame(height: layout.height + topPadding + bottomPadding)
        }
        .frame(minHeight: config.nodeSize + config.levelSpacing)
    }

    private var pointerHeight: CGFloat {
        config.pointerFontSize + config.pointerVerticalPadding * 2 + 4
    }

    private var groupedPointers: [String: [DSPointerMarker]] {
        var grouped: [String: [DSPointerMarker]] = [:]
        for pointer in pointers {
            guard let nodeId = pointer.nodeId else { continue }
            grouped[nodeId, default: []].append(pointer)
        }
        return grouped
    }

    private func drawPointerMotion(
        context: inout GraphicsContext,
        from: CGPoint,
        to: CGPoint,
        color: Color,
        laneIndex: Int,
        useBottom: Bool
    ) {
        let direction: CGFloat = from.x <= to.x ? 1 : -1
        let startYOffset = useBottom ? config.nodeSize * 0.45 : -config.nodeSize * 0.45
        let endYOffset = useBottom ? config.nodeSize * 0.45 : -config.nodeSize * 0.45
        let start = CGPoint(x: from.x + direction * config.nodeSize * 0.35, y: from.y + startYOffset)
        let end = CGPoint(x: to.x - direction * config.nodeSize * 0.35, y: to.y + endYOffset)
        let span = abs(end.x - start.x)
        let baseLift = min(56, max(16, span * 0.25))
        let lift = baseLift + CGFloat(laneIndex) * 12
        let controlY = useBottom
            ? max(start.y, end.y) + lift
            : min(start.y, end.y) - lift
        let control = CGPoint(x: (start.x + end.x) / 2, y: controlY)
        var path = Path()
        path.move(to: start)
        path.addQuadCurve(to: end, control: control)
        context.stroke(path, with: .color(color.opacity(0.85)), lineWidth: 1.6)
        let head = DSArrowGeometry.arrowHead(from: control, to: end, headLength: 6, headWidth: 4)
        context.fill(head, with: .color(color.opacity(0.95)))
    }
}

struct DSTreeLayout {
    struct Node: Identifiable {
        let id: String
        let label: String
        let position: CGPoint
    }

    struct Edge: Identifiable {
        let id = UUID()
        let from: CGPoint
        let to: CGPoint
    }

    private struct QueueEntry {
        let id: String
        let level: Int
        let heapIndex: Int
    }

    let nodes: [Node]
    let edges: [Edge]
    let height: CGFloat

    init(tree: DSTree, size: CGSize, nodeSize: CGFloat, levelSpacing: CGFloat) {
        guard let rootId = tree.rootId else {
            self.nodes = []
            self.edges = []
            self.height = nodeSize
            return
        }

        var nodeMap: [String: DSTreeNode] = [:]
        tree.nodes.forEach { nodeMap[$0.id] = $0 }

        var nodes: [Node] = []
        var positions: [String: CGPoint] = [:]
        var edges: [Edge] = []
        var maxLevel = 0
        var queue: [QueueEntry] = [QueueEntry(id: rootId, level: 0, heapIndex: 1)]
        var visited = Set<String>()

        while !queue.isEmpty {
            let entry = queue.removeFirst()
            guard let node = nodeMap[entry.id], !visited.contains(entry.id) else { continue }
            visited.insert(entry.id)
            maxLevel = max(maxLevel, entry.level)
            let countAtLevel = 1 << entry.level
            let indexInLevel = entry.heapIndex - (1 << entry.level)
            let x = CGFloat(indexInLevel + 1) * size.width / CGFloat(countAtLevel + 1)
            let y = CGFloat(entry.level) * levelSpacing + nodeSize / 2
            let position = CGPoint(x: x, y: y)
            nodes.append(Node(id: node.id, label: node.label, position: position))
            positions[node.id] = position

            if let leftId = node.left {
                queue.append(QueueEntry(id: leftId, level: entry.level + 1, heapIndex: entry.heapIndex * 2))
            }
            if let rightId = node.right {
                queue.append(QueueEntry(id: rightId, level: entry.level + 1, heapIndex: entry.heapIndex * 2 + 1))
            }
        }

        for node in tree.nodes {
            guard let parentPosition = positions[node.id] else { continue }
            if let leftId = node.left, let leftPosition = positions[leftId] {
                edges.append(
                    Edge(
                        from: CGPoint(x: parentPosition.x, y: parentPosition.y + nodeSize / 2),
                        to: CGPoint(x: leftPosition.x, y: leftPosition.y - nodeSize / 2)
                    )
                )
            }
            if let rightId = node.right, let rightPosition = positions[rightId] {
                edges.append(
                    Edge(
                        from: CGPoint(x: parentPosition.x, y: parentPosition.y + nodeSize / 2),
                        to: CGPoint(x: rightPosition.x, y: rightPosition.y - nodeSize / 2)
                    )
                )
            }
        }

        self.nodes = nodes
        self.edges = edges
        self.height = CGFloat(maxLevel + 1) * levelSpacing + nodeSize
    }
}
