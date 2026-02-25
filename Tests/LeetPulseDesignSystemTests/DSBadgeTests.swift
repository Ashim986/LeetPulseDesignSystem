import XCTest
@testable import LeetPulseDesignSystem

final class DSBadgeTests: XCTestCase {
    func testBadgeUsesPillRadius() {
        let state = DSBadgeState()
        let config = DSBadgeConfig(style: .info)
        let model = DSBadgeRenderModel.make(state: state, config: config, theme: .light)

        XCTAssertEqual(model.cornerRadius, DSTheme.light.radii.pill)
    }
}
