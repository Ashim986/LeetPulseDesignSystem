# External Integrations

**Analysis Date:** 2026-02-25

## APIs & External Services

**None detected:**
- This is a pure design system package with no external API integrations
- All functionality is self-contained within the Swift package

## Data Storage

**Databases:**
- None - Design system contains only UI components and state management logic
- No persistent storage or database integrations

**File Storage:**
- None - No file storage integrations
- Package is distribution-only

**Caching:**
- None - No explicit caching layer
- Relies on SwiftUI's built-in view caching and state management

## Authentication & Identity

**Auth Provider:**
- None - Design system does not handle authentication
- This is a UI toolkit package for consuming applications to implement their own auth

## Monitoring & Observability

**Error Tracking:**
- None - Package does not send telemetry or error reports

**Logs:**
- None - No structured logging framework
- Validation framework provides error states for UI display (`DSValidationError.swift`, `DSValidationResult.swift`)

## CI/CD & Deployment

**Hosting:**
- GitHub (source repository)
- Distributed via Swift Package Manager

**CI Pipeline:**
- Not detected - Build configuration files in `.build/` are generated artifacts
- No GitHub Actions workflows found

## Environment Configuration

**Required env vars:**
- None - Package has no environment-dependent configuration

**Secrets location:**
- Not applicable - Package contains no secrets or credential handling

## Webhooks & Callbacks

**Incoming:**
- None

**Outgoing:**
- None

## Library Dependencies

**Direct Swift Framework Dependencies:**
- SwiftUI (Apple framework)
- Combine (Apple framework)
- Foundation (Apple framework)
- CoreGraphics (Apple framework)

**No third-party package dependencies:**
- Package.swift contains no external package dependencies
- All functionality built on Apple's standard frameworks

## Module Interdependencies

**Dependency Graph:**
```
LeetPulseDesignSystem (umbrella)
├── LeetPulseDesignSystemCore (no dependencies)
├── LeetPulseDesignSystemState (depends on: Core)
└── LeetPulseDesignSystemComponents (depends on: Core, State)
```

**Consuming Applications:**
- Consuming apps import via: `import LeetPulseDesignSystem` (re-exports all modules)
- Or import specific modules: `import LeetPulseDesignSystemCore`, `import LeetPulseDesignSystemComponents`, etc.

---

*Integration audit: 2026-02-25*
