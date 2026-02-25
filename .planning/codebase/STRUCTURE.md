# Codebase Structure

**Analysis Date:** 2026-02-25

## Directory Layout

```
LeetPulseDesignSystem/
├── .planning/              # GSD planning documents and phase records
├── .swiftpm/              # Swift Package Manager build artifacts
├── .build/                # Build output directory
├── Docs/                  # Documentation files
├── Sources/               # Swift source code (4 libraries)
│   ├── LeetPulseDesignSystem/
│   ├── LeetPulseDesignSystemCore/
│   ├── LeetPulseDesignSystemState/
│   └── LeetPulseDesignSystemComponents/
├── Tests/                 # Swift test targets (3 test suites)
│   ├── LeetPulseDesignSystemCoreTests/
│   ├── LeetPulseDesignSystemStateTests/
│   └── LeetPulseDesignSystemComponentsTests/
├── Package.swift          # Swift Package manifest
├── README.md              # Project overview
└── LICENSE                # Project license
```

## Directory Purposes

**Sources/LeetPulseDesignSystemCore/:**
- Purpose: Design token definitions and theme configuration
- Contains: Token structs (DSColors, DSTypography, DSSpacing, DSRadii, DSShadow), theme variants (light/dark), visualization colors, gradients
- Key files:
  - `DSTheme.swift` - Theme struct, DSThemeKind enum, light/dark presets, DSThemeProvider<Content>, environment key definition
  - `DSColors.swift` - DSColors token struct with utility extensions
  - `DSVizColors.swift` - Okabe-Ito colorblind-safe palette
  - `DSGradients.swift` - Reusable gradient definitions
  - `DSLayout.swift` - Spacing token utility functions
  - `DSMobileTokens.swift` - Mobile-specific token overrides

**Sources/LeetPulseDesignSystemState/:**
- Purpose: State management infrastructure and form validation framework
- Contains: StateStore generic class, ReducerProtocol, validation rules, validators, validation results/errors
- Key files:
  - `StateMachine.swift` - StateStore<R: ReducerProtocol> generic class with @Published state and send(event:) method
  - `Validation/DSValidator.swift` - Composes array of validation rules with sequential application
  - `Validation/DSValidation.swift` - Facade for validator with simple isValid(_:) and validate(_:) methods
  - `Validation/DSValidationRule.swift` - Protocol for validation rule conformers
  - `Validation/DSValidationResult.swift` - Enum for valid or invalid state with error
  - `Validation/DSValidationError.swift` - Structured error with message and optional code
  - `Validation/DSValidationState.swift` - Tracks validation state for form fields
  - `Validation/DSValidationFactory.swift` - Factory for creating common validation rules

**Sources/LeetPulseDesignSystemComponents/:**
- Purpose: Reusable SwiftUI UI components
- Contains: 62+ components organized by category (primitives and mobile-specific)
- Primitives (directly in root):
  - `DSButton.swift`, `DSActionButton.swift`, `DSIconButton.swift` - Button variants
  - `DSText.swift` - Typography component wrapper
  - `DSCard.swift` - Surface component with elevation/outline styles
  - `DSBadge.swift`, `DSPointerBadge.swift`, `DSStreakBadge.swift` - Badge variants
  - `DSToggle.swift`, `DSSegmentedControl.swift`, `DSSelect.swift` - Form controls
  - `DSTextField.swift`, `DSTextArea.swift`, `DSTextValidation.swift` - Text input
  - `DSFormField.swift` - Form field wrapper with validation display
  - `DSHeader.swift`, `DSCompactHeaderBar.swift`, `DSSectionHeader.swift`, `DSProgressHeader.swift` - Header variants
  - `DSToast.swift`, `DSAlert.swift` - Toast and alert components
  - `DSListRow.swift`, `DSSidebar.swift`, `DSTabBar.swift` - List/navigation components
  - `DSGraphView.swift`, `DSTreeGraphView.swift` - Visualization components
  - `DSArrow.swift`, `DSCurvedArrow.swift` - Arrow/shape components
  - `DSConsoleOutput.swift`, `DSEmptyState.swift` - Specialty components
  - `DSBubble.swift`, `DSImage.swift` - Utility components
  - `DSNavigationModels.swift`, `DSScaffolds.swift` - Navigation and layout models
  - `DSBadge+Difficulty.swift` - Extension for difficulty-specific badge styling
  - `DSPicker.swift`, `DSProgressRing.swift` - Additional controls

