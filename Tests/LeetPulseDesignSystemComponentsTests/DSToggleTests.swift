import XCTest
@testable import LeetPulseDesignSystemComponents
import LeetPulseDesignSystemCore

final class DSToggleTests: XCTestCase {
    func testReducerTogglesOnlyWhenEnabled() {
        var state = DSToggleState(isOn: false, isEnabled: true)
        var reducer = DSToggleReducer()
        reducer.reduce(state: &state, event: .toggle)
        XCTAssertTrue(state.isOn)

        reducer.reduce(state: &state, event: .setEnabled(false))
        reducer.reduce(state: &state, event: .toggle)
        XCTAssertTrue(state.isOn)
    }

    func testRenderModelOpacityWhenDisabled() {
        let state = DSToggleState(isOn: false, isEnabled: false)
        let config = DSToggleConfig(size: 20)
        let model = DSToggleRenderModel.make(state: state, config: config, theme: .light)

        XCTAssertLessThan(model.opacity, 1.0)
    }
}
