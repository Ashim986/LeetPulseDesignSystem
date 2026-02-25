# Domain Pitfalls: Design System Documentation Updates

**Domain:** Design system documentation refresh (rename + missing components)
**Project:** LeetPulseDesignSystem (renamed from FocusDesignSystem)
**Researched:** 2026-02-25
**Confidence:** HIGH — findings are grounded in direct codebase inspection, not assumptions

---

## Critical Pitfalls

Mistakes that cause developers to ship broken integrations or create new stale docs.

---

### Pitfall 1: Partial Rename — Updating Display Names but Missing Import Paths

**What goes wrong:**
The human eye is drawn to headings and prose. A writer updates "FocusDesignSystem" in titles and descriptions but misses import statements inside code blocks. The result: docs look updated, but every code example still fails to compile.

**Evidence in this codebase:**
README.md currently has 9 occurrences of `FocusDesignSystem`. Two of them are inside Swift `import` statements inside fenced code blocks:
```
import FocusDesignSystem
```
The actual umbrella module is now `LeetPulseDesignSystem` (confirmed in Package.swift). A developer copy-pasting from the README will get a "No such module 'FocusDesignSystem'" build error immediately.

**Why it happens:**
Search-and-replace stops at prose. Code blocks inside backtick fences are treated as text, but reviewers scan them differently than headings. Import statements inside multi-line snippets are especially easy to miss because the eye fixates on the logic, not the import line.

**Consequences:**
- Developer gets a compile error on the first line of any code example
- Loss of trust in all documentation, not just the broken snippet
- Support questions that eat team time

**Prevention:**
- Run a final grep over all `.md` files for the old package name: `grep -rn "FocusDesignSystem" *.md Docs/`
- Treat every fenced code block as a separate audit pass, not part of the prose pass
- Verify import paths against Package.swift `products` list, which is the authoritative source

**Warning signs:**
- Any `import Focus` string remaining in any `.md` file after a rename pass
- Code blocks that differ in module names from Package.swift product names

**Phase:** Must be addressed in the rename/import-path update phase, before any component documentation is written.

---

### Pitfall 2: Component Catalog Audited by Memory, Not by Filesystem

**What goes wrong:**
The writer lists components they remember building. The actual file inventory is larger. Any component not in the writer's short-term memory gets silently omitted. Developers searching for a component assume it doesn't exist and re-implement it.

**Evidence in this codebase:**
The current README Component Catalog lists 25 components. The filesystem contains 62+ Swift files. Components entirely absent from all documentation include:
- All 21 Mobile/ subdirectory components (DSBarChart, DSBottomTabBar, DSCalendarGrid, DSCodeViewer, DSDailyGoalCard, DSFocusTimeCard, DSHeaderBar, DSLineChart, DSMetricCardView, DSPomodoroSegmentedControl, DSProblemCard, DSScheduleRow, DSSearchBar, DSSettingsRow, DSSidebarNav, DSSignOutButton, DSStartFocusCTA, DSStreakBadge, DSSurfaceCard, DSTaskRow, DSTimerRing)
- DSActionButton, DSIconButton, DSCompactHeaderBar, DSProgressHeader
- DSStatusCard, DSExpandableText
- DSImage, DSConsoleOutput, DSPicker, DSInlineErrorBanner
- DSText, DSTextValidation

That is roughly 37 undocumented components — more than the current catalog contains.

**Why it happens:**
Documentation is written once at v1, then components are added to source without a corresponding doc update step. The catalog becomes a snapshot of the initial launch state.

**Consequences:**
- Developers duplicate components that already exist
- Mobile/ subdirectory is especially invisible: it's a non-standard subdirectory that requires deliberate filesystem inspection to discover

**Prevention:**
- Generate the component list from the filesystem, not from memory: `find Sources/ -name "DS*.swift" | sort`
- Cross-reference that list against every name in the Component Catalog before submitting the docs update
- Treat Mobile/ as a first-class section in the catalog, not an afterthought

**Warning signs:**
- Component catalog count in docs is more than 20% below file count in Sources/
- Mobile/ subdirectory has zero mentions in any doc file

**Phase:** Component catalog update phase. The filesystem inventory must be the starting point, not the current catalog.

---

### Pitfall 3: Code Examples That Compile but Use the Wrong API Shape

**What goes wrong:**
The module name gets updated, but the example code still references a public API that changed shape since it was written. The example compiles if someone happens to have an old version, but fails or behaves unexpectedly with the current package.