- Mobile-specific (in Mobile/ subdirectory):
  - Problem/content cards: `DSProblemCard.swift`, `DSSurfaceCard.swift`
  - Time/focus: `DSFocusTimeCard.swift`, `DSTimerRing.swift`
  - Goals: `DSDailyGoalCard.swift`
  - Navigation: `DSHeaderBar.swift`, `DSSidebarNav.swift`, `DSBottomTabBar.swift`
  - Search: `DSSearchBar.swift`
  - Settings: `DSSettingsRow.swift`
  - Data display: `DSLineChart.swift`, `DSBarChart.swift`, `DSCalendarGrid.swift`
  - Code: `DSCodeViewer.swift`
  - Tasks/schedule: `DSTaskRow.swift`, `DSScheduleRow.swift`
  - Metrics: `DSMetricCardView.swift`
  - CTA: `DSStartFocusCTA.swift`
  - Controls: `DSPomodoroSegmentedControl.swift`, `DSSignOutButton.swift`

- Examples (in Examples/ subdirectory):
  - `DSSampleScreens.swift` - Preview/demo screens for design system showcase

**Sources/LeetPulseDesignSystem/:**
- Purpose: Public re-export facade for all three libraries
- Contains: Single file for aggregated import
- Key files:
  - `LeetPulseDesignSystem.swift` - Uses @_exported import to publicly expose Core, State, Components

**Tests/LeetPulseDesignSystemCoreTests/:**
- Purpose: Test design tokens and theme configuration
- Contains: Token validation and theme tests
- Key files:
  - `DSTokenTests.swift` - Tests for color hex parsing, spacing values, theme variants

**Tests/LeetPulseDesignSystemStateTests/:**
- Purpose: Test state management and validation
- Contains: StateStore reducer tests and validation tests
- Key files:
  - `StateStoreTests.swift` - Tests for StateStore with various reducers
  - `DSValidationTests.swift` - Tests for validation rules and validator composition

**Tests/LeetPulseDesignSystemComponentsTests/:**
- Purpose: Test component behavior and render models
- Contains: 20+ test files for components
- Key files:
  - `DSButtonTests.swift` - Button state, reducer, render model tests
  - `DSCardTests.swift` - Card styling and state tests
  - `DSBadgeTests.swift`, `DSPointerBadgeTests.swift` - Badge behavior
  - `DSToggleTests.swift`, `DSSelectTests.swift` - Form control tests
  - `DSTextFieldTests.swift`, `DSTabBarTests.swift` - Input/navigation tests
  - `DSToastTests.swift` - Toast display tests
  - `DSHeaderTests.swift`, `DSSectionHeaderTests.swift` - Header tests
  - `DSListRowTests.swift`, `DSMetricCardTests.swift` - List item tests
  - `DSSegmentedControlTests.swift` - Segmented control tests
  - `DSTreeLayoutTests.swift`, `DSTreeGraphViewTests.swift` - Tree visualization tests
  - `DSScaffoldsTests.swift` - Scaffold layout tests
  - `DSBubbleTests.swift` - Bubble component tests
  - `DSPrimitivesDemoView.swift` - Demo/preview component

## Key File Locations

**Entry Points:**
- `Sources/LeetPulseDesignSystem/LeetPulseDesignSystem.swift`: Public aggregate entry point
- `Sources/LeetPulseDesignSystemCore/DSTheme.swift` (lines 312-324): DSThemeProvider wraps app root
- `Package.swift`: Swift Package manifest defines all targets and dependencies

**Configuration:**
- `Package.swift`: Platform requirements (macOS 14+, iOS 26+), package name, products, and target definitions
- `.gitignore`: Version control exclusions
- `LICENSE`: Legal terms

**Core Logic (Tokens):**
- `Sources/LeetPulseDesignSystemCore/DSTheme.swift`: Complete theme struct with light/dark variants
- `Sources/LeetPulseDesignSystemCore/DSColors.swift`: Primary color palette
- `Sources/LeetPulseDesignSystemCore/DSVizColors.swift`: Okabe-Ito colorblind-safe palette
- `Sources/LeetPulseDesignSystemCore/DSGradients.swift`: Gradient definitions

**Core Logic (State):**
- `Sources/LeetPulseDesignSystemState/StateMachine.swift`: StateStore<R> generic container
- `Sources/LeetPulseDesignSystemState/Validation/DSValidator.swift`: Rule composition engine
- `Sources/LeetPulseDesignSystemState/Validation/DSValidation.swift`: Public validation facade

