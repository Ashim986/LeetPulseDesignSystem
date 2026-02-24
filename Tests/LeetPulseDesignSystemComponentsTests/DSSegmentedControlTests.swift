import XCTest
@testable import LeetPulseDesignSystemComponents
import LeetPulseDesignSystemCore

final class DSSegmentedControlTests: XCTestCase {
    func testReducerSelectsWhenEnabled() {
        var state = DSSegmentedControlState(selectedId: "a", isEnabled: true)
        var reducer = DSSegmentedControlReducer()
        reducer.reduce(state: &state, event: .select("b"))
        XCTAssertEqual(state.selectedId, "b")

        reducer.reduce(state: &state, event: .setEnabled(false))
        reducer.reduce(state: &state, event: .select("c"))
        XCTAssertEqual(state.selectedId, "b")
    }

    func testRenderModelOpacityWhenDisabled() {
        let state = DSSegmentedControlState(selectedId: "a", isEnabled: false)
        let model = DSSegmentedRenderModel.make(state: state, theme: .light)
        XCTAssertLessThan(model.opacity, 1.0)
    }
}
