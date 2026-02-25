import XCTest
@testable import LeetPulseDesignSystem

final class DSTabBarTests: XCTestCase {
    func testReducerSelectsWhenEnabled() {
        var state = DSTabBarState(selectedId: "home", isEnabled: true)
        var reducer = DSTabBarReducer()
        reducer.reduce(state: &state, event: .select("stats"))
        XCTAssertEqual(state.selectedId, "stats")

        reducer.reduce(state: &state, event: .setEnabled(false))
        reducer.reduce(state: &state, event: .select("focus"))
        XCTAssertEqual(state.selectedId, "stats")
    }

    func testRenderModelOpacityWhenDisabled() {
        let state = DSTabBarState(selectedId: "home", isEnabled: false)
        let model = DSTabBarRenderModel.make(state: state, theme: .light)
        XCTAssertLessThan(model.opacity, 1.0)
    }
}
