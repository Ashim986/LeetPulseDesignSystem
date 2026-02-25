import XCTest
import SwiftUI
@testable import LeetPulseDesignSystem

final class DSTokenTests: XCTestCase {
    func testThemeKinds() {
        XCTAssertEqual(DSTheme.light.kind, .light)
        XCTAssertEqual(DSTheme.dark.kind, .dark)
    }

    func testSpacingDefaults() {
        let spacing = DSTheme.light.spacing
        XCTAssertEqual(spacing.xs, 4)
        XCTAssertEqual(spacing.sm, 8)
        XCTAssertEqual(spacing.md, 12)
        XCTAssertEqual(spacing.lg, 16)
        XCTAssertEqual(spacing.xl, 24)
    }

    func testRadiiDefaults() {
        let radii = DSTheme.light.radii
        XCTAssertEqual(radii.sm, 6)
        XCTAssertEqual(radii.md, 10)
        XCTAssertEqual(radii.lg, 16)
        XCTAssertEqual(radii.pill, 999)
    }
}
