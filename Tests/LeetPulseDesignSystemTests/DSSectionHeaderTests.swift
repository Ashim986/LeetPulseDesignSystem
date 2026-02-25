import XCTest
@testable import LeetPulseDesignSystem

final class DSSectionHeaderTests: XCTestCase {
    func testReducerDisablesHeader() {
        var state = DSSectionHeaderState(isEnabled: true)
        var reducer = DSSectionHeaderReducer()

        reducer.reduce(state: &state, event: .setEnabled(false))
        XCTAssertFalse(state.isEnabled)
    }

    func testRenderModelOpacityWhenDisabled() {
        let state = DSSectionHeaderState(isEnabled: false)
        let model = DSSectionHeaderRenderModel.make(state: state, theme: .light)
        XCTAssertLessThan(model.opacity, 1.0)
    }
}
