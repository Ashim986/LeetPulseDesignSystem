import XCTest
@testable import LeetPulseDesignSystem

final class DSValidationTests: XCTestCase {
    func testValidatorReturnsFirstInvalidResult() {
        let validator = DSValidator([
            DSRequiredRule(message: "Required"),
            DSEmailRule(message: "Email")
        ])
        let result = validator.validate("")
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.message, "Required")
    }

    func testValidationFactoryEmailRequired() {
        let validator = DSValidationFactory.email(required: true)
        XCTAssertFalse(validator.validate("").isValid)
        XCTAssertTrue(validator.validate("person@example.com").isValid)
    }

    func testValidationStateReducer() {
        var state = DSValidationState()
        var reducer = DSValidationReducer()
        reducer.reduce(state: &state, event: .setResult(.invalidMessage("Bad")))
        XCTAssertTrue(state.isDirty)
        XCTAssertFalse(state.isValid)
        XCTAssertEqual(state.message, "Bad")

        reducer.reduce(state: &state, event: .reset)
        XCTAssertFalse(state.isDirty)
        XCTAssertTrue(state.isValid)
    }
}
