# Coding Conventions

**Analysis Date:** 2026-02-25

## Naming Patterns

**Files:**
- PascalCase for component files: `DSButton.swift`, `DSBadge.swift`, `DSToggle.swift`
- Design system prefix `DS` required for all public types: `DSButton`, `DSBadge`, `DSCard`
- Utility files named by purpose: `DSTheme.swift`, `DSValidationRule.swift`, `StateMachine.swift`

**Functions:**
- camelCase for all function names
- Public reducer methods: `reduce(state:event:)` - required by `ReducerProtocol`
- Factory methods: `make(state:config:theme:)` for render models
- Verb-based for action methods: `validate()`, `toggle()`, `send()`

**Variables:**
- camelCase for properties: `isEnabled`, `isLoading`, `cornerRadius`, `textPrimary`
- Boolean properties prefixed with `is`: `isEnabled`, `isHighlighted`, `isDisabled`, `isDirty`, `isValid`
- Private let properties stored at top of structs/views: `private let title: String?`
- Published state in stores: `@Published public private(set) var state: R.State`

**Types:**
- PascalCase for all types
- Enum cases: lowercase with underscores: `case leading`, `case trailing`, `case primary`, `case ghost`
- Associated types in protocols: PascalCase: `associatedtype State`, `associatedtype Event`
- State structs: suffix with `State` - `DSButtonState`, `DSToggleState`, `DSCardState`
- Config structs: suffix with `Config` - `DSButtonConfig`, `DSCardConfig`, `DSToggleConfig`
- Event enums: suffix with `Event` - `DSButtonEvent`, `DSToggleEvent`
- Reducer structs: suffix with `Reducer` - `DSButtonReducer`, `DSToggleReducer`
- Render model structs: suffix with `RenderModel` - `DSButtonRenderModel`, `DSBadgeRenderModel`

## Code Style

**Formatting:**
- Swift standard 4-space indentation (SwiftUI default)
- Line length: No enforced limit observed, but kept reasonable
- Braces: Opening brace on same line
- Spacing: Single blank lines between type definitions

**Linting:**
- No explicit linter detected in Package.swift
- Code follows Swift 6.2 strict concurrency model

**Access Control:**
- All design system types marked `public` for library export
- Implementation details marked `private` (private let, private var)
- Config/State/Event types marked `public` for consumer use
- Environment keys marked `private`: `private struct DSThemeKey: EnvironmentKey`
- Render models marked `public` but typically accessed through factory method

## Import Organization

**Order:**
1. Foundation/Framework imports: `import SwiftUI`, `import Foundation`, `import Combine`
2. Target module imports: `import LeetPulseDesignSystemCore`, `import LeetPulseDesignSystemState`
3. Testing imports: `import XCTest`, `@testable import LeetPulseDesignSystemComponents`

**Path Aliases:**
- No custom path aliases used
- Full module imports required: `import LeetPulseDesignSystemCore`
- @_exported used in main re-exports: `@_exported import LeetPulseDesignSystemCore`

## Error Handling

**Patterns:**
- Validation result pattern: Return `DSValidationResult` enum with `.valid` or `.invalidMessage(message, code:)`
- No exceptions thrown; all results are descriptive enums
- Validation rules implement `DSValidationRule` protocol to standardize error handling
- State machines maintain validity through event-driven updates

Example from `DSValidationRule.swift`:
```swift
public func validate(_ value: String) -> DSValidationResult {
    value.count >= minLength ? .valid : .invalidMessage(message, code: id)
}
```

## Logging

**Framework:** `print()` or console output via `DSConsoleOutput` component

**Patterns:**
- No logging framework detected; relies on debug output
- Component state changes tracked through @Published state properties
- Validation results include both boolean isValid and message for diagnostics

## Comments

**When to Comment:**
- Triple slash documentation (`///`) for public APIs and complex logic
- Example: `/// Creates a color from a 6-digit hex string (e.g. "E69F00").`
- Line comments before logic sections: `// MARK: - Light and Dark Themes`
- Sparse use of inline comments; code is self-documenting through naming

**Documentation Comments:**
- Used selectively on computed properties: `/// Transparent surface -- use via `theme.colors.surfaceClear` instead of `Color.clear`.`
- Not used on simple properties or obvious functions
- Primarily for non-obvious behaviors or important usage notes

## Function Design

**Size:** Functions kept small and focused; most under 30 lines
- Render model `make()` factories: 20-30 lines, handle style/state calculation
- View body implementations: 10-20 lines
- Reducer `reduce()` methods: 10-15 lines with switch statements

**Parameters:**
- Explicit parameters preferred over context objects
- Standard pattern: `make(state: State, config: Config, theme: DSTheme) -> RenderModel`
- Environment values injected via `@Environment`: `@Environment(\.dsTheme) private var theme`
- Closures for callbacks: `onToggle: @escaping (Bool) -> Void`

**Return Values:**
- Single return type or Result enum
- Struct instances for render models: returns data not View
- For reducers: mutating function (no return) modifies state in-place
- For validators: return `DSValidationResult` enum

## Module Design

**Exports:**
- All public types exported through parent module via re-export
- Example: `@_exported import LeetPulseDesignSystemCore` in main `LeetPulseDesignSystem.swift`
- Private implementation details not exported

**Barrel Files:**
- Main module file `LeetPulseDesignSystem.swift` re-exports sub-modules
- No individual component barrel files (each component is single file)
- Each component file is self-contained: config, state, event, reducer, render model, view

## Struct Composition

**Standard Component Structure (as seen in DSButton, DSBadge, DSCard, DSToggle, DSSelect):**
1. Enums for options: `DSButtonStyle`, `DSButtonSize`, `DSButtonIconPosition`
2. Config struct: `DSButtonConfig` with public init, settable properties
3. State struct: `DSButtonState` with public init, mutable properties, conforms to `Equatable, Sendable`
4. Event enum: `DSButtonEvent` cases for state changes
5. Reducer struct: implements `ReducerProtocol`, `mutating func reduce()`
6. Render model struct: `DSButtonRenderModel` with `static func make()` factory
7. View struct: implements `View` protocol, uses `@Environment(\.dsTheme)`

Example pattern from `DSButton.swift`:
```swift
public enum DSButtonStyle: String, Sendable { case primary, secondary, ghost, destructive }
public struct DSButtonConfig { public let style: DSButtonStyle; ... }
public struct DSButtonState: Equatable, Sendable { public var isEnabled: Bool; ... }
public enum DSButtonEvent: Sendable { case setEnabled(Bool), setLoading(Bool) }
public struct DSButtonReducer: ReducerProtocol { ... }
public struct DSButtonRenderModel { public static func make(...) -> Self { ... } }
public struct DSButton: View { ... }
```

## Thread Safety

**Sendable Protocol:**
- All state types conform to `Sendable`: `public struct DSButtonState: Equatable, Sendable`
- All config types conform to `Sendable`: `public struct DSButtonConfig: Sendable`
- All event enums conform to `Sendable`: `public enum DSButtonEvent: Sendable`
- Swift 6.2 strict concurrency enforced via Package.swift platforms

---

*Convention analysis: 2026-02-25*
