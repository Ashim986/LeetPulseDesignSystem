import XCTest
@testable import LeetPulseDesignSystemComponents
import LeetPulseDesignSystemCore

final class DSTextFieldTests: XCTestCase {
    func testReducerDisablesFocusWhenDisabled() {
        var state = DSTextFieldState(isEnabled: true, isFocused: true, validation: .none)
        var reducer = DSTextFieldReducer()
        reducer.reduce(state: &state, event: .setEnabled(false))
        XCTAssertFalse(state.isEnabled)
        XCTAssertFalse(state.isFocused)
    }

    func testRenderModelPaddingForLarge() {
        let state = DSTextFieldState()
        let config = DSTextFieldConfig(style: .outlined, size: .large)
        let model = DSTextFieldRenderModel.make(state: state, config: config, theme: .light)

        XCTAssertEqual(model.padding.top, 10)
        XCTAssertEqual(model.padding.leading, 14)
    }

    func testValidationMessageShowsForInvalid() {
        let state = DSTextFieldState(validation: .invalid("Required"))
        let config = DSTextFieldConfig()
        let model = DSTextFieldRenderModel.make(state: state, config: config, theme: .light)

        XCTAssertTrue(model.showsValidationMessage)
        XCTAssertEqual(model.validationMessage, "Required")
    }
}
