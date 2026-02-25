import XCTest
@testable import LeetPulseDesignSystem

final class DSButtonTests: XCTestCase {
    func testReducerDisablesWhenLoading() {
        var state = DSButtonState(isEnabled: true, isLoading: false)
        var reducer = DSButtonReducer()

        reducer.reduce(state: &state, event: .setLoading(true))
        XCTAssertTrue(state.isLoading)
        XCTAssertFalse(state.isEnabled)
    }

    func testRenderModelReflectsLoading() {
        let state = DSButtonState(isEnabled: true, isLoading: true)
        let config = DSButtonConfig(style: .primary, size: .small)
        let model = DSButtonRenderModel.make(state: state, config: config, theme: .light)

        XCTAssertTrue(model.showsSpinner)
        XCTAssertLessThan(model.opacity, 1.0)
    }

    func testRenderModelPaddingForLarge() {
        let state = DSButtonState(isEnabled: true, isLoading: false)
        let config = DSButtonConfig(style: .secondary, size: .large)
        let model = DSButtonRenderModel.make(state: state, config: config, theme: .light)

        XCTAssertEqual(model.padding.top, 12)
        XCTAssertEqual(model.padding.leading, 24)
        XCTAssertEqual(model.padding.trailing, 24)
    }
}
