import XCTest
@testable import LeetPulseDesignSystem

final class DSProgressRingTests: XCTestCase {
    func testProgressClampsToBounds() {
        let state = DSProgressRingState(progress: 1.5)
        let config = DSProgressRingConfig(size: 40, lineWidth: 3)
        let model = DSProgressRingRenderModel.make(state: state, config: config, theme: .light)

        XCTAssertEqual(model.progress, 1.0)
    }

    func testReducerSetsProgress() {
        var state = DSProgressRingState(progress: nil)
        var reducer = DSProgressRingReducer()

        reducer.reduce(state: &state, event: .setProgress(0.25))
        XCTAssertEqual(state.progress, 0.25)
    }
}