**Core Logic (Components):**
- `Sources/LeetPulseDesignSystemComponents/DSButton.swift`: Exemplar of component pattern (Config, State, Event, RenderModel, View)
- `Sources/LeetPulseDesignSystemComponents/DSCard.swift`: Card with style variants
- `Sources/LeetPulseDesignSystemComponents/DSFormField.swift`: Form field with validation support

**Testing:**
- `Tests/LeetPulseDesignSystemCoreTests/DSTokenTests.swift`: Token behavior
- `Tests/LeetPulseDesignSystemStateTests/StateStoreTests.swift`: State store and reducer
- `Tests/LeetPulseDesignSystemComponentsTests/DSButtonTests.swift`: Component render models and state

## Naming Conventions

**Files:**
- Pattern: `DS{ComponentName}.swift` for components and tokens
- Example: `DSButton.swift`, `DSTheme.swift`, `DSCard.swift`

**Directories:**
- Pattern: `{Layer}/{Subdomain}` for organizing related functionality
- Example: `Sources/LeetPulseDesignSystemComponents/Mobile/`, `Sources/LeetPulseDesignSystemState/Validation/`

**Types:**
- Pattern: Prefix with `DS` for public API, no prefix for private implementation details
- Example: `DSButton`, `DSButtonConfig`, `DSButtonState`, `DSButtonEvent`, `DSButtonRenderModel`, `DSButtonReducer`

**Protocols:**
- Pattern: Prefix with `DS`, suffix with `Protocol` for behavioral contracts
- Example: `ReducerProtocol`, `DSValidationRule`

**Enums:**
- Pattern: Prefix with `DS`, use singular names for case sets
- Example: `DSButtonStyle` (primary, secondary, ghost, destructive), `DSCardStyle` (surface, elevated, outlined)

**Functions:**
- Pattern: camelCase for instance/static methods
- Example: `reduce(state:event:)`, `validate(_:)`, `make(state:config:theme:)`

## Where to Add New Code

**New Component (Primitive):**
- Primary code: `Sources/LeetPulseDesignSystemComponents/{ComponentName}.swift`
- Tests: `Tests/LeetPulseDesignSystemComponentsTests/{ComponentName}Tests.swift`
- Pattern: Create Config, State, Event, RenderModel, View, and Reducer types following DSButton example

**New Mobile Component:**
- Primary code: `Sources/LeetPulseDesignSystemComponents/Mobile/DS{ComponentName}.swift`
- Tests: `Tests/LeetPulseDesignSystemComponentsTests/DS{ComponentName}Tests.swift`
- Pattern: Same as primitive, but co-locate in Mobile/ subdirectory for platform-specific variants

**New Validation Rule:**
- Primary code: `Sources/LeetPulseDesignSystemState/Validation/DS{RuleName}.swift` or extend existing rule file
- Tests: `Tests/LeetPulseDesignSystemStateTests/DSValidationTests.swift`
- Pattern: Conform to DSValidationRule protocol with validate(_:) -> DSValidationResult

**New Core Token:**
- Primary code: `Sources/LeetPulseDesignSystemCore/DS{TokenType}.swift`
- Tests: `Tests/LeetPulseDesignSystemCoreTests/DSTokenTests.swift`
- Pattern: Add to DSTheme struct or create companion token struct (see DSVizColors, DSGradients)

**Shared Utilities:**
- If used by multiple components: Add static functions or extensions to existing Core/State files
- If component-specific: Keep as private implementation in component file

## Special Directories

**.planning/:**
- Purpose: GSD (Getting Stuff Done) planning documents, phase records, and codebase maps
- Generated: Yes (created by /gsd:map-codebase, /gsd:plan-phase, /gsd:execute-phase)
- Committed: Yes (documents tracked in version control)

**.build/:**
- Purpose: Swift Package Manager build artifacts
- Generated: Yes (created during `swift build`)
- Committed: No (excluded via .gitignore)

**.swiftpm/:**
- Purpose: Swift Package Manager metadata and xcworkspace
- Generated: Yes (created by SPM toolchain)
- Committed: No (typically excluded)

**Docs/:**
- Purpose: Manual documentation files (guides, design decisions, API docs)
- Generated: No (manually maintained)
- Committed: Yes

---

*Structure analysis: 2026-02-25*
