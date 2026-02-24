import XCTest
@testable import LeetPulseDesignSystemComponents
import LeetPulseDesignSystemCore

final class DSToastTests: XCTestCase {
    func testReducerUpdatesVisibility() {
        var state = DSToastState(isVisible: false, isEnabled: true)
        var reducer = DSToastReducer()

        reducer.reduce(state: &state, event: .setVisible(true))
        XCTAssertTrue(state.isVisible)
    }

    func testRenderModelIconForError() {
        let state = DSToastState(isVisible: true)
        let config = DSToastConfig(style: .error)
        let model = DSToastRenderModel.make(state: state, config: config, theme: .light)
        XCTAssertEqual(model.iconName, "xmark.octagon")
    }

    func testRenderModelOpacityWhenDisabled() {
        let state = DSToastState(isVisible: true, isEnabled: false)
        let model = DSToastRenderModel.make(state: state, config: DSToastConfig(), theme: .light)
        XCTAssertLessThan(model.opacity, 1.0)
    }
}
