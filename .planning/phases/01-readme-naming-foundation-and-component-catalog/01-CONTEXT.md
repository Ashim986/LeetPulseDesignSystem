# Phase 1: README — Naming Foundation and Component Catalog - Context

**Gathered:** 2026-02-25
**Status:** Ready for planning

<domain>
## Phase Boundary

Update README.md to replace all FocusDesignSystem references with LeetPulseDesignSystem (naming, headings, code blocks, file paths), expand the component catalog from 25 to 62+ components derived from the filesystem, and document theme setup and module dependencies. No new documentation files created — scope is the existing README.md only.

</domain>

<decisions>
## Implementation Decisions

### Catalog organization
- 5 groups: Primitives, Form Controls, Navigation, Feedback, Visualization
- No separate Mobile-specific group — mobile components integrated into their functional group with an inline (iOS/iPadOS) badge
- Each group has a one-liner intro explaining when to reach for it
- Components listed alphabetically within each group
- Claude's discretion on whether to include a total component count summary at the top

### Component listing depth
- Mini table format per group with columns: Name, Description, Platform
- Platform column values: Claude decides clearest labeling (e.g., "All" vs "macOS, iOS/iPadOS")
- One-liner descriptions: Claude decides whether to pull from source doc comments or write fresh for README audience

### Theme & module documentation
- Theme setup section: concept-first approach — explain what the theme system does, then show code (DSThemeProvider, light/dark selection, @Environment(\.dsTheme))
- Module dependency explanation: brief paragraph intro, then a decision table ("If you need X, import Y")
- Token reference (colors, spacing, radii, typography): Claude decides full table vs summary based on actual token count
- SPM installation block includes minimum deployment targets (iOS 26, macOS 14) alongside the repository URL

### Rename presentation
- Clean scrub — zero mentions of FocusDesignSystem anywhere in README
- No brand color references (purple+cyan) — just use the LeetPulseDesignSystem name
- All headings containing FocusDesignSystem renamed to LeetPulseDesignSystem
- Every code block (import statements, file paths) verified against actual filesystem — not just find-and-replace

### Claude's Discretion
- Total component count at top of catalog (yes/no)
- Platform column labeling format
- Component description source (doc comments vs fresh-written)
- Token reference detail level (full table vs summary with examples)

</decisions>

<specifics>
## Specific Ideas

No specific requirements — open to standard approaches

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>

---

*Phase: 01-readme-naming-foundation-and-component-catalog*
*Context gathered: 2026-02-25*
