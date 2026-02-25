import XCTest
@testable import LeetPulseDesignSystem

final class DSArrowGeometryTests: XCTestCase {
    func testArrowHeadPointsHorizontal() {
        let points = DSArrowGeometry.arrowHeadPoints(
            from: CGPoint(x: 0, y: 0),
            to: CGPoint(x: 10, y: 0),
            headLength: 2,
            headWidth: 4
        )

        XCTAssertEqual(points.tip.x, 10, accuracy: 0.001)
        XCTAssertEqual(points.tip.y, 0, accuracy: 0.001)
        XCTAssertEqual(points.left.x, 8, accuracy: 0.001)
        XCTAssertEqual(points.left.y, 2, accuracy: 0.001)
        XCTAssertEqual(points.right.x, 8, accuracy: 0.001)
        XCTAssertEqual(points.right.y, -2, accuracy: 0.001)
    }

    func testControlPointOffset() {
        let control = DSArrowGeometry.controlPoint(
            start: CGPoint(x: 0, y: 0),
            end: CGPoint(x: 10, y: 0),
            offset: 5
        )

        XCTAssertEqual(control.x, 5, accuracy: 0.001)
        XCTAssertEqual(control.y, 5, accuracy: 0.001)
    }
}