**Evidence in this codebase:**
The current README `DSTheme.light` call is still valid at the callsite, but the README does not show that `DSTheme` now takes `vizColors` and `gradients` parameters in addition to the original fields. Any developer trying to create a custom theme (not just use `.light`) will get a missing-argument compile error because the docs don't show the full initializer.

Additionally, DSBadge now has an additional convenience initializer `init(text:difficultyLevel:)` via DSBadge+Difficulty.swift — this API surface exists but is undocumented, so developers write manual switch statements that the DS already provides.

**Why it happens:**
Example snippets are copy-pasted from initial implementation. The component API is extended later. Nobody goes back to update the existing snippet because the original still compiles.

**Consequences:**
- Custom theme creation fails silently (confusing compiler errors)
- Developers re-implement convenience APIs the DS already ships

**Prevention:**
- For each component in the catalog, open its Swift source file and verify the public initializer signature against the example in the docs
- Pay special attention to types that have extension files (e.g., DSBadge.swift + DSBadge+Difficulty.swift) — extensions add API that is invisible to someone only reading the primary file

**Warning signs:**
- A component source file has been modified after the last doc update date
- A component has extension files (+ in the filename) that are not mentioned in docs

**Phase:** Per-component documentation phase. Verify source-to-example alignment for every component being documented.

---

### Pitfall 4: File Path References That Rot Silently

**What goes wrong:**
Documentation links to source file paths that were valid at time of writing but became invalid after the rename or restructure. The link text looks correct, the reader cannot easily verify it, and the error only surfaces when someone navigates to the file.

**Evidence in this codebase:**
README.md contains:
```
- Sample screens: `Sources/FocusDesignSystemComponents/Examples/DSSampleScreens.swift`
```
The actual path after renaming is:
```
Sources/LeetPulseDesignSystemComponents/Examples/DSSampleScreens.swift
```
DEVELOPMENT_GUIDE.md references `Sources/FocusDesignSystemCore` throughout — every path is wrong.

**Why it happens:**
File paths inside backtick literals are not auto-updated by IDE refactoring tools because they are strings in markdown, not code. Rename operations in Xcode or the filesystem rename the actual directories but leave prose references unchanged.

**Consequences:**
- Developer tries to navigate to a referenced file, cannot find it
- Wastes time searching for a path that doesn't exist

**Prevention:**
- After completing all rename work in source, run: `grep -rn "FocusDesignSystem" Docs/ README.md` and treat any hit as a broken path
- Verify each quoted file path by checking it exists: `ls "Sources/LeetPulseDesignSystemCore"` etc.

**Warning signs:**
- Any `Sources/FocusDesign*` path remaining in markdown after the rename pass

**Phase:** Rename/path update phase, as the first action before writing any new content.

---

### Pitfall 5: Updating Docs Without Reading the Actual Source

**What goes wrong:**
The writer updates headings, module names, and prose based on knowledge of what the package "should" do, without reading the current public API. The resulting docs are plausible but wrong in the details — wrong parameter names, wrong default values, wrong types.

**Evidence in this codebase:**
DSStatusCard's public initializer has this signature:
```swift
public init(
    variant: DSStatusCardVariant,
    tintColor: Color? = nil,
    config: DSStatusCardConfig = .init(),
    @ViewBuilder content: () -> Content
)
```
Without reading the source, a writer might document it as `DSStatusCard(variant:content:)` and omit `tintColor` and `config`. The convenience overrides are the primary value of the component but are invisible without reading the file.

Similarly, DSThemeProvider takes `theme: DSTheme` (not `theme: DSThemeKind`). A writer inferring from the README prose might write the wrong type.

**Prevention:**
- Rule: no component documentation is written without having the component's Swift file open
- Use the actual `public init` signature as the template for parameter documentation
- Check for `#Preview` blocks in the source — they contain tested, working usage examples that can be adapted for docs

**Warning signs:**
- A documented parameter name that doesn't match a parameter in the actual public initializer

**Phase:** All component documentation phases. This is a discipline to enforce throughout.

---

### Pitfall 6: Treating a Rename as Find-and-Replace Only

**What goes wrong:**
The rename is executed as a mechanical string substitution across all files at once. This fixes `FocusDesignSystem` → `LeetPulseDesignSystem` everywhere, but misses context-dependent decisions: some files may describe what the package does (should change), while others may reference external history (may be intentional to preserve). More dangerously, a blanket replace will corrupt any sentence where the old name was used correctly in a historical context (e.g., RELEASE_NOTES.md describing what v1.0.1 was called at the time).

