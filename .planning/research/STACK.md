# Stack Research: Swift Design System Documentation

**Research type:** Project Research — Stack dimension
**Question:** What's the standard 2025 stack for documenting Swift design systems?
**Milestone context:** Subsequent milestone — 62+ components exist; updating outdated docs that still reference "FocusDesignSystem" and are missing new components
**Date:** 2026-02-25

---

## Executive Summary

In 2025, the unambiguous standard for documenting Swift packages is **DocC** (Documentation Compiler), Apple's first-party tool integrated directly into Xcode and Swift Package Manager. For a design system specifically, DocC is supplemented by **Swift Previews** (Xcode's live preview system) for visual component documentation. Jazzy, the former community standard, is in maintenance-only mode and should not be used for new projects. The right stack for LeetPulseDesignSystem is: DocC for API reference + article-based guides, with Xcode Previews providing in-IDE visual documentation.

---

## Recommendations

### 1. DocC — PRIMARY TOOL (Confidence: HIGH)

**What it is:** Apple's official documentation compiler, shipped with Xcode since Xcode 13 (2021), with significant improvements each year through 2025. Generates both a web-deployable documentation archive (.doccarchive) and in-Xcode documentation.

**Why it's the right choice for LeetPulseDesignSystem:**

- **First-party, zero-friction integration.** DocC is built into `swift package generate-documentation` and `xcodebuild docbuild`. No extra tools to install, no CI configuration beyond what the project already has. For a Swift Package (which LeetPulseDesignSystem is), it works out of the box.
- **Multi-target support.** LeetPulseDesignSystem has four distinct targets (LeetPulseDesignSystem, LeetPulseDesignSystemComponents, LeetPulseDesignSystemCore, LeetPulseDesignSystemState). DocC generates per-target documentation archives that can be combined into a single unified catalog via a `.docc` bundle at the package root.
- **In-code documentation survives refactors.** DocDoc comment syntax (`///` triple-slash, with `- Parameter:`, `- Returns:`, `- Note:`, `- SeeAlso:`) lives directly in Swift source files, meaning renaming `FocusDesignSystem` references in source also fixes the docs in the same commit.
- **Articles and tutorials (Markdown-based).** DocC supports freeform `.md` articles inside a `.docc` catalog. This is where design system usage guides, theming documentation, component overview pages, and migration notes go. These are separate from API reference and can be written without touching source code.
- **GitHub Pages deployment.** As of DocC 1.0+ (available via the `swift-docc` open-source package), documentation archives can be published to GitHub Pages or any static host with a single post-process step (`docc process-archive transform-for-static-hosting`). Apple's own package documentation (swift-algorithms, swift-collections, etc.) all use this pipeline.
- **Symbol graph integration.** DocC reads `.symbolgraph.json` files that `swiftc` emits, meaning it automatically picks up every public symbol across all four targets without manual enumeration.

**How to implement for this project:**

1. Add a `LeetPulseDesignSystem.docc` bundle directory under `Sources/LeetPulseDesignSystem/`.
2. Create a root `LeetPulseDesignSystem.md` catalog file that defines the top-level navigation structure (Overview, Core Tokens, Components, State & Validation).
3. Write triple-slash doc comments on all public APIs in source files. The renaming task (FocusDesignSystem → LeetPulseDesignSystem) and the doc comment task can be done in the same pass.
4. Add article `.md` files for: Color System, Typography, Layout Tokens, Component Usage Guide, Migration Notes.
5. Add a CI step: `swift package --allow-writing-to-directory ./docs generate-documentation --target LeetPulseDesignSystem --output-path ./docs --transform-for-static-hosting`.

