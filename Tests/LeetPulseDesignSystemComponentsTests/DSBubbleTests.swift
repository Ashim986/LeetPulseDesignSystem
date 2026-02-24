import XCTest
@testable import LeetPulseDesignSystemComponents
import LeetPulseDesignSystemCore

final class DSBubbleTests: XCTestCase {
    func testRenderModelUsesHighlightDefaults() {
        let state = DSBubbleState(isHighlighted: true, changeType: nil)
        let config = DSBubbleConfig(size: 32)
        let model = DSBubbleRenderModel.make(text: "1", state: state, config: config, theme: .light)

        XCTAssertEqual(model.highlightLineWidth, 2)
        XCTAssertNotNil(model.highlightColor)
    }

    func testRenderModelChangeTypeAddedUsesStroke() {
        let state = DSBubbleState(isHighlighted: false, changeType: .added)
        let model = DSBubbleRenderModel.make(text: "1", state: state, config: DSBubbleConfig(), theme: .light)

        XCTAssertNotNil(model.changeStrokeColor)
        XCTAssertNil(model.changeFillColor)
    }

    func testRenderModelChangeTypeRemovedUsesFill() {
        let state = DSBubbleState(isHighlighted: false, changeType: .removed)
        let model = DSBubbleRenderModel.make(text: "1", state: state, config: DSBubbleConfig(), theme: .light)

        XCTAssertNil(model.changeStrokeColor)
        XCTAssertNotNil(model.changeFillColor)
    }
}