**Evidence in this codebase:**
RELEASE_NOTES.md currently says nothing about the rename — it only has one entry (v1.0.1) with no mention of the FocusDesignSystem → LeetPulseDesignSystem change. The correct action is to ADD a new release entry describing the rename, not to retroactively change the v1.0.1 entry, which would falsify the historical record.

**Prevention:**
- Distinguish between "live documentation" (README, guides — must be updated to current name) and "historical records" (release notes — should add new entries rather than alter existing ones)
- Review each file's purpose before applying a rename: RELEASE_NOTES.md needs a new section, not a replace
- After replacing, read each modified sentence in full — not just the changed token — to verify the meaning is still correct

**Warning signs:**
- RELEASE_NOTES.md entries that have been retroactively changed to say "LeetPulseDesignSystem" for historical versions that shipped as FocusDesignSystem

**Phase:** Rename phase. The historical record distinction must be made before any automated substitution runs.

---

## Moderate Pitfalls

### Pitfall 7: Mobile Components Documented Without Platform Context

**What goes wrong:**
The Mobile/ subdirectory contains iOS-only components that use DSMobileTokens (DSMobileColor, DSMobileSpacing, DSMobileTypography, DSMobileRadius) — a separate token system from the main DSTheme. If documentation treats Mobile/ components as interchangeable with core components, developers will try to use them on macOS or attempt to theme them with DSTheme, which will produce unstyled or broken output.

**Evidence in this codebase:**
DSBarChart.swift imports `LeetPulseDesignSystemCore` and uses `DSMobileColor.purple`, `DSMobileSpacing`, `DSMobileTypography`, and `DSMobileRadius` — none of which are in DSTheme. These are static values from DSMobileTokens.swift, not environment-injected. DSBarChart also does not accept a `DSTheme` or environment injection.

**Prevention:**
- Create a dedicated "Mobile Components" section in the catalog, clearly marked as iOS/iPadOS-only
- Document that Mobile/ components use static DSMobileTokens, not environment-injected DSTheme
- Note that DSMobileColor, DSMobileSpacing, DSMobileTypography, and DSMobileRadius are the token sources for Mobile/ components

**Warning signs:**
- Mobile component examples shown without noting the iOS-only requirement

**Phase:** Component catalog expansion phase.

---

### Pitfall 8: Documenting APIs That Were Removed or Consolidated

**What goes wrong:**
Documentation is added for APIs that the component previously had but that have since been consolidated or replaced. Developers try to call a method or use a type that no longer exists.

**Evidence in this codebase:**
The commit history shows `DSBadge+Difficulty` replaced a `Difficulty` enum that was previously in DSCore (commit e478477 removed it, 1724061 added it). Any documentation written before commit e478477 that references a `Difficulty` enum from DSCore would now be wrong — the type is gone and the replacement is `init(text:difficultyLevel:String)` using String.

**Prevention:**
- Before documenting a component, check its git log: `git log --oneline Sources/.../<Component>.swift`
- If a component has a "+" extension file, read both files before writing docs — the extension may have replaced API from the primary file

**Warning signs:**
- Documentation references a type name (e.g., `Difficulty`) that doesn't appear in any current `.swift` file in Sources/

**Phase:** Per-component documentation phase.

---

### Pitfall 9: Undocumented Breaking Changes in DSTheme

**What goes wrong:**
DSTheme's public structure changed — it now includes `vizColors: DSVizColors` and `gradients: DSGradients` as required fields. Any documentation or example showing a custom `DSTheme` initializer will be wrong because it omits these parameters. This is a breaking API change for anyone creating custom themes.

**Prevention:**
- Document the full DSTheme initializer signature in the Themes section of the README
- Include a working custom theme example that uses all required fields
- Call out in RELEASE_NOTES.md that the theme struct gained required fields (breaking change for custom themes)

**Warning signs:**
- Any documented `DSTheme(kind:colors:typography:spacing:radii:shadow:)` call — missing the `vizColors` and `gradients` arguments

**Phase:** README themes section update.

---

## Minor Pitfalls

### Pitfall 10: iOS Platform Version Not Documented

**What goes wrong:**
Package.swift declares `.iOS(.v26)` — a pre-release platform version. Documentation that says "iOS/iPadOS" without specifying the minimum version will mislead developers who attempt to integrate the package on iOS 17 or iOS 18 projects and hit deployment target mismatches.

