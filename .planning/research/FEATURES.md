# Features Research: LeetPulseDesignSystem Documentation Update

**Research Date:** 2026-02-25
**Research Type:** Project Research — Features dimension
**Question:** What documentation features do Swift design system packages typically have? What's table stakes vs differentiating?
**Consumer:** Requirements definition for the documentation update milestone

---

## Context Summary

LeetPulseDesignSystem is a multi-library Swift Package (SPM) with 62+ SwiftUI components split across four modules: Core (tokens/theme), State (Redux-style state + validation), Components (62+ UI components), and an umbrella re-export. Target audience is an internal development team. All existing docs still say "FocusDesignSystem" everywhere. The ask is markdown-only doc updates — no DocC, no screenshots, no code changes.

---

## Feature Categories

### Table Stakes
*Without these, a developer cannot actually use the design system. Absence of any one blocks adoption.*

| Feature | Description | Complexity | Dependencies |
|---------|-------------|------------|--------------|
| **Correct package name and import paths** | Every code snippet uses `import LeetPulseDesignSystem` (or the relevant sub-module). Every module reference says `LeetPulseDesignSystemCore`, not `FocusDesignSystemCore`. | Low — find-and-replace across all .md files | None |
| **Complete component catalog** | A scannable list of all 62+ components so a developer can discover what exists. Currently missing ~30+ components, especially all Mobile/ components (DSProblemCard, DSFocusTimeCard, DSCodeViewer, DSLineChart, DSBarChart, DSCalendarGrid, etc.). Without it, developers re-invent components that already exist. | Low — enumeration work, no design decisions | Accurate codebase audit (STRUCTURE.md has this) |
| **Minimal working usage example per component** | At least one copy-pasteable Swift code snippet per component showing the minimum required init call. Internal developers cannot start using a component they've never seen without a concrete example. | Medium — 62+ components, each needs at least one verified snippet | Correct import paths (above) |
| **Theme setup instructions** | How to wrap the app root with `DSThemeProvider`, select light vs dark, and access `@Environment(\.dsTheme)`. This is the entry point for the entire system. Without it, nothing renders with the right tokens. | Low — single section, the pattern is stable | None |
| **Module dependency explanation** | Which module to import for what: Core for tokens, State for validation, Components for UI, the umbrella for everything. Developers adding SPM dependencies need to know whether to add one target or four. | Low — informational, already documented in ARCHITECTURE.md | None |
| **SPM installation instructions** | How to add the package via Xcode "Add Packages" and via Package.swift `dependencies`. Correct repository URL. | Low | Correct package name |
| **Component Config/State/Event API surface** | For each component, what properties does `Config` accept, what does `State` hold, what events does `Event` expose. Developers cannot configure components without this. DSButton alone has style (primary/secondary/ghost/destructive), size (small/medium/large), icon, iconPosition, isFullWidth. | High — 62+ components each have distinct APIs, must be accurate | None — but errors here are high-cost |
| **Theming token reference** | What token names exist: `theme.colors.primary`, `theme.colors.danger`, `theme.spacing.md`, `theme.radii.md`, etc. Developers building custom components need these names to stay on-system. | Medium — token list is finite and stable, just needs to be written |  Core source audit |
| **Validation framework usage** | How to use `DSValidationFactory`, `DSValidator`, `DSValidationRule`, and wire results to `DSTextField` / `DSFormField`. The current VALIDATION.md example uses the old import path. This is not discoverable from component signatures alone. | Low — existing guide just needs import fix + accuracy check | Correct import paths |
| **Current release notes / changelog** | What changed: rename from FocusDesignSystem, new color palette (purple+cyan), new components added in recent commits. Developers need to know what version they're integrating and what's new. | Low — factual summary of known changes | None |

---

### Differentiators
*These make the docs noticeably better than the minimum. A developer will move faster and make fewer mistakes with these present.*

