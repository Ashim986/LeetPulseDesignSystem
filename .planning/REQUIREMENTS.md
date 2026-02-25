# Requirements: LeetPulseDesignSystem Documentation Update

**Defined:** 2026-02-25
**Core Value:** A teammate opening the repo can understand how to use any design system component by reading the docs — no guesswork, no stale references.

## v1 Requirements

Requirements for this documentation update milestone. Each maps to roadmap phases.

### Naming Accuracy

- [ ] **NAME-01**: All doc files use `LeetPulseDesignSystem` — zero occurrences of `FocusDesignSystem` in prose, headings, and code blocks
- [ ] **NAME-02**: All import paths in code examples use correct module names (`LeetPulseDesignSystemCore`, `LeetPulseDesignSystemState`, `LeetPulseDesignSystemComponents`)
- [ ] **NAME-03**: All file path references match actual filesystem paths (no `Sources/FocusDesignSystem*` references)
- [ ] **NAME-04**: SPM installation instructions use correct package name and repository URL

### Component Catalog

- [ ] **CATL-01**: README lists all public `DS*` components from the filesystem (62+ components, not from memory)
- [ ] **CATL-02**: Components organized into logical groups: Primitives, Form Controls, Navigation, Feedback, Visualization, Mobile-specific
- [ ] **CATL-03**: Each group has a one-line description of when to reach for it
- [ ] **CATL-04**: Mobile-specific components clearly marked as iOS/iPadOS-only

### Usage Documentation

- [ ] **USAGE-01**: Every public component has at least one copy-pasteable Swift usage example verified against actual `public init` signature
- [ ] **USAGE-02**: Config/State/Event API surface documented per component (what properties Config accepts, what State holds, what Events exist)
- [ ] **USAGE-03**: Theme setup instructions cover `DSThemeProvider`, light/dark selection, and `@Environment(\.dsTheme)` access
- [ ] **USAGE-04**: Theming token reference lists all token names (colors, spacing, radii, typography) developers can use in custom components
- [ ] **USAGE-05**: Validation framework usage shows correct import (`LeetPulseDesignSystemState`) and full form integration example (`DSFormField` + `DSTextField` + `DSValidationFactory`)
- [ ] **USAGE-06**: Module dependency explanation clarifies which module to import for which use case (Core vs State vs Components vs umbrella)

### Developer Guides

- [ ] **GUIDE-01**: State machine pattern guide using DSButton as canonical example (Config/State/Event/Reducer/RenderModel)
- [ ] **GUIDE-02**: "When to use which import" decision table (umbrella vs individual modules, compile-time tradeoffs)
- [ ] **GUIDE-03**: "How to add a new component" step-by-step walkthrough using the established pattern
- [ ] **GUIDE-04**: Mobile vs platform-agnostic component distinction: when to use each, `DSMobileTokens` vs `DSTheme`
- [ ] **GUIDE-05**: Visualization component usage guide covering DSGraphView, DSBarChart, DSLineChart, DSCalendarGrid data shape requirements
- [ ] **GUIDE-06**: DSVizColors (Okabe-Ito palette) documentation: eight color names, semantic aliases, light/dark variants
- [ ] **GUIDE-07**: Accessibility notes per component, including known Canvas rendering limitations in DSGraphView and DSTreeGraphView

### Release & Status

- [ ] **REL-01**: RELEASE_NOTES has new entry documenting: rename, purple+cyan branding, new components, DSTheme changes — existing v1.0.1 entry preserved unchanged
- [ ] **REL-02**: IOS_IPADOS_ROADMAP reflects current delivery state: completed phases marked shipped, available mobile components listed

## v2 Requirements

Deferred to future milestone. Tracked but not in current roadmap.

### DocC Integration

- **DOCC-01**: Triple-slash doc comments added to all public types and methods
- **DOCC-02**: DocC catalog (`.docc` bundle) created for the package
- **DOCC-03**: GitHub Actions CI pipeline generates and deploys DocC to GitHub Pages

### Visual Documentation

- **VIS-01**: Component screenshots/previews embedded in documentation
- **VIS-02**: Interactive Xcode `#Preview` documentation expanded

## Out of Scope

| Feature | Reason |
|---------|--------|
| DocC integration | Requires source code changes — separate engineering effort |
| Screenshots or visual previews | Requires running the app — out of scope for text docs |
| Auto-generated API reference | Requires tooling changes to Swift source |
| New documentation files | Scope is updating 5 existing files, not creating new ones |
| CONTRIBUTING.md | Not requested — DEVELOPMENT_GUIDE.md covers contributor workflow |
| Per-component changelogs | Maintenance overhead without clear benefit at internal team scale |
| Migration guide | API did not change — only the package name changed |
| Restructuring doc locations | PROJECT.md constraint: keep existing file locations |

## Traceability

Which phases cover which requirements. Updated during roadmap creation.

| Requirement | Phase | Status |
|-------------|-------|--------|
| NAME-01 | Phase 1 | Pending |
| NAME-02 | Phase 1 | Pending |
| NAME-03 | Phase 1 | Pending |
| NAME-04 | Phase 1 | Pending |
| CATL-01 | Phase 1 | Pending |
| CATL-02 | Phase 1 | Pending |
| CATL-03 | Phase 1 | Pending |
| CATL-04 | Phase 1 | Pending |
| USAGE-03 | Phase 1 | Pending |
| USAGE-04 | Phase 1 | Pending |
| USAGE-06 | Phase 1 | Pending |
| GUIDE-01 | Phase 2 | Pending |
| GUIDE-02 | Phase 2 | Pending |
| GUIDE-03 | Phase 2 | Pending |
| GUIDE-04 | Phase 2 | Pending |
| USAGE-05 | Phase 2 | Pending |
| USAGE-01 | Phase 3 | Pending |
| USAGE-02 | Phase 3 | Pending |
| GUIDE-05 | Phase 3 | Pending |
| GUIDE-06 | Phase 3 | Pending |
| GUIDE-07 | Phase 3 | Pending |
| REL-02 | Phase 4 | Pending |
| REL-01 | Phase 5 | Pending |

**Coverage:**
- v1 requirements: 23 total
- Mapped to phases: 23
- Unmapped: 0

---
*Requirements defined: 2026-02-25*
*Last updated: 2026-02-25 after roadmap creation*
