# LeetPulseDesignSystem

LeetPulseDesignSystem is a multi-platform Swift Package (macOS/iOS/iPadOS) that provides
consistent, themeable UI components with state machines and 100% unit-testable logic.
One module, one import: `import LeetPulseDesignSystem`.

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

LeetPulseDesignSystem ships as a single Swift module. Add the dependency and import it:

```swift
import LeetPulseDesignSystem
```

Source code is organized into subdirectories for clarity:

- `Sources/LeetPulseDesignSystem/Core/` — tokens, themes, DSThemeProvider
- `Sources/LeetPulseDesignSystem/State/` — state machines, validation rules
- `Sources/LeetPulseDesignSystem/Components/` — all DS* UI components

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

60 public components across 5 functional groups. Components marked **iOS/iPadOS** reside in `Sources/LeetPulseDesignSystem/Components/Mobile/` and use `DSMobileTokens` instead of `DSTheme`. They compile on all platforms but are designed for iOS and iPadOS layouts.

### Primitives

Low-level building blocks and shapes, composable into higher-level components.

| Component | Description | Platform |
|-----------|-------------|----------|
| DSArrow | Directional arrow shape | All |
| DSBubble | Circular label badge for compact values | All |
| DSCard | Surface container with elevation and outline styles | All |
| DSConsoleOutput | Monospaced text output panel | All |
| DSCurvedArrow | Curved directional arrow with configurable offset | All |
| DSExpandableText | Truncated text with expand/collapse toggle | All |
| DSImage | Themed image container with loading states | All |
| DSPointerBadge | Pointer marker badge for graph visualization | All |
| DSText | Themed text label applying DSTheme typography and color | All |

### Form Controls

Input, selection, and validation components for building forms and interactive controls.

| Component | Description | Platform |
|-----------|-------------|----------|
| DSActionButton | Compact action trigger with icon support | All |
| DSButton | Primary action button with loading, disabled, and icon states | All |
| DSFormField | Form field wrapper with label and validation display | All |
| DSIconButton | Icon-only button for toolbar actions | All |
| DSPicker | Value picker with configurable options | All |
| DSPomodoroSegmentedControl | Pomodoro-specific segmented timer control | iOS/iPadOS |
| DSSearchBar | Search input with clear button and keyboard handling | iOS/iPadOS |
| DSSegmentedControl | Horizontal segmented selection control | All |
| DSSelect | Dropdown-style selection with options list | All |
| DSTextArea | Multi-line text input field | All |
| DSTextField | Single-line text input with optional validation state | All |
| DSTextValidation | Text input validation policy definitions | All |
| DSToggle | On/off toggle switch | All |

### Navigation

Structural navigation patterns and layout scaffolding for app shells.

| Component | Description | Platform |
|-----------|-------------|----------|
| DSBottomTabBar | Bottom tab bar for iOS tab navigation | iOS/iPadOS |
| DSNavItem | Model type for navigation items (tab bars, sidebars, scaffolds) | All |
| DSScaffolds | Layout scaffolds: DSTabScaffold and DSSidebarScaffold | All |
| DSSidebar | Vertical sidebar navigation list | All |
| DSSidebarNav | Mobile-optimized sidebar navigation | iOS/iPadOS |
| DSTabBar | Horizontal tab bar navigation | All |

### Feedback

Status indicators, alerts, progress displays, and informational cards.

| Component | Description | Platform |
|-----------|-------------|----------|
| DSAlert | Dismissible alert banner with severity styles | All |
| DSBadge | Status badge with text and color variants | All |
| DSCompactHeaderBar | Condensed header bar for secondary screens | All |
| DSDailyGoalCard | Daily goal progress card | iOS/iPadOS |
| DSEmptyState | Placeholder view for empty data states | All |
| DSFocusTimeCard | Focus session time display card | iOS/iPadOS |
| DSHeader | Section header with title and optional subtitle | All |
| DSHeaderBar | Mobile navigation header bar | iOS/iPadOS |
| DSInlineErrorBanner | Inline error message display | All |
| DSListRow | Configurable list row with leading and trailing content | All |
| DSMetricCard | Metric display card with value, trend, and detail | All |
| DSMetricCardView | Mobile-optimized metric card layout | iOS/iPadOS |
| DSProblemCard | Problem and challenge display card | iOS/iPadOS |
| DSProgressHeader | Header with integrated progress indicator | All |
| DSProgressRing | Circular progress indicator ring | All |
| DSScheduleRow | Schedule entry row display | iOS/iPadOS |
| DSSectionHeader | Section divider with title | All |
| DSSettingsRow | Settings menu row with label and accessory | iOS/iPadOS |
| DSSignOutButton | Sign out action button | iOS/iPadOS |
| DSStartFocusCTA | Call-to-action for starting focus sessions | iOS/iPadOS |
| DSStatusCard | Status information card with icon and message | All |
| DSStreakBadge | Streak counter badge display | iOS/iPadOS |
| DSSurfaceCard | Elevated surface card container | iOS/iPadOS |
| DSTaskRow | Task list row with completion state | iOS/iPadOS |
| DSTimerRing | Countdown timer ring display | iOS/iPadOS |
| DSToast | Temporary notification toast message | All |

### Visualization

Data display, charts, and algorithm visualization components.

| Component | Description | Platform |
|-----------|-------------|----------|
| DSBarChart | Vertical bar chart for data comparison | iOS/iPadOS |
| DSCalendarGrid | Calendar grid for date-based data display | iOS/iPadOS |
| DSCodeViewer | Syntax-highlighted code display panel | iOS/iPadOS |
| DSGraphView | Node-and-edge graph visualization (Canvas-rendered) | All |
| DSLineChart | Line chart for trend data display | iOS/iPadOS |
| DSTreeGraphView | Tree structure visualization (Canvas-rendered) | All |

## Documentation
- iOS + iPadOS roadmap: `Docs/IOS_IPADOS_ROADMAP.md`
- Development guide: `Docs/DEVELOPMENT_GUIDE.md`
- Sample screens: `Sources/LeetPulseDesignSystem/Components/Examples/DSSampleScreens.swift`
- Validation framework: `Docs/VALIDATION.md`

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
