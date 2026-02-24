import XCTest
@testable import LeetPulseDesignSystemComponents
import LeetPulseDesignSystemCore

final class DSSelectTests: XCTestCase {
    func testReducerSelectsWhenEnabled() {
        var state = DSSelectState(selectedId: "a", isEnabled: true)
        var reducer = DSSelectReducer()

        reducer.reduce(state: &state, event: .select("b"))
        XCTAssertEqual(state.selectedId, "b")

        reducer.reduce(state: &state, event: .setEnabled(false))
        reducer.reduce(state: &state, event: .select("c"))
        XCTAssertEqual(state.selectedId, "b")
    }

    func testRenderModelOpacityWhenDisabled() {
        let state = DSSelectState(selectedId: nil, isEnabled: false)
        let model = DSSelectRenderModel.make(state: state, config: DSSelectConfig(), theme: .light)
        XCTAssertLessThan(model.opacity, 1.0)
    }
}