**What DocC does NOT do well:**
- Visual component gallery (living styleguide). DocC can embed images/video in articles but has no interactive component renderer.
- Cross-repository documentation aggregation (not needed here since it's a single package).

---

### 2. Xcode Previews (#Preview macro) — VISUAL DOCUMENTATION LAYER (Confidence: HIGH)

**What it is:** SwiftUI's `#Preview` macro (replacing the older `PreviewProvider` protocol, which is still supported but deprecated in favor of `#Preview` as of Xcode 15/2023). Provides live, interactive component rendering inside Xcode.

**Why it matters for a design system:**

- LeetPulseDesignSystem's components (DSButton, DSCard, DSBadge, DSMetricCard, etc.) are SwiftUI views. The canonical way to document their visual states and variants is `#Preview` blocks in the source file itself.
- Previews serve as both visual documentation and regression-detection. When a component's appearance changes accidentally, the developer sees it immediately.
- Previews can be organized with display names: `#Preview("DSButton / Primary")`, `#Preview("DSButton / Destructive")` — this gives component-level visual documentation with zero tooling overhead.
- The existing `DSSampleScreens.swift` file under Examples suggests preview-based documentation is already partially in use. That pattern should be formalized and extended to all 62+ components.

**Implementation guidance:**
- Every component file should have `#Preview` blocks covering: default state, all named variants, light/dark mode (using `preferredColorScheme`), and accessibility text size variants.
- The `Examples/` directory pattern is good for screen-level compositions but `#Preview` in the component file itself is better for component-level documentation.

---

### 3. Structured Doc Comments in Source — FOUNDATIONAL LAYER (Confidence: HIGH)

**What it is:** Swift's triple-slash `///` documentation comment syntax, which DocC reads directly.

**Why it's non-negotiable:**

- Without doc comments, DocC generates an empty reference page. The tool is only as good as the comments.
- For a design system with 62+ components across 4 targets, doc comments are the primary interface contract for consumers of the package.
- Swift's doc comment syntax supports: Summary line, Discussion paragraphs, `- Parameter name:`, `- Returns:`, `- Throws:`, `- Note:`, `- Warning:`, `- SeeAlso:`, and `- Complexity:` callout blocks. All are rendered by DocC.

**Specific guidance for LeetPulseDesignSystem:**
- Every `public` struct, class, enum, property, and function needs a doc comment.
- The component name (DS prefix) should be in the summary line.
- Link related components using DocDoc symbol links: `<doc:DSButton>` or backtick-symbol syntax.
- The `DSTheme`, `DSLayout`, `DSGradients`, `DSVizColors`, `DSMobileTokens` token files in Core are the highest priority — they define the design vocabulary and consumers will look them up most often.

---

### 4. GitHub Actions CI for Documentation — AUTOMATION LAYER (Confidence: HIGH)

**What it is:** A GitHub Actions workflow that builds and publishes the DocC archive to GitHub Pages on every push to main.

**Why this matters:**
- Without automation, documentation gets stale. The existing problem (docs still say FocusDesignSystem, missing new components) is a staleness problem caused by a manual documentation process.
- A CI pipeline that fails the build if documentation cannot be generated creates a forcing function: undocumented public APIs become a build error (using `--warnings-as-errors` flag on `swift package generate-documentation`).

**Implementation:**
```yaml
# .github/workflows/docc.yml
- name: Generate DocC
  run: |
    swift package --allow-writing-to-directory docs \
      generate-documentation \
      --target LeetPulseDesignSystem \
      --output-path docs \
      --transform-for-static-hosting \
      --hosting-base-path LeetPulseDesignSystem
- name: Deploy to GitHub Pages
  uses: peaceiris/actions-gh-pages@v4
  with:
    github_token: ${{ secrets.GITHUB_TOKEN }}
    publish_dir: ./docs
```

---

## What NOT to Use

### Jazzy — DO NOT USE (Confidence: HIGH)

**Why not:**
- Jazzy (realm/jazzy on GitHub) reached version 0.15.x in 2023 and has been in maintenance-only mode since. The last meaningful feature release was in 2022. As of early 2025, the project's README itself directs new users toward DocC.
- Jazzy depends on SourceKitten, which in turn depends on `sourcekitd` internals that change with each Xcode release, making Jazzy brittle on newer toolchains (Xcode 15, 16).
- Jazzy generates static HTML with a 2014-era UI. DocC's output is modern, searchable, and matches Apple's own documentation site aesthetics — important for a design system consumed by iOS developers who already live in that ecosystem.
- **The one exception:** if you need to document Objective-C APIs (not applicable here; LeetPulseDesignSystem is pure Swift/SwiftUI).

### Custom Static Site Generators (Docusaurus, MkDocs, etc.) — DO NOT USE for API reference (Confidence: HIGH)

**Why not:**
- Tools like Docusaurus or MkDocs require manually writing and maintaining API reference documentation separately from source code. This is exactly the workflow that caused the current staleness problem (FocusDesignSystem name lingering in docs).
- They can be valuable for a *companion* marketing/overview site, but for API reference and component documentation in a Swift package context, they add overhead without benefit.
- If a public-facing website beyond GitHub Pages is needed, the correct approach is to embed the DocC archive output into the static site, not to re-document the API in a separate tool.

### SourceDocs — DO NOT USE (Confidence: MEDIUM)

**Why not:**
- SourceDocs (eneko/SourceDocs) generates Markdown from Swift doc comments. It was useful before DocC existed (pre-2021) as a way to generate readable docs from source.
- DocC supersedes it entirely. SourceDocs is unmaintained as of 2024.

### SwiftDoc — DO NOT USE (Confidence: MEDIUM)

**Why not:**
- SwiftDoc (SwiftDocOrg/swift-doc) was a community attempt at API documentation before DocC. Also unmaintained post-2022. DocC made it redundant.

---

## Stack Decision Summary Table

| Tool | Role | Use It? | Confidence |
|------|------|---------|------------|
| DocC (via `swift package generate-documentation`) | Primary API reference + articles | YES | HIGH |
| Xcode `#Preview` macro | Visual component documentation | YES | HIGH |
| Triple-slash `///` doc comments | Foundation for DocC | YES — required | HIGH |
| GitHub Actions + GitHub Pages | CI/CD for docs publication | YES | HIGH |
| Jazzy | Legacy Swift API docs | NO | HIGH |
| Docusaurus / MkDocs | General static site docs | NO (for API ref) | HIGH |
| SourceDocs | Markdown from Swift comments | NO | MEDIUM |
| SwiftDoc | Community API docs | NO | MEDIUM |

---

## Project-Specific Notes

**The FocusDesignSystem → LeetPulseDesignSystem rename issue** is best solved by ensuring all doc comments and DocC article files are written fresh, not migrated from the old Markdown files in `Docs/`. The existing `Docs/` directory (DEVELOPMENT_GUIDE.md, IOS_IPADOS_ROADMAP.md, VALIDATION.md) contains operational documentation that is separate from API documentation — these can stay as Markdown files in the repo but should not be the DocC catalog.

**Four-target architecture consideration:** DocC can generate documentation for each of the four targets independently. The recommended approach for LeetPulseDesignSystem is:
1. Generate documentation for all targets in one DocC catalog using a root `.docc` bundle that imports all four target symbol graphs.
2. Organize the catalog's navigation by: Core Tokens → State & Validation → Components → Full Package overview.

**Existing `DSSampleScreens.swift`** under `Examples/` is a good preview-based documentation pattern. It should be kept and extended — but it is supplementary to, not a replacement for, DocC article-based component documentation.

---

## Sources

Note: Recommendations are grounded in knowledge of the Swift/Apple ecosystem through August 2025. The following are the primary authoritative sources for these recommendations:

- Apple Developer Documentation: "DocC — Create Rich and Engaging Documentation" (developer.apple.com/documentation/docc)
- Swift.org open-source DocC repository: github.com/apple/swift-docc
- Swift Package Index documentation hosting: swiftpackageindex.com/faq (uses DocC natively for all indexed packages)
- Apple WWDC sessions: "Meet DocC" (WWDC21), "Improve the discoverability of your Swift-DocC content" (WWDC22), "Create rich documentation with Swift-DocC" (WWDC23)
- realm/jazzy GitHub repository README (explicitly redirects to DocC for new projects as of 2024)
