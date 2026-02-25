# Technology Stack

**Analysis Date:** 2026-02-25

## Languages

**Primary:**
- Swift 6.2 - All source code for design system package and components

**Secondary:**
- None

## Runtime

**Environment:**
- Swift runtime (native compilation)

**Package Manager:**
- Swift Package Manager (SPM)
- Lockfile: Not detected (SPM uses Package.resolved for exact versions)

## Frameworks

**Core:**
- SwiftUI - UI framework for all components
- Foundation - Standard library utilities
- Combine - Reactive programming for state management

**Testing:**
- XCTest - Built-in Swift testing framework

**Build/Dev:**
- Swift 6.2 compiler

## Key Dependencies

**Critical:**
- SwiftUI - Used in virtually all component files for UI rendering
  - Location: `Sources/LeetPulseDesignSystemComponents/`
- Combine - State management via `@Published` and `ObservableObject`
  - Location: `Sources/LeetPulseDesignSystemState/StateMachine.swift`

**Infrastructure:**
- CoreGraphics - For layout and spacing calculations
  - Location: `Sources/LeetPulseDesignSystemCore/DSLayout.swift`
- Foundation - For validation regex and string operations
  - Location: `Sources/LeetPulseDesignSystemState/Validation/DSValidationRule.swift`

## Configuration

**Environment:**
- Minimum deployment targets:
  - macOS 14.0+
  - iOS 26+
- Swift language version: 6.2
- Configuration file: `Package.swift`

**Build:**
- `Package.swift` - SPM manifest containing platform definitions, product definitions, and target dependencies

## Platform Requirements

**Development:**
- Xcode (via `.swiftpm/xcode/package.xcworkspace`)
- Swift 6.2+
- macOS 14+ or iOS 26+ capable device/simulator

**Production:**
- Standalone Swift package consumable by any iOS/macOS app
- No external service dependencies
- Library distribution via SPM

## Module Structure

**LeetPulseDesignSystemCore:**
- Pure design tokens and theme infrastructure
- No UI dependencies
- Provides: colors, typography, spacing, shadows, theme management
- Files: `DSTheme.swift`, `DSGradients.swift`, `DSLayout.swift`, `DSMobileTokens.swift`, `DSVizColors.swift`

**LeetPulseDesignSystemState:**
- State management and validation framework
- Reducer-based state store using Combine
- Validation rule system with built-in validators
- Files: `StateMachine.swift`, `Validation/` subdirectory

**LeetPulseDesignSystemComponents:**
- 50+ reusable SwiftUI components
- Mobile-optimized components in `Mobile/` subdirectory
- Examples in `Examples/` subdirectory
- All components use Core tokens and optional State management

**LeetPulseDesignSystem:**
- Umbrella package re-exporting all three modules
- Provides unified import experience

---

*Stack analysis: 2026-02-25*
