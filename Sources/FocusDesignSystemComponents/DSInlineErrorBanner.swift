import FocusDesignSystemCore
import SwiftUI

// MARK: - Configuration

/// Configuration for ``DSInlineErrorBanner`` appearance and accessibility.
///
/// All fields have sensible defaults. Pass localized overrides as needed.
///
/// ```swift
/// DSInlineErrorBannerConfig(
///     retryTitle: "Try Again",
///     accessibilityLabel: "Network Error"
/// )
/// ```
public struct DSInlineErrorBannerConfig: Sendable {
    /// Title for the retry button.
    public let retryTitle: String
    /// Optional icon displayed before the message. Defaults to a warning triangle.
    public let icon: Image?
    /// VoiceOver label for the entire banner.
    public let accessibilityLabel: String
    /// VoiceOver hint describing the retry action.
    public let accessibilityHint: String
    /// Optional Xcode accessibility identifier for UI testing.
    public let accessibilityIdentifier: String?

    public init(
        retryTitle: String = "Retry",
        icon: Image? = Image(systemName: "exclamationmark.triangle.fill"),
        accessibilityLabel: String = "Error",
        accessibilityHint: String = "Double tap to retry",
        accessibilityIdentifier: String? = nil
    ) {
        self.retryTitle = retryTitle
        self.icon = icon
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityHint = accessibilityHint
        self.accessibilityIdentifier = accessibilityIdentifier
    }
}

// MARK: - View

/// An inline error banner with a retry button, styled with the theme's danger color.
///
/// Accepts a plain `String` message (not app-specific error types) so the design system
/// stays decoupled from business models.
///
/// ```swift
/// DSInlineErrorBanner(message: "Connection failed") {
///     retryAction()
/// }
///
/// DSInlineErrorBanner(
///     message: "Timeout",
///     detail: "The server did not respond within 30 seconds.",
///     config: .init(retryTitle: "Try Again"),
///     onRetry: { retryAction() }
/// )
/// ```
public struct DSInlineErrorBanner: View {
    private let message: String
    private let detail: String?
    private let config: DSInlineErrorBannerConfig
    private let onRetry: () -> Void

    @Environment(\.dsTheme) private var theme
    @Environment(\.horizontalSizeClass) private var sizeClass
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    /// Creates an inline error banner.
    ///
    /// - Parameters:
    ///   - message: Primary error message.
    ///   - detail: Optional secondary description.
    ///   - config: Appearance and accessibility overrides.
    ///   - onRetry: Action triggered when the retry button is tapped.
    public init(
        message: String,
        detail: String? = nil,
        config: DSInlineErrorBannerConfig = .init(),
        onRetry: @escaping () -> Void
    ) {
        self.message = message
        self.detail = detail
        self.config = config
        self.onRetry = onRetry
    }

    public var body: some View {
        let isCompact = sizeClass == .compact
        let isAccessibilitySize = dynamicTypeSize.isAccessibilitySize
        let contentPadding: CGFloat = isAccessibilitySize ? 16 : 12
        let contentSpacing: CGFloat = isAccessibilitySize ? 12 : 8

        Group {
            if isCompact || isAccessibilitySize {
                verticalLayout(spacing: contentSpacing)
            } else {
                horizontalLayout(spacing: contentSpacing)
            }
        }
        .padding(.horizontal, contentPadding)
        .padding(.vertical, isAccessibilitySize ? 12 : 8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(theme.colors.danger.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: isAccessibilitySize ? 10 : 6))
        .accessibilityElement(children: .combine)
        .accessibilityLabel(config.accessibilityLabel + ": " + message)
        .accessibilityHint(config.accessibilityHint)
        .accessibilityAddTraits(.isStaticText)
        .ifLetIdentifier(config.accessibilityIdentifier)
    }

    // MARK: - Layouts

    private func horizontalLayout(spacing: CGFloat) -> some View {
        HStack(spacing: spacing) {
            iconView
            textContent
            Spacer()
            retryButton
        }
    }

    private func verticalLayout(spacing: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: spacing) {
            HStack(spacing: spacing) {
                iconView
                textContent
            }
            retryButton
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Subviews

    @ViewBuilder
    private var iconView: some View {
        if let icon = config.icon {
            icon
                .font(.caption)
                .foregroundColor(.white)
        }
    }

    private var textContent: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(message)
                .font(theme.typography.caption)
                .foregroundColor(.white)
                .lineLimit(2)
            if let detail {
                Text(detail)
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.8))
            }
        }
    }

    private var retryButton: some View {
        DSButton(
            config.retryTitle,
            config: .init(
                style: .secondary,
                size: .small,
                icon: Image(systemName: "arrow.clockwise")
            ),
            action: onRetry
        )
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

#Preview("Error with retry") {
    DSThemeProvider(theme: .dark) {
        DSInlineErrorBanner(message: "Connection timed out. Please check your network.") {
            // retry
        }
        .padding()
    }
}

#Preview("Error with detail") {
    DSThemeProvider(theme: .light) {
        DSInlineErrorBanner(
            message: "Compilation failed",
            detail: "Line 42: expected ';' after expression",
            config: .init(retryTitle: "Try Again")
        ) {
            // retry
        }
        .padding()
    }
}
