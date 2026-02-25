# Roadmap: LeetPulseDesignSystem Documentation Update

## Overview

Five documentation files need updating: stale names replaced, a component catalog grown from 25 to 62+, usage examples written for every component, and a changelog entry written last after everything else is verified. The update follows a strict naming dependency chain — README is fixed first because it establishes the canonical module names that all downstream files must match. DEVELOPMENT_GUIDE and VALIDATION follow in parallel. Per-component documentation comes next (the highest-effort work). IOS_IPADOS_ROADMAP is updated once the full component inventory is known. RELEASE_NOTES is written last as a synthesis of all changes.

## Phases

**Phase Numbering:**
- Integer phases (1, 2, 3): Planned milestone work
- Decimal phases (2.1, 2.2): Urgent insertions (marked with INSERTED)

Decimal phases appear between their surrounding integers in numeric order.

- [ ] **Phase 1: README — Naming Foundation and Component Catalog** - Establish canonical names, correct import paths, and expand the component catalog from 25 to 62+ components
- [ ] **Phase 2: Developer Guides — DEVELOPMENT_GUIDE and VALIDATION** - Update module paths and add developer workflow guides for contributors and form-component consumers
- [ ] **Phase 3: Per-Component Documentation — API Surface and Usage Examples** - Write a verified usage example for every public component with Config/State/Event surface
- [ ] **Phase 4: IOS_IPADOS_ROADMAP — Delivery Status** - Reflect current iOS/iPadOS component delivery state based on verified filesystem inventory
- [ ] **Phase 5: RELEASE_NOTES — Changelog Synthesis** - Add a new release entry documenting the rename, branding update, and all new components

## Phase Details

### Phase 1: README — Naming Foundation and Component Catalog
**Goal**: README uses LeetPulseDesignSystem naming everywhere and lists every public component from the filesystem
**Depends on**: Nothing (first phase)
**Requirements**: NAME-01, NAME-02, NAME-03, NAME-04, CATL-01, CATL-02, CATL-03, CATL-04, USAGE-03, USAGE-04, USAGE-06
**Success Criteria** (what must be TRUE):
  1. A developer can copy any import statement from README.md and it compiles without editing — no FocusDesignSystem references exist anywhere in the file (prose, headings, or code blocks)
  2. A developer can find every public DS* component by browsing the README catalog — the catalog count matches `find Sources/ -name "DS*.swift"` filtered to public types
  3. Mobile-specific components are grouped separately and labeled iOS/iPadOS-only so a developer knows immediately they cannot use them on macOS
  4. A developer can follow the theme setup section and wire up DSThemeProvider, light/dark selection, and @Environment(\.dsTheme) access from README alone
  5. The SPM installation block has the correct repository URL and platform requirements (iOS 26, macOS 14) so a developer can integrate the package on the first try
**Plans:** 3 plans

Plans:
- [ ] 01-01-PLAN.md — Rename pass: replace all FocusDesignSystem references, fix file paths, add SPM installation block, add module dependency decision table
- [ ] 01-02-PLAN.md — Component catalog expansion: verify filesystem inventory, write 5-group catalog with mini tables, mark Mobile as iOS/iPadOS
- [ ] 01-03-PLAN.md — Theme and token documentation: concept-first theme setup section, token reference tables for all token groups

### Phase 2: Developer Guides — DEVELOPMENT_GUIDE and VALIDATION
**Goal**: DEVELOPMENT_GUIDE and VALIDATION.md use correct module paths and guide contributors and form-component consumers accurately
**Depends on**: Phase 1
**Requirements**: GUIDE-01, GUIDE-02, GUIDE-03, GUIDE-04, USAGE-05
**Success Criteria** (what must be TRUE):
  1. A contributor following DEVELOPMENT_GUIDE can clone the repo, navigate to Sources/LeetPulseDesignSystem* paths, and add a new component by following the step-by-step walkthrough — no FocusDesignSystem path references remain
  2. A developer can read the state machine guide in DEVELOPMENT_GUIDE and understand the Config/State/Event/Reducer/RenderModel pattern using DSButton as a concrete example
  3. A developer can copy the VALIDATION.md form integration example (DSFormField + DSTextField + DSValidationFactory) and it compiles with `import LeetPulseDesignSystemState` — no stale import path remains
  4. A developer can read the Mobile vs platform-agnostic section and understand when to use DSMobileTokens (static) vs DSTheme (environment-injected) and which components are iOS/iPadOS-only
