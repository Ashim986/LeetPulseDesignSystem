import SwiftUI

// MARK: - Variant

/// Visual variant for a ``DSStatusCard``, determining the leading tint bar color.
///
/// Each variant maps to a semantic theme color by default. Pass a custom `tintColor`
/// to the card initializer to override.
public enum DSStatusCardVariant: String, Sendable, CaseIterable {
    case success
    case failure
    case warning
    case loading
    case neutral

    /// Returns the default tint color for this variant using the given theme colors.
    public func defaultTintColor(_ colors: DSColors) -> Color {
        switch self {
        case .success: colors.success
        case .failure: colors.danger
        case .warning: colors.warning
        case .loading: colors.border
        case .neutral: colors.textSecondary
        }
    }
}

// MARK: - Configuration

/// Configuration for ``DSStatusCard`` appearance and accessibility.
public struct DSStatusCardConfig: Sendable {
    /// Corner radius for the card. macOS typically uses 8, iOS uses 10.
    public let cornerRadius: CGFloat
    /// Width of the leading tint bar.
    public let borderWidth: CGFloat
    /// VoiceOver label for the card. If `nil`, children are combined for the label.
    public let accessibilityLabel: String?
    /// Optional Xcode accessibility identifier for UI testing.
    public let accessibilityIdentifier: String?

    public init(
        cornerRadius: CGFloat = 8,
        borderWidth: CGFloat = 4,
        accessibilityLabel: String? = nil,
        accessibilityIdentifier: String? = nil
    ) {
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityIdentifier = accessibilityIdentifier
    }
}

// MARK: - View

/// A themed card with a leading tint bar, used for status indicators and result displays.
///
/// Replaces the duplicated left-border card pattern found in submission result views
/// on both macOS and iOS. The card owns hover interaction state and respects reduce-motion.
///
/// ```swift
/// DSStatusCard(variant: .success) {
///     HStack {
///         Image(systemName: "checkmark.circle.fill")
///         Text("Accepted")
///     }
/// }
///
/// DSStatusCard(
///     variant: .failure,
///     config: .init(cornerRadius: 10)
/// ) {
///     Text("Wrong Answer (2/5 passed)")
/// }
/// ```
public struct DSStatusCard<Content: View>: View {
    private let variant: DSStatusCardVariant
    private let tintColor: Color?
    private let config: DSStatusCardConfig
    private let content: Content

    @Environment(\.dsTheme) private var theme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.horizontalSizeClass) private var sizeClass
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @State private var isHovered: Bool = false

    /// Creates a status card with a variant-based or custom tint color.
    ///
    /// - Parameters:
    ///   - variant: The semantic variant (`.success`, `.failure`, `.warning`, `.loading`, `.neutral`).
    ///   - tintColor: Optional override for the leading bar color. Falls back to the variant default.
    ///   - config: Appearance and accessibility overrides.
    ///   - content: The card content via `@ViewBuilder`.
    public init(
        variant: DSStatusCardVariant,
        tintColor: Color? = nil,
        config: DSStatusCardConfig = .init(),
        @ViewBuilder content: () -> Content
    ) {
        self.variant = variant
        self.tintColor = tintColor
        self.config = config
        self.content = content()
    }

    public var body: some View {
        let isAccessibilitySize = dynamicTypeSize.isAccessibilitySize
        let isCompact = sizeClass == .compact
        let horizontalPadding: CGFloat = isCompact ? 8 : (isAccessibilitySize ? 14 : 10)
        let verticalPadding: CGFloat = isCompact ? 8 : (isAccessibilitySize ? 12 : 8)
        let resolvedTint = tintColor ?? variant.defaultTintColor(theme.colors)
        let resolvedCornerRadius = isAccessibilitySize
            ? config.cornerRadius + 4
            : config.cornerRadius

        content
            .padding(.horizontal, DSLayout.spacing(horizontalPadding))
            .padding(.vertical, DSLayout.spacing(verticalPadding))
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: resolvedCornerRadius)
                    .fill(theme.colors.surfaceElevated)
            )
            .overlay(alignment: .leading) {
                RoundedRectangle(cornerRadius: resolvedCornerRadius)
                    .fill(resolvedTint)
                    .frame(width: config.borderWidth)
            }
            .clipShape(RoundedRectangle(cornerRadius: resolvedCornerRadius))
            .onHover { isHovered = $0 }
            .scaleEffect(isHovered && !reduceMotion ? 1.01 : 1.0)
            .animation(
                reduceMotion ? nil : .easeOut(duration: 0.15),
                value: isHovered
            )
            .accessibilityElement(children: .combine)
            .accessibilityAddTraits(.isSummaryElement)
            .ifLetAccessibilityLabel(config.accessibilityLabel)
            .ifLetIdentifier(config.accessibilityIdentifier)
    }
}

// MARK: - Helpers

private extension View {
    @ViewBuilder
    func ifLetAccessibilityLabel(_ label: String?) -> some View {
        if let label {
            self.accessibilityLabel(label)
        } else {
            self
        }
    }

    @ViewBuilder
    func ifLetIdentifier(_ identifier: String?) -> some View {
        if let identifier {
            self.accessibilityIdentifier(identifier)
        } else {
            self
        }
    }
}

// MARK: - Previews

#Preview("Success") {
    DSThemeProvider(theme: .dark) {
        DSStatusCard(variant: .success) {
            HStack(spacing: 6) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                Text("Accepted (5/5 passed)")
                    .font(.system(size: 12, weight: .semibold))
            }
        }
        .padding()
    }
}

#Preview("Failure") {
    DSThemeProvider(theme: .light) {
        DSStatusCard(variant: .failure) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                    Text("Wrong Answer (2/5 passed)")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.red)
                }
                Text("Expected [1,2,3] but got [1,3,2]")
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(.secondary)
            }
        }
        .padding()
    }
}

#Preview("Warning") {
    DSThemeProvider(theme: .dark) {
        DSStatusCard(variant: .warning) {
            HStack(spacing: 6) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.orange)
                Text("Time Limit Exceeded")
                    .font(.system(size: 12, weight: .semibold))
            }
        }
        .padding()
    }
}

#Preview("Loading") {
    DSThemeProvider(theme: .light) {
        DSStatusCard(variant: .loading) {
            HStack(spacing: 8) {
                ProgressView()
                    .scaleEffect(0.7)
                    .frame(width: 14, height: 14)
                Text("Submitting...")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
            }
        }
        .padding()
    }
}
