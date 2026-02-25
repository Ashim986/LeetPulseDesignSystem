# LeetPulseDesignSystem

LeetPulseDesignSystem is a multi-platform Swift Package (macOS/iOS/iPadOS) that provides
consistent, themeable UI components with state machines and 100% unit-testable logic.

Repository: `https://github.com/Ashim986/LeetPulseDesignSystem`

## Installation

Add LeetPulseDesignSystem via Swift Package Manager:

```swift
// In your Package.swift dependencies:
.package(url: "https://github.com/Ashim986/LeetPulseDesignSystem", from: "1.0.0")
```

**Minimum deployment targets:**
- iOS 26+
- macOS 14+

## Goals
- Themeable light/dark tokens
- Reusable, configurable components
- State-machine driven UI behavior
- Fully testable (pure unit/state tests only)
- No dependency on caller app state

## Package Structure

LeetPulseDesignSystem is organized into four Swift modules. The umbrella module re-exports all three sub-modules via `@_exported import`, so most apps only need a single import.

**Module dependency graph:**

- `LeetPulseDesignSystemCore` — tokens, themes, DSThemeProvider
- `LeetPulseDesignSystemState` (depends on Core) — state machines, validation rules
- `LeetPulseDesignSystemComponents` (depends on Core + State) — all DS* UI components
- `LeetPulseDesignSystem` (umbrella) — re-exports all three modules

**Which module should I import?**

| If you need | Import |
|-------------|--------|
| Just tokens, themes, DSThemeProvider | `import LeetPulseDesignSystemCore` |
| State machines, validation rules | `import LeetPulseDesignSystemState` |
| UI components (DS* views) | `import LeetPulseDesignSystemComponents` |
| Everything (recommended for apps) | `import LeetPulseDesignSystem` |

## Themes

LeetPulseDesignSystem uses a centralized theme system. All components read design tokens — colors, typography, spacing, corner radii, shadows, and visualization colors — from a single `DSTheme` value. The theme is injected at the root of your view hierarchy via `DSThemeProvider` and accessed anywhere in the tree with `@Environment(\.dsTheme)`. Two built-in themes are provided: `.light` and `.dark`.

**Set up the theme at your app root:**

```swift
import LeetPulseDesignSystem

// Wrap your root view with DSThemeProvider
DSThemeProvider(theme: .light) {
    ContentView()
}
```

**Access tokens in a custom view:**

```swift
struct MyView: View {
    @Environment(\.dsTheme) var theme

    var body: some View {
        Text("Hello")
            .foregroundStyle(theme.colors.textPrimary)
            .font(theme.typography.body)
            .padding(theme.spacing.md)
    }
}
```

**Switch to dark theme:**

```swift
DSThemeProvider(theme: .dark) {
    ContentView()
}
```

## Token Reference

All tokens are accessed via `@Environment(\.dsTheme) var theme` and then `theme.<group>.<token>`.

### Colors

| Token | Purpose |
|-------|---------|
| `theme.colors.background` | App background |
| `theme.colors.surface` | Card and panel surfaces |
| `theme.colors.surfaceElevated` | Elevated surface (popovers, sheets) |
| `theme.colors.primary` | Primary brand color (buttons, links, highlights) |
| `theme.colors.secondary` | Secondary accent (supporting UI) |
| `theme.colors.accent` | Accent color (badges, indicators) |
| `theme.colors.textPrimary` | Primary text |
| `theme.colors.textSecondary` | Secondary and supporting text |
| `theme.colors.border` | Dividers and borders |
| `theme.colors.success` | Success states |
| `theme.colors.warning` | Warning states |
| `theme.colors.danger` | Error and destructive states |
| `theme.colors.surfaceClear` | Transparent surface (use instead of `Color.clear`) |
| `theme.colors.foregroundOnViz` | High-contrast foreground for use over visualization colors |
| `theme.colors.textDisabled` | Dimmed text for disabled controls |

### Typography

| Token | Usage |
|-------|-------|
| `theme.typography.title` | Page and section titles (22 pt bold) |
| `theme.typography.subtitle` | Secondary headings (15 pt semibold) |
| `theme.typography.body` | Body text (13 pt regular) |
| `theme.typography.caption` | Small labels and metadata (11 pt regular) |
| `theme.typography.mono` | Code and monospaced text (12 pt monospaced) |

### Spacing

| Token | Value | Usage |
|-------|-------|-------|
| `theme.spacing.xs` | 4 pt | Tight spacing between closely related elements |
| `theme.spacing.sm` | 8 pt | Default inner padding |
| `theme.spacing.md` | 12 pt | Standard component spacing |
| `theme.spacing.lg` | 16 pt | Section separation |
| `theme.spacing.xl` | 24 pt | Large gaps between sections |

### Corner Radii

| Token | Value | Usage |
|-------|-------|-------|
| `theme.radii.sm` | 6 pt | Subtle rounding (badges, tags) |
| `theme.radii.md` | 10 pt | Standard component rounding (cards, buttons) |
| `theme.radii.lg` | 16 pt | Large rounding (modals, panels) |
| `theme.radii.pill` | 999 pt | Fully rounded (pills, circular buttons) |

### Shadow

| Field | Purpose |
|-------|---------|
| `theme.shadow.color` | Shadow color (opacity varies by theme) |
| `theme.shadow.radius` | Blur radius |
| `theme.shadow.x` | Horizontal offset |
| `theme.shadow.y` | Vertical offset |

### Visualization Colors (Okabe-Ito)

