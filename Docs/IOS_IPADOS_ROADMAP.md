# iOS + iPadOS Design System Roadmap

## Goal
Deliver a shared design system that supports iOS and iPadOS with consistent tokens, components, and state-driven behaviors while remaining layout-adaptive for size classes and device form factors.

## Execution Order
1. Validate foundations: color tokens, typography scale, spacing, radii, shadows, elevation, and semantic roles for light/dark.
2. Define platform layout rules: safe-area usage, spacing scale for compact vs regular size classes, and navigation patterns.
3. Implement navigation primitives: DSTabBar for iOS, DSSidebar for iPadOS, and selection state reducers.
4. Build core surfaces: cards, headers, list rows, badges, buttons, empty states, and form fields.
5. Add feedback components: toast, alert, progress ring, and inline validation styles.
6. Add data visuals: graph, tree graph, pointer/bubble primitives, and visual annotations.
7. Add app shell templates: mobile scaffold (tab bar + content) and tablet scaffold (sidebar + content + detail).
8. Add accessibility and input support: dynamic type, contrast checks, hit targets, keyboard focus for iPad.
9. Build sample screens for Today, Plan, Stats, Focus, Coding using only DS components.
10. Lock API and ship v1, then iterate on advanced overlays, sheets, and animation tokens.

## iOS Design Direction
- Navigation: bottom tab bar.
- Layout: compact spacing, stacked cards, single-column content.
- Touch: larger hit targets and simplified controls.
- Typography: larger body and title sizes for readability on phones.

## iPadOS Design Direction
- Navigation: left sidebar with grouped destinations and a content/detail area.
- Layout: multi-column grids, wider cards, and persistent secondary content.
- Input: keyboard shortcuts and pointer hover states where applicable.
- Typography: same scale, but more whitespace and larger section spacing.

## Deliverables By Phase
1. Token palette + semantic mappings.
2. Navigation components and state machines.
3. Core component catalog.
4. Visual primitives and data components.
5. App shell templates for iOS and iPadOS.
6. Documentation + sample usage.
