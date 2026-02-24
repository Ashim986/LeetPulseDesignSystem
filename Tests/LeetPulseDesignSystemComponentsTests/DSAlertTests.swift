import XCTest
@testable import LeetPulseDesignSystemComponents
import LeetPulseDesignSystemCore

final class DSAlertTests: XCTestCase {
    func testReducerUpdatesProcessing() {
        var state = DSAlertState(isPresented: true, isProcessing: false, isEnabled: true)
        var reducer = DSAlertReducer()

        reducer.reduce(state: &state, event: .setProcessing(true))
        XCTAssertTrue(state.isProcessing)
    }

    func testRenderModelUsesDestructivePrimaryForError() {
        let state = DSAlertState(isPresented: true)
        let config = DSAlertConfig(style: .error)
        let model = DSAlertRenderModel.make(state: state, config: config, theme: .light)
        XCTAssertEqual(model.primaryButtonStyle, .destructive)
    }

    func testRenderModelOpacityWhenDisabled() {
        let state = DSAlertState(isPresented: true, isProcessing: false, isEnabled: false)
        let model = DSAlertRenderModel.make(state: state, config: DSAlertConfig(), theme: .light)
        XCTAssertLessThan(model.opacity, 1.0)
    }
}
