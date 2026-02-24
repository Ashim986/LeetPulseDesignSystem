import XCTest
@testable import LeetPulseDesignSystemComponents
import LeetPulseDesignSystemCore

final class DSScaffoldsTests: XCTestCase {
    func testTabScaffoldOpacityWhenDisabled() {
        let state = DSTabScaffoldState(isEnabled: false)
        let model = DSTabScaffoldRenderModel.make(state: state, config: DSTabScaffoldConfig(), theme: .light)
        XCTAssertLessThan(model.opacity, 1.0)
    }

    func testSidebarScaffoldUsesConfigValues() {
        let config = DSSidebarScaffoldConfig(sidebarWidth: 300, columnSpacing: 20)
        let model = DSSidebarScaffoldRenderModel.make(
            state: DSSidebarScaffoldState(isEnabled: true),
            config: config,
            theme: .dark
        )
        XCTAssertEqual(model.sidebarWidth, 300)
        XCTAssertEqual(model.columnSpacing, 20)
    }
}
