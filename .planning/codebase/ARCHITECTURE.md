# Architecture

**Analysis Date:** 2026-02-25

## Pattern Overview

**Overall:** Layered modular architecture with clear separation of concerns across four interdependent libraries (Core, State, Components, and root package).

**Key Characteristics:**
- **Token-based theming:** Core design tokens (colors, typography, spacing) are defined once and injected via SwiftUI environment
- **Redux-inspired state management:** Reducer protocol enables functional, testable state mutations
- **Component composition:** UI components are self-contained with Config, State, Event, and RenderModel sub-types
- **Validation framework:** Composable validation rules allow flexible input validation pipelines

## Layers

**Core Layer (LeetPulseDesignSystemCore):**
- Purpose: Define and expose design tokens, colors, and theme configuration
- Location: `Sources/LeetPulseDesignSystemCore/`
- Contains: Theme definitions (DSTheme), color palettes (DSColors, DSVizColors), typography, spacing, radii, gradients
- Depends on: SwiftUI only
- Used by: State layer, Components layer, and all consumers of design tokens

**State Layer (LeetPulseDesignSystemState):**
- Purpose: Provide state management infrastructure and form validation
- Location: `Sources/LeetPulseDesignSystemState/`
- Contains: StateStore generic class, ReducerProtocol, validation rules and validators
- Depends on: Core layer (for types), Combine framework
- Used by: Components layer for managing interactive component state

**Components Layer (LeetPulseDesignSystemComponents):**
- Purpose: Build reusable UI components using tokens and state management
- Location: `Sources/LeetPulseDesignSystemComponents/`
- Contains: 62+ SwiftUI components organized as primitives (DSButton, DSText, DSCard) and mobile-specific components (DSProblemCard, DSFocusTimeCard)
- Depends on: Core layer (for tokens), State layer (for state/validation)
- Used by: Applications that consume the design system

**Root Package (LeetPulseDesignSystem):**
- Purpose: Re-export all three libraries under a single public interface
- Location: `Sources/LeetPulseDesignSystem/`
- Contains: Single re-export file using @_exported import
- Depends on: All three libraries
- Used by: Applications importing the design system

## Data Flow

**Theme Injection:**

1. App creates or selects DSTheme (light or dark via DSTheme.light / DSTheme.dark)
2. Wraps root view with DSThemeProvider<Content>
3. DSThemeProvider injects theme into SwiftUI environment via EnvironmentValues key (DSThemeKey)
4. Any component accesses theme via @Environment(\.dsTheme) private var theme
5. Components derive render properties using DSXxxRenderModel.make(state:, config:, theme:) factory pattern

**State Mutation & Component Updates:**

1. User interacts with component (e.g., button tap, text input change)
2. Component calls StateStore.send(event:) with specific event (e.g., .setLoading(true))
3. StateStore passes event to reducer via reduce(state:inout, event:)
4. Reducer mutates state in-place and returns
5. @Published state property triggers SwiftUI re-render
6. Component reads updated state and regenerates render model
7. UI updates with new render properties (colors, opacity, padding, etc.)

**Validation Pipeline:**

1. DSValidator composed of array of DSValidationRule conformers
2. Each rule's validate(_:) returns DSValidationResult (valid or invalid with DSValidationError)
3. Validator applies rules sequentially, returning early on first failure
4. Wrapped in DSValidation facade for simple isValid(_:) boolean check
5. Form fields integrate result into state via DSFormFieldState.validationMessage

**State Management:**

- Components maintain local state (@State) for UI interactions
- Complex components use StateStore<Reducer> for structured state + events
- Theme flows downward via environment (read-only)
- Validation flows upward through form field callbacks

## Key Abstractions

**ReducerProtocol:**
- Purpose: Define state mutation contract in functional style
- Examples: `DSButtonReducer`, component-specific reducers throughout components
- Pattern: `mutating func reduce(state: inout State, event: Event)` mutates state directly

**RenderModel Pattern:**
- Purpose: Bridge computed properties with theme-aware styling
- Examples: `DSButtonRenderModel`, `DSCardRenderModel`, `DSFormFieldRenderModel`
- Pattern: Static factory `make(state:config:theme:) -> Self` computes all render properties upfront

**Config/State/Event Triplet:**
- Purpose: Separate static configuration, mutable state, and input events
- Examples: `DSButtonConfig/State/Event`, `DSCardConfig/State`, `DSFormFieldConfig/State`
- Pattern: Components accept Config + State, emit Events to reducer

**DSVizColors (Okabe-Ito Palette):**
- Purpose: Provide colorblind-safe visualization colors
- Examples: Eight distinct colors (primary through octenary) with semantic aliases (highlight, selected, error)
- Pattern: Light/dark variants configured per theme, accessed via theme.vizColors

**Validation Rule Composition:**
- Purpose: Build validation logic from reusable rules
- Examples: DSValidationRule protocol + DSValidator + DSValidation facade
- Pattern: [DSValidationRule] array enables chaining; first failure stops evaluation

## Entry Points

**DSThemeProvider<Content>:**
- Location: `Sources/LeetPulseDesignSystemCore/DSTheme.swift` (lines 312-324)
- Triggers: App initialization to inject theme
- Responsibilities: Wrap root view, inject theme into environment

**StateStore<R>:**
- Location: `Sources/LeetPulseDesignSystemState/StateMachine.swift` (lines 10-22)
- Triggers: Component initialization when managing state
- Responsibilities: Hold mutable state, receive events, call reducer, trigger re-renders via @Published

**Component Entry (e.g., DSButton, DSCard):**
- Location: `Sources/LeetPulseDesignSystemComponents/DS*.swift` (60+ files)
- Triggers: Anywhere component needs to render
- Responsibilities: Accept config + state, read theme from environment, render using render model

## Error Handling

**Strategy:** Composable validation with structured error objects rather than thrown exceptions

**Patterns:**
- **Validation errors:** DSValidationError encapsulates message + optional code, returned in DSValidationResult
- **State representation:** Components include validation state in their State struct (e.g., DSFormFieldState.validationMessage)
- **Composition:** Multiple validation rules apply sequentially; first failure prevents subsequent rule evaluation
- **UI feedback:** Form fields display validation messages via DSFormField with state-derived visibility

## Cross-Cutting Concerns

**Logging:** Not detected - design system focuses on presentation; logging delegated to consuming app

**Validation:** Centralized in State layer (`Sources/LeetPulseDesignSystemState/Validation/`) with composable rules and validators. Used by components like DSTextValidation and DSFormField.

**Authentication:** Not applicable - design system is purely presentational

**Theme Access:** All components access theme via @Environment(\.dsTheme) pattern. Theme injected once at app root via DSThemeProvider.

---

*Architecture analysis: 2026-02-25*
