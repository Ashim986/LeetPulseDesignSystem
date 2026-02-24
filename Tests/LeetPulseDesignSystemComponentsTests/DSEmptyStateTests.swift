import XCTest
@testable import LeetPulseDesignSystemComponents
import LeetPulseDesignSystemCore

final class DSEmptyStateTests: XCTestCase {
    func testReducerUpdatesLoading() {
        var state = DSEmptyStateState(isLoading: false, isActionEnabled: true)
        var reducer = DSEmptyStateReducer()
        reducer.reduce(state: &state, event: .setLoading(true))
        XCTAssertTrue(state.isLoading)
    }

    func testRenderModelBuilds() {
        _ = DSEmptyStateRenderModel.make(theme: .light)
        XCTAssertTrue(true)
    }
}
