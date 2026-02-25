import XCTest
@testable import LeetPulseDesignSystem

final class DSMetricCardTests: XCTestCase {
    func testReducerUpdatesLoadingState() {
        var state = DSMetricCardState(isLoading: false, isEnabled: true)
        var reducer = DSMetricCardReducer()

        reducer.reduce(state: &state, event: .setLoading(true))
        XCTAssertTrue(state.isLoading)
    }

    func testRenderModelShowsTrendIconForPositive() {
        let state = DSMetricCardState()
        let config = DSMetricCardConfig(style: .accent, showsTrendIcon: true)
        let model = DSMetricCardRenderModel.make(state: state, config: config, trend: .positive, theme: .light)
        XCTAssertEqual(model.trendIconName, "arrow.up.right")
    }

    func testRenderModelOpacityWhenDisabled() {
        let state = DSMetricCardState(isLoading: false, isEnabled: false)
        let model = DSMetricCardRenderModel.make(state: state, config: DSMetricCardConfig(), trend: nil, theme: .light)
        XCTAssertLessThan(model.opacity, 1.0)
    }
}
