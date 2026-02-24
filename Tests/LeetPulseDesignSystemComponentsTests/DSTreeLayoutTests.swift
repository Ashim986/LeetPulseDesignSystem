import XCTest
@testable import LeetPulseDesignSystemComponents

final class DSTreeLayoutTests: XCTestCase {
    func testLayoutCreatesEdges() {
        let nodes = [
            DSTreeNode(id: "root", label: "A", left: "left", right: nil),
            DSTreeNode(id: "left", label: "B", left: nil, right: nil)
        ]
        let tree = DSTree(nodes: nodes, rootId: "root")
        let layout = DSTreeLayout(tree: tree, size: CGSize(width: 200, height: 200), nodeSize: 30, levelSpacing: 50)

        XCTAssertEqual(layout.nodes.count, 2)
        XCTAssertEqual(layout.edges.count, 1)
    }
}
