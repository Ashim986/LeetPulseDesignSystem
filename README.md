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
```swift
import LeetPulseDesignSystem

let theme = DSTheme.light
DSThemeProvider(theme: theme) {
    ContentView()
}
```

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
