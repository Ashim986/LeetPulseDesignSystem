import SwiftUI
import LeetPulseDesignSystem

struct DSPrimitivesDemoView: View {
    var body: some View {
        DSThemeProvider(theme: .dark) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    DSSectionHeader(title: "Primitives", config: .init(showsDivider: true))

                    HStack(spacing: 12) {
                        DSBubble(
                            text: "42",
                            config: .init(size: 32),
                            state: .init(isHighlighted: true, changeType: .modified)
                        )
                        DSBubble(
                            text: "ok",
                            config: .init(size: 32, fill: .green.opacity(0.3)),
                            state: .init(changeType: .added)
                        )
                        DSPointerBadge(text: "ptr", config: .init(backgroundColor: .blue))
                    }

                    DSCard {
                        VStack(alignment: .leading, spacing: 12) {
                            DSHeader(title: "Arrows", subtitle: "Straight + Curved")
                            DSArrow()
                                .frame(height: 20)
                            DSCurvedArrow(config: .init(curveOffset: 18))
                                .frame(height: 32)
                        }
                    }

                    DSCard {
                        VStack(alignment: .leading, spacing: 12) {
                            DSHeader(title: "Graph")
                            DSGraphView(
                                adjacency: [[1], [0, 2], [1]],
                                nodeLabels: ["A", "B", "C"],
                                pointers: [DSPointerMarker(name: "p", index: 1)]
                            )
                        }
                    }

                    DSCard {
                        VStack(alignment: .leading, spacing: 12) {
                            DSHeader(title: "Tree")
                            DSTreeGraphView(
                                tree: DSTree(
                                    nodes: [
                                        DSTreeNode(id: "root", label: "A", left: "l", right: "r"),
                                        DSTreeNode(id: "l", label: "B"),
                                        DSTreeNode(id: "r", label: "C")
                                    ],
                                    rootId: "root"
                                ),
                                pointers: [DSPointerMarker(name: "root", nodeId: "root")]
                            )
                        }
                    }
                }
                .padding(16)
            }
        }
    }
}
