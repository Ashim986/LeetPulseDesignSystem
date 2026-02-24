import XCTest
@testable import LeetPulseDesignSystemComponents
import LeetPulseDesignSystemCore

final class DSHeaderTests: XCTestCase {
    func testHeaderAlignmentCenter() {
        let state = DSHeaderState()
        let config = DSHeaderConfig(alignment: .center, showsDivider: false)
        let model = DSHeaderRenderModel.make(state: state, config: config, theme: .light)

        XCTAssertEqual(model.alignment, .center)
    }

    func testHeaderReducerUpdatesLoading() {
        var state = DSHeaderState(isLoading: false)
        var reducer = DSHeaderReducer()

        reducer.reduce(state: &state, event: .setLoading(true))
        XCTAssertTrue(state.isLoading)
    }
}
