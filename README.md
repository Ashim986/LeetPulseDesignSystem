# FocusDesignSystem

FocusDesignSystem is a multi-platform Swift Package (macOS/iOS/iPadOS) that provides
consistent, themeable UI components with state machines and 100% unit-testable logic.

Repository: `https://github.com/Ashim986/DSFocusFlow`

## Goals
- Themeable light/dark tokens
- Reusable, configurable components
- State-machine driven UI behavior
- Fully testable (pure unit/state tests only)
- No dependency on caller app state

## Package Structure
- `FocusDesignSystemCore`
  - Tokens: colors, typography, spacing, radii, shadow
  - Theme and environment injection
- `FocusDesignSystemState`
  - Reducer + state store
- `FocusDesignSystemComponents`
  - Card, Header, Button, Badge, ProgressRing
  - TextField, TextArea, Toggle, SegmentedControl, EmptyState, FormField, Select
  - ListRow, SectionHeader, MetricCard, Toast, Alert
  - Bubble, PointerBadge, Arrow, CurvedArrow, GraphView, TreeGraphView
- `FocusDesignSystem` (umbrella)
  - Re-exports the modules above

## Themes
```swift
import FocusDesignSystem

let theme = DSTheme.light
DSThemeProvider(theme: theme) {
    ContentView()
}
```

## Components
```swift
import FocusDesignSystem

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
- Sample screens: `Sources/FocusDesignSystemComponents/Examples/DSSampleScreens.swift`

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
