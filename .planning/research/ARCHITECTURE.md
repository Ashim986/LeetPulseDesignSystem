# Architecture Research: Swift Design System Documentation Structure

**Research Date:** 2026-02-25
**Research Type:** Project Research — Architecture dimension
**Milestone:** Documentation update for LeetPulseDesignSystem (62+ SwiftUI components, 4 modules)
**Question:** How are Swift design system documentation sets typically structured? What are the major sections and how do they relate?

---

## Summary

Swift design system documentation follows a layered, audience-driven structure. The major sections move from "what is this and how do I get started" (README) through "how do I develop within it" (DEVELOPMENT_GUIDE) to "how do I use specific subsystems" (VALIDATION, ROADMAP) and "what has changed" (RELEASE_NOTES). Each layer depends on the one above it for naming, import paths, and architectural framing. This creates a clear update dependency chain: README must be updated first because every other file inherits its package name, module names, and foundational framing.

---

## Documentation Organization Patterns

### Pattern 1: Audience-Segmented Top-Level Files

Effective Swift package documentation separates concerns by reader role:

| File | Primary Audience | Core Purpose |
|------|-----------------|--------------|
| `README.md` | All consumers (first contact) | Package identity, quickstart, component catalog, import examples |
| `Docs/DEVELOPMENT_GUIDE.md` | Contributors and integrators | Repo structure, module names, component authoring workflow, release process |
| `Docs/VALIDATION.md` | Consumers using form/input components | Subsystem API reference with import paths and usage examples |
| `Docs/IOS_IPADOS_ROADMAP.md` | Platform leads and integrators | Phased delivery status, platform-specific design direction |
| `RELEASE_NOTES.md` | All (versioned history) | Changelog with component additions, renames, and breaking changes |

This is the standard pattern for Swift packages distributed via SPM: README as entry point, `Docs/` as the extended reference, release notes for versioning.

### Pattern 2: Module-First Information Architecture

For packages with multiple library targets (Core, State, Components, umbrella), documentation is structured around the module dependency graph. The same layering used in code (Core -> State -> Components -> Umbrella) is reflected in docs:

1. **Token layer** is described first — it is the vocabulary everything else uses (colors, typography, spacing, theme injection).
2. **State/infrastructure layer** is described next — how components manage behavior (ReducerProtocol, StateStore, validation framework).
3. **Component layer** is described with the most detail — the catalog, usage patterns, Config/State/Event/RenderModel structure.
4. **Integration/umbrella layer** is described last — single-import usage, SPM integration instructions.

The LeetPulseDesignSystem structure already follows this pattern implicitly. Making it explicit in documentation ensures readers can navigate from concept to implementation.

### Pattern 3: Component Catalog with Grouped Categories

Component catalogs in well-structured Swift design system docs group components by function rather than listing alphabetically. For LeetPulseDesignSystem, the grouping that matches the actual codebase organization is:

**Group 1: Primitives (cross-platform, in root Components directory)**
- Typography: DSText
- Buttons: DSButton, DSActionButton, DSIconButton
- Surfaces: DSCard
- Badges: DSBadge, DSPointerBadge, DSBadge+Difficulty
- Form controls: DSToggle, DSSegmentedControl, DSSelect, DSPicker
- Text inputs: DSTextField, DSTextArea, DSTextValidation, DSFormField
- Headers: DSHeader, DSCompactHeaderBar, DSSectionHeader, DSProgressHeader
- Navigation: DSTabBar, DSSidebar, DSNavigationModels, DSScaffolds
- Feedback: DSToast, DSAlert, DSEmptyState
- Visualization primitives: DSArrow, DSCurvedArrow, DSBubble, DSPointerBadge, DSGraphView, DSTreeGraphView
- Status/display: DSStatusCard, DSExpandableText, DSConsoleOutput, DSImage, DSMetricCard, DSListRow, DSSectionHeader, DSProgressRing

**Group 2: Mobile-specific (in `Mobile/` subdirectory)**
- Content cards: DSProblemCard, DSSurfaceCard, DSFocusTimeCard, DSDailyGoalCard
- Navigation: DSHeaderBar, DSSidebarNav, DSBottomTabBar
- Charts: DSLineChart, DSBarChart
- Data display: DSCalendarGrid, DSMetricCardView, DSStreakBadge
- Code/focus: DSCodeViewer, DSTimerRing
- Tasks: DSTaskRow, DSScheduleRow
- Controls: DSSearchBar, DSSettingsRow, DSPomodoroSegmentedControl, DSSignOutButton, DSStartFocusCTA

### Pattern 4: Code Examples Scoped to Correct Import Path

Swift design system docs that age well make import paths explicit and accurate. Every code snippet must specify which module to import. The correct import path hierarchy for this package is:

