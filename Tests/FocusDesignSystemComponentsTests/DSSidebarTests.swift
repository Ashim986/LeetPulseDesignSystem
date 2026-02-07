import XCTest
@testable import FocusDesignSystemComponents
import FocusDesignSystemCore

final class DSSidebarTests: XCTestCase {
    func testReducerSelectsWhenEnabled() {
        var state = DSSidebarState(selectedId: "today", isEnabled: true)
        var reducer = DSSidebarReducer()
        reducer.reduce(state: &state, event: .select("plan"))
        XCTAssertEqual(state.selectedId, "plan")

        reducer.reduce(state: &state, event: .setEnabled(false))
        reducer.reduce(state: &state, event: .select("stats"))
        XCTAssertEqual(state.selectedId, "plan")
    }

    func testRenderModelOpacityWhenDisabled() {
        let state = DSSidebarState(selectedId: "today", isEnabled: false)
        let model = DSSidebarRenderModel.make(state: state, theme: .dark)
        XCTAssertLessThan(model.opacity, 1.0)
    }
}