Visualization colors follow the Okabe-Ito palette, designed for colorblind accessibility. Both light and dark theme variants are provided. Access via `theme.vizColors.<token>`.

| Token | Description |
|-------|-------------|
| `theme.vizColors.primary` | Orange |
| `theme.vizColors.secondary` | Sky Blue |
| `theme.vizColors.tertiary` | Bluish Green |
| `theme.vizColors.quaternary` | Yellow |
| `theme.vizColors.quinary` | Blue |
| `theme.vizColors.senary` | Vermillion |
| `theme.vizColors.septenary` | Reddish Purple |
| `theme.vizColors.octenary` | Neutral anchor (black in light, white in dark) |
| `theme.vizColors.highlight` | Semantic alias for highlighted data (maps to Sky Blue) |
| `theme.vizColors.selected` | Semantic alias for selected data (maps to Orange) |
| `theme.vizColors.error` | Semantic alias for error data (maps to Vermillion) |

## Components
```swift
import LeetPulseDesignSystem

DSButton("Continue", config: .init(style: .primary)) {
    // action
}

DSCard {
    DSHeader(title: "Progress", subtitle: "Today")
    DSProgressRing(state: .init(progress: 0.72))
}

DSTextField(
    title: "Username",
    placeholder: "Enter username",
    text: .constant("")
)

DSSegmentedControl(
    items: [
        DSSegmentItem(id: "a", title: "A"),
        DSSegmentItem(id: "b", title: "B")
    ],
    state: .init(selectedId: "a"),
    onSelect: { _ in }
)

DSSelect(
    placeholder: "Choose a track",
    items: [
        DSSelectItem(id: "core", title: "Core"),
        DSSelectItem(id: "sprint", title: "Sprint")
    ],
    state: .init(selectedId: "core"),
    onSelect: { _ in }
)

DSMetricCard(
    title: "Solved",
    value: "48",
    detail: "This week",
    trend: .positive,
    trendLabel: "+12%"
)

DSTabBar(
    items: [
        DSNavItem(id: "today", title: "Today", systemImage: "house"),
        DSNavItem(id: "plan", title: "Plan", systemImage: "calendar"),
        DSNavItem(id: "stats", title: "Stats", systemImage: "chart.bar")
    ],
    state: .init(selectedId: "today")
) { _ in }

DSSidebar(
    items: [
        DSNavItem(id: "focus", title: "Focus", systemImage: "bolt"),
        DSNavItem(id: "coding", title: "Coding", systemImage: "chevron.left.slash.chevron.right")
    ],
    state: .init(selectedId: "focus")
) { _ in }

DSTabScaffold(
    items: [
        DSNavItem(id: "today", title: "Today", systemImage: "house"),
        DSNavItem(id: "plan", title: "Plan", systemImage: "calendar")
    ],
    state: .init(selectedId: "today")
) { _ in
    Text("Content")
}

DSSidebarScaffold(
    items: [
        DSNavItem(id: "stats", title: "Stats", systemImage: "chart.bar"),
        DSNavItem(id: "focus", title: "Focus", systemImage: "bolt")
    ],
    state: .init(selectedId: "stats")
) { _ in
    Text("Content")
}

DSToast(
    title: "Synced",
    message: "LeetCode updated",
    config: .init(style: .success),
    state: .init(isVisible: true)
)

DSBubble(text: "42")

DSArrow()

DSCurvedArrow(config: .init(curveOffset: 24))

DSGraphView(
    adjacency: [[1], [0]],
    nodeLabels: ["A", "B"],
    pointers: [DSPointerMarker(name: "p", index: 0)]
)

DSTreeGraphView(
    tree: DSTree(
        nodes: [
            DSTreeNode(id: "root", label: "A", left: "l", right: "r"),
            DSTreeNode(id: "l", label: "B"),
            DSTreeNode(id: "r", label: "C")
        ],
        rootId: "root"
    ),
    pointers: [DSPointerMarker(name: "root", nodeId: "root")]
)
```

## Component Catalog
- DSAlert
- DSArrow
- DSBadge
- DSBubble
- DSButton
- DSCard
- DSCurvedArrow
- DSEmptyState
- DSFormField
- DSGraphView
- DSHeader
- DSListRow
- DSMetricCard
- DSPointerBadge
- DSProgressRing
- DSScaffolds (DSTabScaffold, DSSidebarScaffold)
- DSSectionHeader
- DSSegmentedControl
- DSSidebar
- DSSelect
- DSTabBar
- DSTextArea
- DSTextField
- DSToast
- DSToggle
- DSTreeGraphView

## Documentation
- iOS + iPadOS roadmap: `Docs/IOS_IPADOS_ROADMAP.md`
- Development guide: `Docs/DEVELOPMENT_GUIDE.md`
- Sample screens: `Sources/LeetPulseDesignSystemComponents/Examples/DSSampleScreens.swift`
- Validation framework: `Docs/VALIDATION.md`

## Primitives (Intended Scope)
The following primitives are designed for cross-platform reuse and should stay
agnostic to any single app feature:
- Bubble, PointerBadge, Arrow, CurvedArrow
- GraphView, TreeGraphView

App-specific compositions (for example, DataJourney layouts or trace-driven
visualizations) should remain inside the app layer and compose these primitives.

## State Machines
```swift
var state = DSButtonState(isEnabled: true, isLoading: false)
var reducer = DSButtonReducer()
reducer.reduce(state: &state, event: .setLoading(true))
```

## Tests
Run all tests:
```bash
swift test
```

## Integration
This package is designed to be added as a dependency from a separate repo.
Add it in Xcode via **File → Add Packages…** or in Package.swift.
