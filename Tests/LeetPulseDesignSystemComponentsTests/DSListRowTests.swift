import XCTest
@testable import LeetPulseDesignSystemComponents
import LeetPulseDesignSystemCore

final class DSListRowTests: XCTestCase {
    func testReducerUpdatesSelection() {
        var state = DSListRowState(isEnabled: true, isSelected: false, isHighlighted: false)
        var reducer = DSListRowReducer()

        reducer.reduce(state: &state, event: .setSelected(true))
        XCTAssertTrue(state.isSelected)

        reducer.reduce(state: &state, event: .setHighlighted(true))
        XCTAssertTrue(state.isHighlighted)
    }

    func testRenderModelPaddingForCompact() {
        let compactConfig = DSListRowConfig(style: .compact, showsDivider: false)
        let standardConfig = DSListRowConfig(style: .standard, showsDivider: false)

        let compactModel = DSListRowRenderModel.make(state: DSListRowState(), config: compactConfig, theme: .light)
        let standardModel = DSListRowRenderModel.make(state: DSListRowState(), config: standardConfig, theme: .light)

        XCTAssertLessThan(compactModel.padding.top, standardModel.padding.top)
        XCTAssertLessThan(compactModel.padding.leading, standardModel.padding.leading)
    }

    func testRenderModelOpacityWhenDisabled() {
        let state = DSListRowState(isEnabled: false)
        let model = DSListRowRenderModel.make(state: state, config: DSListRowConfig(), theme: .light)
        XCTAssertLessThan(model.opacity, 1.0)
    }
}