```swift
// Consume everything (recommended for app consumers)
import LeetPulseDesignSystem

// Or import individual layers
import LeetPulseDesignSystemCore    // tokens and theme only
import LeetPulseDesignSystemState   // state management and validation only
import LeetPulseDesignSystemComponents  // components (requires Core + State)
```

The old docs use `import FocusDesignSystem`, `import FocusDesignSystemState`, etc. — every code example in every doc file carries this stale reference. Any doc file containing a code block is affected.

---

## How Doc Files Reference Each Other

### Reference Graph (current state, stale)

```
README.md
  ├── references Docs/IOS_IPADOS_ROADMAP.md       ("iOS + iPadOS roadmap")
  ├── references Docs/DEVELOPMENT_GUIDE.md         ("Development guide")
  ├── references Sources/FocusDesignSystemComponents/Examples/DSSampleScreens.swift
  └── references Docs/VALIDATION.md                ("Validation framework")

Docs/DEVELOPMENT_GUIDE.md
  └── references Tests/FocusDesignSystemComponentsTests  (test target path)

Docs/VALIDATION.md
  └── no outbound references (self-contained)

Docs/IOS_IPADOS_ROADMAP.md
  └── no outbound references (self-contained)

RELEASE_NOTES.md
  └── no outbound references (self-contained)
```

### Reference Graph (target state, updated)

```
README.md
  ├── references Docs/IOS_IPADOS_ROADMAP.md
  ├── references Docs/DEVELOPMENT_GUIDE.md
  ├── references Sources/LeetPulseDesignSystemComponents/Examples/DSSampleScreens.swift
  └── references Docs/VALIDATION.md

Docs/DEVELOPMENT_GUIDE.md
  ├── references Sources/LeetPulseDesignSystemCore/     (token layer)
  ├── references Sources/LeetPulseDesignSystemState/    (state layer)
  ├── references Sources/LeetPulseDesignSystemComponents/ (components layer)
  └── references Tests/LeetPulseDesignSystemComponentsTests/  (test target)

Docs/VALIDATION.md
  └── import LeetPulseDesignSystemState               (module path in code examples)

Docs/IOS_IPADOS_ROADMAP.md
  └── no outbound references (platform status doc)

RELEASE_NOTES.md
  └── no outbound references (changelog)
```

### Cross-Reference Rules

1. **README is the hub.** It links out to all `Docs/` files and the Examples source. `Docs/` files do not link back to README — they are leaf documents.
2. **Docs files do not cross-link each other.** VALIDATION.md does not reference DEVELOPMENT_GUIDE.md and vice versa. This keeps each doc file independently readable.
3. **All code examples must use the umbrella import** unless demonstrating layer isolation. Using `import LeetPulseDesignSystem` in README examples prevents breakage if internal module structure changes.
4. **RELEASE_NOTES is standalone.** It documents history and does not reference current module paths or other doc files.

---

## Suggested Update Order (Dependency Chain)

The update order is determined by two dependency types: (A) naming dependencies — a file that establishes the canonical name that downstream files must copy, and (B) content dependencies — a file whose content must be accurate before another file can be verified.

### Tier 1: Foundation (update first, no upstream dependencies)

**`README.md`** must be updated first.

Rationale:
- It is the authoritative source for: package name, module names, import paths, component catalog, and quickstart examples.
- DEVELOPMENT_GUIDE, VALIDATION, and IOS_IPADOS_ROADMAP all describe sub-aspects of what README introduces. If README's naming is stale, every doc file that inherits from it is also stale by definition.
- It is the most frequently read file — fixing it provides the fastest visible improvement.

Changes needed in README.md:
- Replace all "FocusDesignSystem" with "LeetPulseDesignSystem" (package name, module names, import paths)
- Update `Sources/FocusDesignSystemComponents/Examples/DSSampleScreens.swift` path to `Sources/LeetPulseDesignSystemComponents/Examples/DSSampleScreens.swift`
- Expand component catalog from 26 listed components to the full 62+ (add all Mobile/ components and new additions: DSStatusCard, DSExpandableText, DSActionButton, DSIconButton, DSCompactHeaderBar, DSProgressHeader, DSImage, DSConsoleOutput, DSPicker, DSCodeViewer, DSBarChart, DSLineChart, DSStreakBadge, DSTimerRing, DSCalendarGrid, DSProblemCard, DSSurfaceCard, DSFocusTimeCard, DSDailyGoalCard, DSHeaderBar, DSSidebarNav, DSBottomTabBar, DSSearchBar, DSSettingsRow, DSMetricCardView, DSStartFocusCTA, DSTaskRow, DSScheduleRow, DSPomodoroSegmentedControl, DSSignOutButton, DSBadge+Difficulty)
- Update package structure section to reflect 4-module layout
- Update github repo URL if it changed (currently references `https://github.com/Ashim986/DSFocusFlow`)

