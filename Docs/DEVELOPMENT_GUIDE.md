# Design System Development Guide

## Purpose
This guide describes how to develop, extend, and validate the Focus design system for macOS, iOS, and iPadOS using SwiftUI, state reducers, and unit tests.

## Repository Structure
- `Sources/FocusDesignSystemCore`: tokens and theme environment.
- `Sources/FocusDesignSystemState`: reducer protocol and state store.
- `Sources/FocusDesignSystemComponents`: reusable UI components.
- `Tests/FocusDesignSystemComponentsTests`: unit tests for state and render models.

## Development Workflow
1. Start with tokens in `FocusDesignSystemCore` and map semantic colors to design intent.
2. Define component state and events in `FocusDesignSystemComponents`.
3. Add a reducer that updates state deterministically and is fully unit-testable.
4. Build a render model that derives colors, typography, and layout from `DSTheme`.
5. Implement the SwiftUI view using the render model and environment theme.
6. Add unit tests for reducer behavior and render model output.
7. Validate in the sample app or host app and update docs.

## Component Checklist
- Stateless view surface that reads from a render model.
- State machine and reducer with full unit coverage.
- Theme-driven colors and spacing.
- Accessible font sizes and consistent hit targets.
- No dependency on app data stores or view models.

## Testing Strategy
- Unit tests only for reducers and render models.
- Prefer simple assertions for selection, enablement, opacity, and color choice.
- Run `swift test` before release.

## Release Process
1. Update README and release notes.
2. Run tests and resolve warnings.
3. Tag the release and publish.
4. Update dependent apps to the new version.

## Cross-Platform Guidelines
- Use the same component APIs across iOS, iPadOS, and macOS.
- Prefer layout adaptation via size class rather than platform-specific branching.
- Keep app-specific composition in the app layer.

## Adding New Components
- Create a new file in `Sources/FocusDesignSystemComponents`.
- Define `Config`, `State`, `Event`, `Reducer`, and `RenderModel` types.
- Add tests in `Tests/FocusDesignSystemComponentsTests`.
- Link usage in README and component catalog.
