import XCTest
@testable import LeetPulseDesignSystemComponents
import LeetPulseDesignSystemCore

final class DSCardTests: XCTestCase {
    func testRenderModelOpacityWhenDisabled() {
        let state = DSCardState(isHighlighted: false, isDisabled: true)
        let config = DSCardConfig(style: .surface)
        let model = DSCardRenderModel.make(state: state, config: config, theme: .light)

        XCTAssertLessThan(model.opacity, 1.0)
    }

    func testRenderModelCornerRadiusUsesThemeByDefault() {
        let state = DSCardState()
        let config = DSCardConfig(style: .outlined)
        let model = DSCardRenderModel.make(state: state, config: config, theme: .light)

        XCTAssertEqual(model.cornerRadius, DSTheme.light.radii.lg)
    }
}