### Tier 2: Developer Reference (update after README)

**`Docs/DEVELOPMENT_GUIDE.md`** depends on README having the correct module names.

Rationale:
- References `Sources/FocusDesignSystemCore`, `Sources/FocusDesignSystemState`, `Sources/FocusDesignSystemComponents` — all paths must become `LeetPulseDesignSystem*`.
- References `Tests/FocusDesignSystemComponentsTests` — must become `LeetPulseDesignSystemComponentsTests`.
- Adding new component guidance (how to add mobile-specific components) would make it substantially more useful.

Changes needed in DEVELOPMENT_GUIDE.md:
- Rename all 4 module paths (FocusDesignSystem* -> LeetPulseDesignSystem*)
- Add section on Mobile/ subdirectory convention for mobile-specific components
- Update "Adding New Components" section to reference the `LeetPulseDesignSystemComponents` target

### Tier 3: Subsystem Reference (update after DEVELOPMENT_GUIDE)

**`Docs/VALIDATION.md`** depends on correct module name for import path.

Rationale:
- Contains `import FocusDesignSystemState` in code examples.
- The validation framework itself has not changed (same rules, same types, same API). Only the import path changes.
- This is the simplest update: a targeted find-and-replace of the module name in code blocks.

Changes needed in VALIDATION.md:
- Replace `import FocusDesignSystemState` with `import LeetPulseDesignSystemState` (or `import LeetPulseDesignSystem` for simplicity)
- Verify the DSTextField usage example still matches current DSTextField API

### Tier 4: Status Documents (update after subsystem docs)

**`Docs/IOS_IPADOS_ROADMAP.md`** is a status/planning document with no import paths.

Rationale:
- Does not contain module names or import paths — it is not broken by the rename.
- However, it describes "Deliverables By Phase" which should reflect what has already shipped vs. what remains. The roadmap was written prospectively; several phases (token palette, navigation, core components, primitives, mobile scaffold) are now complete.
- Update priority is lower than naming fixes because it is accuracy drift rather than broken references.

Changes needed in IOS_IPADOS_ROADMAP.md:
- Mark completed phases as shipped (phases 1-7 appear delivered based on component catalog)
- Note mobile-specific components now available (DSProblemCard, DSTimerRing, DSCalendarGrid, etc.)
- Update "Deliverables By Phase" to reflect current state vs. future state

### Tier 5: Changelog (update last)

**`RELEASE_NOTES.md`** is written after all other updates are confirmed accurate.

Rationale:
- Release notes document what has changed relative to prior versions. The content of release notes depends on having an accurate picture of what is now in the package.
- The current RELEASE_NOTES.md only covers version 1.0.1 with the original component set.
- New version entry should summarize: rename from FocusDesignSystem to LeetPulseDesignSystem, purple+cyan branding update, new components (DSStatusCard, DSExpandableText, DSBadge+Difficulty, and all Mobile/ components).

Changes needed in RELEASE_NOTES.md:
- Add new version entry (1.1.0 or equivalent) documenting the rename and additions
- Keep existing 1.0.1 entry intact for historical accuracy

---

## Update Order Summary

```
Update Order:
1. README.md              -- establishes canonical names; blocks all downstream accuracy
2. DEVELOPMENT_GUIDE.md   -- updates module paths; depends on README naming
3. VALIDATION.md          -- updates import in code examples; depends on module name being settled
4. IOS_IPADOS_ROADMAP.md  -- updates delivery status; no naming dependency but benefits from docs being stabilized first
5. RELEASE_NOTES.md       -- documents all changes made in steps 1-4; written last
```

No file can be considered "done" until README is done, because README carries the ground-truth naming that all other files must match.

---

## Implications for Roadmap Phase Structure

1. **Phase 1 must deliver README.md in full.** It is the blocking dependency for all other doc files. Partial README updates should not be considered complete.
2. **DEVELOPMENT_GUIDE and VALIDATION can be parallelized** after README is locked, since they do not reference each other.
3. **IOS_IPADOS_ROADMAP can be updated independently** — it has no naming dependency. It could be updated in the same phase as DEVELOPMENT_GUIDE for efficiency.
4. **RELEASE_NOTES belongs in its own final phase** as a synthesis step that summarizes everything else.
5. **Component catalog expansion in README** is the highest-effort single task: 26 listed components -> 62+ requires accurate description of every Mobile/ component, which requires reading the source files.

---

## Quality Gate Check

- [x] Documentation structure patterns clearly defined — Five-file structure with audience segmentation and module-first hierarchy described above.
- [x] Cross-referencing approach explicit — Reference graph documented for current state and target state; four cross-reference rules stated.
- [x] Update order implications noted — Five-tier dependency chain with rationale for each tier; phase structure implications in final section.

---

*Research produced: 2026-02-25*