**Prevention:**
- Add minimum platform versions (macOS 14, iOS 26) to the README Package Structure and Integration sections
- Note that iOS 26 is a pre-release requirement in context

**Warning signs:**
- Integration section that says "add as a package dependency" without mentioning minimum deployment targets

**Phase:** README integration section.

---

### Pitfall 11: Stale File Header Comments in Source Create Documentation Confusion

**What goes wrong:**
Several source files (e.g., DSBarChart.swift) still contain `// FocusApp` in their header comments. This doesn't affect compilation, but when a documentation writer reads a source file to extract an example, they may also copy the stale comment into documentation, or question which app the component belongs to.

This is a code-side issue, but it has documentation impact: the docs should be authoritative about the package name, and stale comments in source files undermine that authority if readers reference them.

**Prevention:**
- When reading source files to write examples, ignore file header comments — use the `public struct` / `public func` declarations as the authoritative API, not the comments
- Flag source file headers with the old name for cleanup in a separate code-side ticket (out of scope for docs-only update, but worth noting)

**Warning signs:**
- Documentation that attributes a component to "FocusApp" rather than "LeetPulseDesignSystem"

**Phase:** Any component documentation phase (awareness issue, not a blocker).

---

### Pitfall 12: DSText and DSTextValidation Are Undocumented Internal Helpers

**What goes wrong:**
The Sources directory contains DSText.swift and DSTextValidation.swift. These may be internal view helpers or public API. If public, they need documentation. If internal, documenting them wastes effort and confuses developers about the public API surface.

**Prevention:**
- Check `public` vs `internal` access modifiers in each file before adding it to the component catalog
- Only document `public struct`, `public class`, `public enum`, and `public func` declarations

**Warning signs:**
- Documenting a component that has no `public` declaration in its source file

**Phase:** Component catalog expansion phase.

---

## Phase-Specific Warnings

| Phase Topic | Likely Pitfall | Mitigation |
|-------------|---------------|------------|
| Rename / import paths | Partial rename misses code block imports | grep for "FocusDesignSystem" in all .md files after every pass |
| Component catalog audit | Memory-based list misses 37+ components | Generate list from filesystem (find Sources/ -name "DS*.swift") |
| Per-component examples | Example uses outdated API shape | Read public init signature in source before writing any example |
| File path references | Paths reference Sources/FocusDesign* | Verify every quoted path against the actual filesystem |
| RELEASE_NOTES.md | Retroactive rename corrupts historical record | Add new entry for rename; do not edit existing v1.0.1 entry |
| Mobile/ section | Mobile components treated as cross-platform | Clearly mark Mobile/ section as iOS/iPadOS-only; document DSMobileTokens |
| DSTheme custom usage | Custom theme example omits vizColors+gradients | Use full DSTheme initializer signature from DSTheme.swift |
| Platform requirements | Integration docs silent on iOS 26 minimum | Add minimum platform versions to integration section |

---

## Sources

- Direct inspection: `/Users/ashimdahal/Documents/LeetPulseDesignSystem/README.md` (current stale state)
- Direct inspection: `/Users/ashimdahal/Documents/LeetPulseDesignSystem/Package.swift` (authoritative module names and platform requirements)
- Direct inspection: `/Users/ashimdahal/Documents/LeetPulseDesignSystem/Docs/DEVELOPMENT_GUIDE.md` (stale directory references)
- Direct inspection: `/Users/ashimdahal/Documents/LeetPulseDesignSystem/Docs/VALIDATION.md` (stale import paths)
- Direct inspection: `/Users/ashimdahal/Documents/LeetPulseDesignSystem/Sources/` (full filesystem component inventory — 62+ Swift files vs 25 in catalog)
- Direct inspection: `Sources/LeetPulseDesignSystemComponents/DSStatusCard.swift` (API shape evidence)
- Direct inspection: `Sources/LeetPulseDesignSystemComponents/DSBadge+Difficulty.swift` (extension API evidence)
- Direct inspection: `Sources/LeetPulseDesignSystemCore/DSTheme.swift` (vizColors+gradients required fields)
- Direct inspection: `Sources/LeetPulseDesignSystemComponents/Mobile/DSBarChart.swift` (DSMobileTokens usage evidence)
- Project context: `.planning/PROJECT.md`
- Git commit history: commits e478477, 1724061 (Difficulty enum removal and DSBadge+Difficulty addition)
- Confidence: HIGH — all claims verified against source code directly
