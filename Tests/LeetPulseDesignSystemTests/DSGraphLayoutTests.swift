import XCTest
@testable import LeetPulseDesignSystem

final class DSGraphLayoutTests: XCTestCase {
    func testUndirectedGraphEdgesCollapse() {
        let adjacency = [[1], [0]]
        let layout = DSGraphLayout(adjacency: adjacency, size: CGSize(width: 200, height: 200), nodeSize: 30)

        XCTAssertEqual(layout.nodes.count, 2)
        XCTAssertEqual(layout.edges.count, 1)
        XCTAssertFalse(layout.edges.first?.directed ?? true)
    }

    func testDirectedGraphEdges() {
        let adjacency = [[1], []]
        let layout = DSGraphLayout(adjacency: adjacency, size: CGSize(width: 200, height: 200), nodeSize: 30)

        XCTAssertEqual(layout.edges.count, 1)
        XCTAssertTrue(layout.edges.first?.directed ?? false)
    }
}