| Feature | Description | Complexity | Dependencies |
|---------|-------------|------------|--------------|
| **Component grouping with rationale** | Organize the 62+ components into logical groups (Primitives / Form Controls / Navigation / Feedback / Visualization / Mobile-specific) with a sentence on when to reach for each group. Helps new team members build a mental model without reading all 62 files. | Low — organizational, one table or list | Complete component catalog |
| **State machine pattern guide** | A dedicated section explaining the Config / State / Event / Reducer / RenderModel pattern that every component follows, using DSButton as the canonical example. Once a developer understands the pattern once, all 62 components become predictable. Currently buried in DEVELOPMENT_GUIDE. | Low — extract and expand from existing CONVENTIONS.md content | None |
| **"When to use which import" decision table** | `import LeetPulseDesignSystem` vs `import LeetPulseDesignSystemComponents` vs `import LeetPulseDesignSystemCore` — when each is appropriate, performance/compile-time tradeoffs. The umbrella uses `@_exported` so some subtleties exist. | Low — one table | Module dependency explanation |
| **Validation integration patterns** | Side-by-side examples showing onBlur validation vs onChange, and how to wire `DSFormField` + `DSTextField` + `DSValidationFactory` together. The current VALIDATION.md shows the validator in isolation but not the full form integration. | Medium — requires accurate multi-component example | Working usage examples, correct imports |
| **Theme customization guide** | How to create a custom `DSTheme` beyond `.light` / `.dark`, what token overrides are available, and `DSMobileTokens` for mobile-specific token variants. Relevant for any team that wants to white-label or extend the palette. | Medium — needs to reflect actual DSTheme struct fields | Theming token reference |
| **Component primitive vs mobile-specific distinction** | Explain the Mobile/ subdirectory pattern: what makes a component mobile-specific (DSProblemCard, DSFocusTimeCard, DSHeaderBar), when to use primitives vs mobile components, and how they relate. New team members waste time using platform-specific components cross-platform. | Low — one section, explanatory | Complete component catalog |
| **Visualization component usage guide** | DSGraphView, DSTreeGraphView, DSLineChart, DSBarChart, DSCalendarGrid, DSConsoleOutput, DSCodeViewer are non-obvious to initialize. A focused section covering data shape requirements (adjacency arrays, DSTreeNode, DSTree) prevents repeated Slack questions. | Medium — niche but high-confusion components | Working usage examples |
| **Accessibility notes per component** | DSButton, DSFormField, DSTextField have accessibility considerations. DSGraphView and DSTreeGraphView use Canvas rendering with known accessibility gaps (CONCERNS.md). Documenting known limitations prevents team members from shipping inaccessible features unknowingly. | Medium — requires reading component source to identify considerations | Component source review |
| **"How to add a new component" walkthrough** | Step-by-step using the Config/State/Event/Reducer/RenderModel/View pattern, referencing DSButton as the template. DEVELOPMENT_GUIDE.md has a checklist but no walkthrough. Reduces onboarding time for contributors. | Low — narrative expansion of existing checklist | State machine pattern guide |
| **Colorblind-safe visualization palette documentation** | DSVizColors (Okabe-Ito palette) with the eight color names, semantic aliases (highlight, selected, error), and guidance on light/dark variants. Data visualization work requires this; it is otherwise undiscoverable. | Low — token enumeration | Theming token reference |

---

### Anti-Features
*Things to deliberately NOT build as part of this documentation update. Each has a reason.*

