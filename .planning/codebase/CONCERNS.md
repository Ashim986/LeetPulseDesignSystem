# Codebase Concerns

**Analysis Date:** 2026-02-25

## Tech Debt

**@unchecked Sendable in DSValidation:**
- Issue: `DSValidation` class uses `@unchecked Sendable` which bypasses Sendable conformance checking at compile time, hiding potential thread-safety issues
- Files: `Sources/LeetPulseDesignSystemState/Validation/DSValidation.swift`
- Impact: Could mask concurrent access violations at runtime; makes code harder to reason about thread-safety guarantees
- Fix approach: Either make the validator truly thread-safe with proper synchronization, or refactor to not require `@unchecked` annotation

**Type-Erased Validation Rules Array:**
- Issue: `DSValidator` stores `[any DSValidationRule]` which uses Swift's existential type erasure, requiring runtime dispatch for each validation check
- Files: `Sources/LeetPulseDesignSystemState/Validation/DSValidator.swift`, `Sources/LeetPulseDesignSystemState/Validation/DSValidationFactory.swift`
- Impact: Slight performance overhead on every validation call due to protocol dispatch; makes debugging harder with opaque types
- Fix approach: Consider using a builder pattern or concrete union types if validation rules are known at compile time

**Duplicate Code in DSGraphView and DSTreeGraphView:**
- Issue: Both graph visualization components have significant overlap in pointer handling, configuration, and layout logic
- Files: `Sources/LeetPulseDesignSystemComponents/DSGraphView.swift` (311 lines), `Sources/LeetPulseDesignSystemComponents/DSTreeGraphView.swift` (302 lines)
- Impact: Maintenance burden increases when fixing bugs or updating styling; inconsistent behavior between similar components
- Fix approach: Extract shared layout and pointer rendering logic into a base protocol or shared view builder

**NSPredicate for Regex Validation:**
- Issue: Email, Name, and custom regex rules use `NSPredicate` for pattern matching instead of modern Swift regex
- Files: `Sources/LeetPulseDesignSystemState/Validation/DSValidationRule.swift` (lines 35, 67, 135)
- Impact: NSPredicate is less efficient and harder to debug than Swift's built-in regex support; patterns are string-based without compile-time checking
- Fix approach: Migrate to Swift 5.7+ Regex type for type-safe, compile-time checked patterns

**DSGraphLayout Force-Directed Layout Hardcoded:**
- Issue: Force-directed graph layout uses hardcoded iteration count of 50 and fixed temperature calculation
- Files: `Sources/LeetPulseDesignSystemComponents/DSGraphView.swift` (lines 227-250)
- Impact: Layout quality is fixed for all graph sizes; may not converge well for very large or very small graphs
- Fix approach: Make iterations and damping parameters configurable or adaptive based on node count

## Fragile Areas

**Heavy GeometryReader Usage in Complex Views:**
- Files: `Sources/LeetPulseDesignSystemComponents/DSGraphView.swift`, `Sources/LeetPulseDesignSystemComponents/DSProgressHeader.swift`, `Sources/LeetPulseDesignSystemComponents/DSConsoleOutput.swift`
- Why fragile: GeometryReader blocks are known to cause re-layout thrashing in SwiftUI; used extensively in graph and progress visualization
- Safe modification: Test layout performance on various device sizes and orientations; consider using preferenceKey patterns for size communication instead
- Test coverage: No specific layout performance tests found; visual regression testing needed

**Canvas-Based Rendering in DSGraphView and DSTreeGraphView:**
- Files: `Sources/LeetPulseDesignSystemComponents/DSGraphView.swift`, `Sources/LeetPulseDesignSystemComponents/DSCurvedArrow.swift`
- Why fragile: Canvas rendering is efficient but gives up SwiftUI's accessibility features; edges drawn as paths have no built-in accessibility labels
- Safe modification: Add accessibility overlays for critical elements; ensure arrow heads and edges have proper accessibility descriptions
- Test coverage: No accessibility tests for graph visualizations

**Complex State Machine in DSButton (271 lines):**
- Files: `Sources/LeetPulseDesignSystemComponents/DSButton.swift`
- Why fragile: Loading state disables button, but disabling button clears loading state (reducer line 85-87), creating implicit state invariants
- Safe modification: Add explicit state transition validation; document valid state combinations
- Test coverage: Only basic reducer state transitions tested; missing tests for edge cases like rapid state changes

## Security Considerations

**Hex Color Parsing in DSTheme:**
- Risk: `Color(hex:)` initializer uses manual parsing with Scanner rather than validated hex format
- Files: `Sources/LeetPulseDesignSystemCore/DSTheme.swift` (lines 163-185)
- Current mitigation: Defaults to black (0,0,0) if parsing fails; only accepts 6-digit hex strings
- Recommendations: Add comprehensive validation of hex format; consider throwing errors instead of silently defaulting; document supported formats

