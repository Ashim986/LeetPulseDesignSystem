import LeetPulseDesignSystemCore
import SwiftUI

/// Configuration for ``DSCompactHeaderBar`` controlling accessibility and behavior.
///
/// All fields have sensible defaults. Pass localized overrides for accessibility support.
public struct DSCompactHeaderBarConfig: Sendable {
    /// The VoiceOver label for the header bar. Defaults to the title text.
    public let accessibilityLabel: String?

    /// An optional accessibility identifier for UI testing.
    public let accessibilityIdentifier: String?

    /// Creates a compact header bar configuration.
    ///
    /// - Parameters:
    ///   - accessibilityLabel: The VoiceOver label. When `nil`, the title text is used.
    ///   - accessibilityIdentifier: An optional identifier for UI testing.
    public init(
        accessibilityLabel: String? = nil,
        accessibilityIdentifier: String? = nil
    ) {
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityIdentifier = accessibilityIdentifier
    }
}

/// A centered header bar with an optional trailing action, used as a top bar on compact layouts.
///
/// Provides a consistent branded header with a centered title and an optional trailing view
/// (typically a button). Adapts padding for compact size classes and accessibility text sizes.
///
/// Usage:
/// ```swift
/// DSCompactHeaderBar(title: "FocusApp") {
///     Button { /* action */ } label: {
///         Image(systemName: "gearshape")
///     }
/// }
/// ```
public struct DSCompactHeaderBar<Trailing: View>: View {
    private let title: String
    private let config: DSCompactHeaderBarConfig
    private let trailing: Trailing

    @Environment(\.dsTheme) private var theme
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var sizeClass
    #endif
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    /// Creates a compact header bar with a centered title and optional trailing content.
    ///
    /// - Parameters:
    ///   - title: The centered title text. Defaults to `"FocusApp"`.
    ///   - config: Configuration for accessibility and behavior. Defaults to `.init()`.
    ///   - trailing: A view builder for optional trailing content (e.g., a settings button).
    public init(
        title: String = "FocusApp",
        config: DSCompactHeaderBarConfig = .init(),
        @ViewBuilder trailing: () -> Trailing = { EmptyView() }
    ) {
        self.title = title
        self.config = config
        self.trailing = trailing()
    }

    public var body: some View {
        HStack {
            Spacer()

            Text(title)
                .font(theme.typography.body)
                .fontWeight(.semibold)
                .foregroundColor(theme.colors.textPrimary)

            Spacer()
        }
        .overlay(alignment: .trailing) {
            trailing
                .padding(.trailing, horizontalPadding)
        }
        .frame(height: barHeight)
        .padding(.horizontal, horizontalPadding)
        .background(theme.colors.background)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isHeader)
        .accessibilityLabel(config.accessibilityLabel ?? title)
        .ifLetIdentifier(config.accessibilityIdentifier)
    }

    // MARK: - Adaptive Layout

    private var horizontalPadding: CGFloat {
        let base = theme.spacing.lg
        if dynamicTypeSize.isAccessibilitySize {
            return base + 4
        }
        #if os(iOS)
        if sizeClass == .compact {
            return base - 4
        }
        #endif
        return base
    }

    private var barHeight: CGFloat {
        dynamicTypeSize.isAccessibilitySize ? 52 : 44
    }
}

// MARK: - Helpers

private extension View {
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

#Preview("Light - Default") {
    DSThemeProvider(theme: .light) {
        DSCompactHeaderBar()
    }
}

#Preview("Dark - Default") {
    DSThemeProvider(theme: .dark) {
        DSCompactHeaderBar()
    }
}

#Preview("Light - With Trailing Button") {
    DSThemeProvider(theme: .light) {
        DSCompactHeaderBar {
            Button {} label: {
                Image(systemName: "gearshape")
                    .font(.system(.body))
            }
        }
    }
}

#Preview("Dark - With Trailing Button") {
    DSThemeProvider(theme: .dark) {
        DSCompactHeaderBar {
            Button {} label: {
                Image(systemName: "gearshape")
                    .font(.system(.body))
            }
        }
    }
}
