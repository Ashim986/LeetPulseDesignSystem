import XCTest
@testable import LeetPulseDesignSystemComponents
import LeetPulseDesignSystemCore

final class DSPointerBadgeTests: XCTestCase {
    func testRenderModelRespectsPadding() {
        let config = DSPointerBadgeConfig(horizontalPadding: 10, verticalPadding: 4)
        let model = DSPointerBadgeRenderModel.make(config: config, theme: .light)

        XCTAssertEqual(model.horizontalPadding, 10)
        XCTAssertEqual(model.verticalPadding, 4)
    }
}