**Validation Rule Pattern Injection:**
- Risk: `DSRegexRule` and `DSValidationFactory` accept arbitrary regex patterns as strings; malformed patterns could crash at runtime
- Files: `Sources/LeetPulseDesignSystemState/Validation/DSValidationRule.swift` (line 135), `Sources/LeetPulseDesignSystemState/Validation/DSValidationFactory.swift`
- Current mitigation: None; patterns are evaluated immediately with NSPredicate
- Recommendations: Validate regex patterns at initialization time; consider pre-compiling patterns; add try-catch for NSPredicate evaluation

## Performance Bottlenecks

**Graph Layout Force-Directed Algorithm:**
- Problem: Force-directed layout iterates 50 times through all edges for every graph render
- Files: `Sources/LeetPulseDesignSystemComponents/DSGraphView.swift` (lines 227-280+)
- Cause: O(n²) distance calculations in each iteration; no memoization of previous positions
- Improvement path: Cache layout results; use adaptive iteration count; consider GPU acceleration for large graphs

**Validation Rules Linear Search:**
- Problem: `DSValidator` checks rules sequentially and stops at first invalid rule, but still iterates through array
- Files: `Sources/LeetPulseDesignSystemState/Validation/DSValidator.swift`
- Cause: No early exit optimization for rules that are guaranteed to fail
- Improvement path: Order rules by likelihood of failure; add short-circuit predicates

**GeometryReader in VStack/ZStack:**
- Problem: Multiple GeometryReaders in nested hierarchies (DSGraphView, DSProgressHeader) trigger layout recalculation
- Files: `Sources/LeetPulseDesignSystemComponents/DSGraphView.swift` (line 59), `Sources/LeetPulseDesignSystemComponents/DSProgressHeader.swift`
- Cause: Each GeometryReader blocks view composition; multiple nested ones compound the issue
- Improvement path: Use `@Measurement` for size queries; consider flattening view hierarchy

## Compatibility Issues

**iOS 26 Requirement:**
- Issue: Package.swift specifies iOS(.v26) which doesn't exist yet (as of Feb 2025)
- Files: `Package.swift` (line 10)
- Impact: Package will fail to build on any actual iOS device until this is corrected
- Fix approach: Change to `.iOS(.v16)` or lower depending on actual minimum support requirement

## Test Coverage Gaps

**Graph Visualization Accessibility:**
- What's not tested: No tests for accessible labels on graph edges, nodes, or Canvas-rendered elements
- Files: `Sources/LeetPulseDesignSystemComponents/DSGraphView.swift`, `Sources/LeetPulseDesignSystemComponents/DSTreeGraphView.swift`
- Risk: Graph components may fail VoiceOver navigation; no programmatic way to verify accessibility conformance
- Priority: High - graphs are complex UI that require accessibility testing

**Validation Rule Error Handling:**
- What's not tested: NSPredicate evaluation failures; regex compilation errors
- Files: `Sources/LeetPulseDesignSystemState/Validation/DSValidationRule.swift`
- Risk: Malformed validation patterns crash at runtime with no error recovery
- Priority: High - validation is user-facing

**Layout Edge Cases:**
- What's not tested: GeometryReader behavior with zero-size containers; force-directed layout with disconnected nodes
- Files: `Sources/LeetPulseDesignSystemComponents/DSGraphView.swift` (line 235)
- Risk: Layout algorithm may produce NaN or infinity values; SafeHeight guards prevent crashes but may render incorrectly
- Priority: Medium - uncommon but critical when it occurs

**State Reducer Invariants:**
- What's not tested: Concurrent state mutation; rapid event sequences; invalid state combinations
- Files: `Sources/LeetPulseDesignSystemState/StateMachine.swift`, component reducers
- Risk: StateStore publishes intermediate states; no transaction or batch update support
- Priority: Medium - mostly affects complex multi-component interactions

**Canvas Empty String Handling:**
- What's not tested: Rendering behavior when code is empty in DSConsoleOutput
- Files: `Sources/LeetPulseDesignSystemComponents/DSConsoleOutput.swift` (line 276: substitutes " " for empty lines)
- Risk: Edge case handling not verified; potential visual glitches with all-empty output
- Priority: Low - handled gracefully but not explicitly tested

## Missing Critical Features

**Layout Caching:**
- Problem: Graph layouts are recalculated on every state change even when data hasn't changed
- Blocks: Performance optimization for large graphs; real-time graph exploration features
- Workaround: None available; users must manually manage when to update graphs

**Error Recovery in Validation:**
- Problem: Malformed regex patterns in validation rules fail silently or crash at validation time
- Blocks: Dynamic validation rule creation from external configs; robust error handling
- Workaround: All validation patterns must be hardcoded and pre-tested

---

*Concerns audit: 2026-02-25*