**Plans**: TBD

Plans:
- [ ] 02-01: DEVELOPMENT_GUIDE rename and path update — replace all FocusDesignSystem module paths, update test target path, add Mobile/ subdirectory section
- [ ] 02-02: DEVELOPMENT_GUIDE guides — add state machine pattern guide (DSButton canonical), import decision table, new component walkthrough
- [ ] 02-03: VALIDATION.md update — fix import path, write verified full form integration example against current DSTextField and DSValidationFactory API

### Phase 3: Per-Component Documentation — API Surface and Usage Examples
**Goal**: Every public DS* component has a verified usage example and documented Config/State/Event surface in README
**Depends on**: Phase 2
**Requirements**: USAGE-01, USAGE-02, GUIDE-05, GUIDE-06, GUIDE-07
**Success Criteria** (what must be TRUE):
  1. A developer can find any public component in the README, copy its Swift snippet, and the example compiles — every snippet is derived from the actual `public init` signature in source, not from memory
  2. A developer can read the Config/State/Event table for any component and know exactly what properties, states, and events are available without opening the source file
  3. A developer can use DSGraphView, DSBarChart, DSLineChart, and DSCalendarGrid after reading their sections — the non-obvious data shape requirements are explicitly documented
  4. A developer can use the Okabe-Ito visualization palette by reading the DSVizColors section — all eight color names, semantic aliases, and light/dark variants are listed
  5. A developer consulting the accessibility notes knows which components have known Canvas rendering limitations (DSGraphView, DSTreeGraphView) and can make an informed decision about using them
**Plans**: TBD

Plans:
- [ ] 03-01: Primitives, Form Controls, Navigation — verified snippets and API surface for each component group
- [ ] 03-02: Feedback, Visualization, Mobile-specific — verified snippets with iOS/iPadOS-only notes; DSVizColors palette documentation
- [ ] 03-03: Accessibility notes pass — document known Canvas rendering limitations for DSGraphView and DSTreeGraphView; review all components for accessibility caveats

### Phase 4: IOS_IPADOS_ROADMAP — Delivery Status
**Goal**: IOS_IPADOS_ROADMAP accurately reflects which phases are shipped and which components are available
**Depends on**: Phase 3
**Requirements**: REL-02
**Success Criteria** (what must be TRUE):
  1. A platform lead reading IOS_IPADOS_ROADMAP can trust which phases are marked shipped — every "shipped" phase maps only to components verified to exist in the filesystem from Phase 3's audit
  2. All currently available Mobile/ components are listed under their corresponding roadmap phase so a developer knows what is usable today vs planned
**Plans**: TBD

Plans:
- [ ] 04-01: Cross-reference roadmap phases against Phase 3 component inventory; mark completed phases as shipped; list available mobile components per phase

### Phase 5: RELEASE_NOTES — Changelog Synthesis
**Goal**: RELEASE_NOTES has a new entry documenting all changes since v1.0.1, with the historical entry preserved unchanged
**Depends on**: Phase 4
**Requirements**: REL-01
**Success Criteria** (what must be TRUE):
  1. A developer reading RELEASE_NOTES sees a new entry (v1.1.0 or appropriate version) that covers: the rename from FocusDesignSystem to LeetPulseDesignSystem, purple+cyan branding update, all new components added since v1.0.1, and the DSTheme breaking change (vizColors and gradients now required)
  2. The existing v1.0.1 entry is byte-for-byte identical to the current RELEASE_NOTES content — no retroactive find-and-replace has altered the historical record
**Plans**: TBD

Plans:
- [ ] 05-01: Write new release entry for the rename milestone; verify v1.0.1 entry is unmodified

## Progress

**Execution Order:**
Phases execute in numeric order: 1 → 2 → 3 → 4 → 5

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. README — Naming Foundation and Component Catalog | 0/3 | Not started | - |
| 2. Developer Guides — DEVELOPMENT_GUIDE and VALIDATION | 0/3 | Not started | - |
| 3. Per-Component Documentation — API Surface and Usage Examples | 0/3 | Not started | - |
| 4. IOS_IPADOS_ROADMAP — Delivery Status | 0/1 | Not started | - |
| 5. RELEASE_NOTES — Changelog Synthesis | 0/1 | Not started | - |