| Anti-Feature | Why Not | Alternative |
|-------------|---------|-------------|
| **DocC integration** | Explicitly out of scope per PROJECT.md. Separate engineering effort requiring changes to Swift source (doc comments, DocC catalog files). Cannot be done in markdown-only update. | Future milestone |
| **Auto-generated API reference** | Same constraint as DocC — requires tooling and source changes. Text-based usage guides serve the internal team better than raw API dumps anyway. | Usage examples in markdown |
| **Screenshots or visual previews** | Requires running the app and capturing output. Out of scope per PROJECT.md. DSSampleScreens.swift exists in source for interactive preview. | Reference DSSampleScreens.swift |
| **Migration guide (old API → new API)** | This is a rename correction, not an API change. The API itself didn't change when FocusDesignSystem became LeetPulseDesignSystem. A migration guide implies breaking changes that don't exist. | Just fix the names inline |
| **Versioning or changelog per component** | Internal team, single repo. Component-level changelogs add maintenance overhead with no clear audience benefit at this scale. | Single RELEASE_NOTES.md with recent changes |
| **Restructuring doc locations** | PROJECT.md explicitly calls out: keep existing file locations (README.md, Docs/*.md, RELEASE_NOTES.md). Structural changes break existing links and bookmarks for zero user benefit during a name-fix pass. | Update in-place |
| **New documentation files beyond existing ones** | Scope is to update the five existing files. Adding new files (COMPONENTS.md, THEMING.md, etc.) is scope creep. Differentiating content should be folded into the existing files. | Expand existing sections |
| **Tutorials or guided projects** | Internal team already has a working app that integrates the DS. Step-by-step tutorials from scratch waste space better used for reference. | "Minimal working example" per component |
| **Contribution guidelines (CONTRIBUTING.md)** | Out of scope. Not listed in PROJECT.md requirements. Internal team can use DEVELOPMENT_GUIDE.md for contributor workflow. | Existing DEVELOPMENT_GUIDE.md covers this |

---

## Feature Dependency Map

The features form a clear dependency order. Anything downstream cannot be accurate until its upstream is resolved:

```
1. Correct package name + import paths (BLOCKER — everything else inherits from this)
   └── 2. Complete component catalog
        ├── 3. Minimal usage example per component
        │    └── 5. Validation integration patterns
        │    └── 6. Visualization component usage guide
        └── 4. Config/State/Event API surface documentation
   └── 7. Theme setup instructions
        └── 8. Theming token reference
             └── 9. Theme customization guide
             └── 10. Colorblind-safe visualization palette docs
   └── 11. Module dependency explanation
        └── 12. "When to use which import" decision table
   └── 13. State machine pattern guide
        └── 14. "How to add a new component" walkthrough
   └── 15. Current release notes / changelog
```

---

## Complexity Estimates

| Feature | Effort Estimate | Risk |
|---------|----------------|------|
| Correct package name + import paths | Half day — mechanical find-replace | Low — deterministic |
| Complete component catalog | Half day — enumeration from STRUCTURE.md | Low — factual |
| Minimal usage example per component | 2–3 days — must verify each example against source | Medium — accuracy risk, 62+ components |
| Config/State/Event API surface | 2–3 days — must read each component file | Medium — accuracy risk, high volume |
| Theme setup + token reference | Half day — token list is finite and stable | Low |
| Validation framework | 2 hours — fix imports, add one full form example | Low |
| State machine pattern guide | 1–2 hours — expand from existing conventions doc | Low |
| Visualization component guide | 2–3 hours — niche but non-obvious APIs | Medium |
| Release notes update | 1 hour — known commits, factual | Low |
| All differentiator sections combined | 1 day — once table stakes are done | Low |

---

## Key Insight for Requirements

The documentation deficit has two distinct problems that should not be conflated:

**Problem A — Accuracy:** Existing docs are wrong (wrong names, wrong imports). This is table stakes. It must be fixed before any other work is valuable. A developer who copies a code snippet with `import FocusDesignSystemCore` gets a compile error and loses trust immediately.

**Problem B — Coverage:** Existing docs are incomplete (30+ undocumented components, no mobile component docs, no visualization guide). This is the bigger long-term value gap but it is not a blocker in the same way — developers can read source code for undocumented components, they cannot copy wrong import paths.

Fix accuracy first. Then coverage. Then differentiators.

---

*Research by: project-researcher agent, 2026-02-25*
