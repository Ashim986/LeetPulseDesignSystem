# Testing Patterns

**Analysis Date:** 2026-02-25

## Test Framework

**Runner:**
- XCTest (Apple's standard testing framework)
- Integrated with Swift Package Manager via Package.swift test targets
- Config: Defined in `Package.swift` with test target dependencies

**Assertion Library:**
- XCTest assertions: `XCTAssert()`, `XCTAssertTrue()`, `XCTAssertFalse()`, `XCTAssertEqual()`, `XCTAssertLessThan()`

**Run Commands:**
```bash
swift test                    # Run all tests
swift test --watch          # Watch mode
swift test --enable-code-coverage  # Coverage report
```

## Test File Organization

**Location:**
- Co-located in `Tests/` directory with parallel structure to `Sources/`
- Test target per source module:
  - `Tests/LeetPulseDesignSystemCoreTests/` → tests `Sources/LeetPulseDesignSystemCore`
  - `Tests/LeetPulseDesignSystemStateTests/` → tests `Sources/LeetPulseDesignSystemState`
  - `Tests/LeetPulseDesignSystemComponentsTests/` → tests `Sources/LeetPulseDesignSystemComponents`

**Naming:**
- Pattern: `[ComponentName]Tests.swift`
- Examples: `DSButtonTests.swift`, `DSBadgeTests.swift`, `StateStoreTests.swift`, `DSValidationTests.swift`

**Structure:**
```
Tests/
├── LeetPulseDesignSystemComponentsTests/
│   ├── DSButtonTests.swift
│   ├── DSBadgeTests.swift
│   ├── DSToggleTests.swift
│   ├── DSSelectTests.swift
│   └── ... (23 more component test files)
├── LeetPulseDesignSystemCoreTests/
│   └── DSTokenTests.swift
└── LeetPulseDesignSystemStateTests/
    ├── StateStoreTests.swift
    └── DSValidationTests.swift
```

## Test Structure

**Suite Organization:**
```swift
import XCTest
@testable import LeetPulseDesignSystemComponents
import LeetPulseDesignSystemCore

final class DSButtonTests: XCTestCase {
    func testReducerDisablesWhenLoading() {
        // arrange
        var state = DSButtonState(isEnabled: true, isLoading: false)
        var reducer = DSButtonReducer()

        // act
        reducer.reduce(state: &state, event: .setLoading(true))

        // assert
        XCTAssertTrue(state.isLoading)
        XCTAssertFalse(state.isEnabled)
    }
}
```

**Patterns:**
- Single test class per component: `final class DSButtonTests: XCTestCase`
- Test methods named with verb prefix: `testReducerDisablesWhenLoading()`, `testRenderModelReflectsLoading()`
- Inline Arrange-Act-Assert (comments optional, implicit in structure):
  1. Create initial state/dependencies
  2. Execute the function or reducer
  3. Assert expected results

## Reducer Testing

**Pattern:**
Reducer tests focus on state mutation through events. Standard approach:

```swift
func testReducerTogglesOnlyWhenEnabled() {
    // Arrange
    var state = DSToggleState(isOn: false, isEnabled: true)
    var reducer = DSToggleReducer()

    // Act
    reducer.reduce(state: &state, event: .toggle)

    // Assert
    XCTAssertTrue(state.isOn)

    // Additional acts and asserts
    reducer.reduce(state: &state, event: .setEnabled(false))
    reducer.reduce(state: &state, event: .toggle)
    XCTAssertTrue(state.isOn)  // Still true because disabled
}
```

**What is tested:**
- State transitions from events
- Guard conditions: disabled states prevent state changes
- Cascading changes: setting loading disables button; setting enabled disables loading

## Render Model Testing

**Pattern:**
Render model tests verify the `make(state:config:theme:)` factory produces correct visual properties:

```swift
func testRenderModelReflectsLoading() {
    let state = DSButtonState(isEnabled: true, isLoading: true)
    let config = DSButtonConfig(style: .primary, size: .small)
    let model = DSButtonRenderModel.make(state: state, config: config, theme: .light)

    XCTAssertTrue(model.showsSpinner)
    XCTAssertLessThan(model.opacity, 1.0)
}
```

**What is tested:**
- Color selection based on style/state
- Font selection based on size
- Padding/spacing calculations
- Opacity changes for disabled/loading states
- Corner radius selection

**Theme usage:**
- Tests use `theme: .light` constant from `DSTheme.light` static property
- Both light and dark themes available but typically tested with light

## StateStore Testing

**Pattern:**
Tests for state store verify event dispatch and state updates:

```swift
func testStateStoreAppliesEvents() {
    let store = StateStore(initial: 0, reducer: CounterReducer())
    store.send(.increment)
    XCTAssertEqual(store.state, 1)
    store.send(.decrement)
    XCTAssertEqual(store.state, 0)
    store.send(.set(10))
    XCTAssertEqual(store.state, 10)
}
```

**What is tested:**
- Events dispatched via `send()` are applied by reducer
- State updates are observable
- Sequential events compound correctly

## Validation Testing

**Pattern:**
Validation tests exercise the `DSValidator` and `DSValidationRule` protocols:

```swift
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
```

**What is tested:**
- Rule order: first failing rule determines result message
- Factory preset validators: email with/without required, phone, name, address
- Result properties: `.isValid` boolean, `.message` string, `.code` identifier

## Mocking

**Framework:** No mocking framework detected (no Quick, Nimble, or Mockito)

**Approach:**
- Inline test doubles: test files define custom reducer implementations for validation
- Example from `StateStoreTests.swift`:
```swift
struct CounterReducer: ReducerProtocol {
    mutating func reduce(state: inout Int, event: CounterEvent) {
        switch event {
        case .increment: state += 1
        case .decrement: state -= 1
        case .set(let value): state = value
        }
    }
}
```

**What to Mock:**
- Reducers (create test reducer with simplified logic)
- State types (use simple values like Int for StateStore tests)
- No need to mock SwiftUI components or views

**What NOT to Mock:**
- `DSTheme` - use static `.light` or `.dark` constants
- `DSValidationResult` - test the actual result enum
- Actual reducer implementations - test the real thing
- Views - component rendering not tested, only logic

## Token Tests

**Pattern:**
Tests for design tokens verify constant values:

```swift
func testSpacingDefaults() {
    let spacing = DSTheme.light.spacing
    XCTAssertEqual(spacing.xs, 4)
    XCTAssertEqual(spacing.sm, 8)
    XCTAssertEqual(spacing.md, 12)
    XCTAssertEqual(spacing.lg, 16)
    XCTAssertEqual(spacing.xl, 24)
}
```

**What is tested:**
- Spacing scale values are correct
- Radii values are correct
- Theme kinds (light/dark) are properly assigned
- Token accessibility

## Fixtures and Factories

**Test Data:**
- No dedicated fixture files; data created inline in tests
- Test reducers (like `CounterReducer`) act as minimal fixtures
- Configuration defaults used: `DSButtonConfig()`, `DSToggleState()`

**Location:**
- Test data created at top of test function
- Reusable test reducers defined as nested types in test class
- Constants defined in test files, not extracted to fixtures

Example pattern:
```swift
var state = DSToggleState(isOn: false, isEnabled: true)
var reducer = DSToggleReducer()
```

## Coverage

**Requirements:** Not enforced in Package.swift

**View Coverage:**
- Code coverage not explicitly measured or reported
- No coverage configuration in package manifest

## Test Types

**Unit Tests:**
- Scope: Individual reducers, validators, state machines, render models
- Approach: Fast, isolated tests with no async/external dependencies
- Count: 26 test files, 623 total lines of test code
- Example: `DSButtonReducer` tested in isolation; state transitions verified

**Integration Tests:**
- Scope: `StateStore` with reducer, validation rules with factory
- Approach: Test interaction between components
- Example: `StateStoreTests` verifies store + reducer integration

**E2E Tests:**
- Framework: Not used
- Rationale: Design system is library; no end-to-end flows to test

## Common Patterns

**Async Testing:**
- Not used; all tests are synchronous
- State mutations are immediate (no async/await)
- No XCTestExpectation or async test methods

**State Transition Testing:**
```swift
func testReducerTogglesOnlyWhenEnabled() {
    var state = DSToggleState(isOn: false, isEnabled: true)
    var reducer = DSToggleReducer()

    // First transition
    reducer.reduce(state: &state, event: .toggle)
    XCTAssertTrue(state.isOn)

    // Disable and verify no change
    reducer.reduce(state: &state, event: .setEnabled(false))
    reducer.reduce(state: &state, event: .toggle)
    XCTAssertTrue(state.isOn)  // Unchanged
}
```

**Error Testing (Validation):**
```swift
func testValidationStateReducer() {
    var state = DSValidationState()
    var reducer = DSValidationReducer()
    reducer.reduce(state: &state, event: .setResult(.invalidMessage("Bad")))
    XCTAssertTrue(state.isDirty)
    XCTAssertFalse(state.isValid)
    XCTAssertEqual(state.message, "Bad")
}
```

**Render Model Configuration Testing:**
```swift
func testRenderModelPaddingForLarge() {
    let state = DSButtonState(isEnabled: true, isLoading: false)
    let config = DSButtonConfig(style: .secondary, size: .large)
    let model = DSButtonRenderModel.make(state: state, config: config, theme: .light)

    XCTAssertEqual(model.padding.top, 12)
    XCTAssertEqual(model.padding.leading, 24)
    XCTAssertEqual(model.padding.trailing, 24)
}
```

## Test Patterns by Module

**LeetPulseDesignSystemComponentsTests (23 tests):**
- Focus: Reducer state transitions and render model properties
- Files tested: `DSButtonTests.swift`, `DSBadgeTests.swift`, `DSToggleTests.swift`, `DSSelectTests.swift`, etc.
- Pattern: Create state/config, call reducer or factory, assert result

**LeetPulseDesignSystemStateTests (2 files, 33 lines):**
- Focus: `StateStore` integration and `DSValidator` behavior
- `StateStoreTests.swift`: Verify store + reducer work together
- `DSValidationTests.swift`: Validate validation rules and factory methods

**LeetPulseDesignSystemCoreTests (1 file, 27 lines):**
- Focus: Design token constant values
- `DSTokenTests.swift`: Verify theme spacing, radii, and theme kind assignments

---

*Testing analysis: 2026-02-25*
