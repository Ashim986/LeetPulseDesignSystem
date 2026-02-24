import FocusDesignSystemCore
import SwiftUI

/// Configuration for ``DSProgressHeader`` controlling display options and accessibility.
///
/// All fields have sensible defaults. Pass localized overrides for accessibility support.
public struct DSProgressHeaderConfig: Sendable {
    /// Whether to show a spinning progress indicator. Replaces the `isRunning` parameter
    /// from the app-side local version.
    public let showsSpinner: Bool

    /// The width of the progress bar in points.
    public let barWidth: CGFloat

    /// The VoiceOver label for the header. Defaults to `"Progress"`.
    public let accessibilityLabel: String

    /// A format string for the VoiceOver value. Receives three `Int` arguments:
    /// `tested`, `total`, and `percentage`. Defaults to `"%d of %d completed, %d%%"`.
    public let accessibilityValueFormat: String

    /// An optional accessibility identifier for UI testing.
    public let accessibilityIdentifier: String?

    /// Creates a progress header configuration.
    ///
    /// - Parameters:
    ///   - showsSpinner: Whether to display a spinning indicator. Defaults to `false`.
    ///   - barWidth: The width of the progress bar. Defaults to `60`.
    ///   - accessibilityLabel: The VoiceOver label. Defaults to `"Progress"`.
    ///   - accessibilityValueFormat: A format string for the VoiceOver value.
    ///   - accessibilityIdentifier: An optional identifier for UI testing.
    public init(
        showsSpinner: Bool = false,
        barWidth: CGFloat = 60,
        accessibilityLabel: String = "Progress",
        accessibilityValueFormat: String = "%d of %d completed, %d%%",
        accessibilityIdentifier: String? = nil
    ) {
        self.showsSpinner = showsSpinner
        self.barWidth = barWidth
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityValueFormat = accessibilityValueFormat
        self.accessibilityIdentifier = accessibilityIdentifier
    }
}

/// A progress header displaying test pass/fail counts with an animated progress bar.
///
/// Shows the number of tests executed, pass/fail breakdowns with color-coded icons,
/// and a thin horizontal progress bar. Supports reduce-motion, dynamic type, and
/// compact size class adaptation.
///
/// Usage:
/// ```swift
/// DSProgressHeader(
///     tested: 3, total: 5,
///     passed: 2, failed: 1,
///     barColor: theme.colors.warning,
///     config: .init(showsSpinner: true)
/// )
/// ```
public struct DSProgressHeader: View {
    private let tested: Int
    private let total: Int
    private let passed: Int
    private let failed: Int
    private let barColor: Color
    private let config: DSProgressHeaderConfig

    @Environment(\.dsTheme) private var theme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var sizeClass
    #endif

    /// Creates a progress header showing test execution status.
    ///
    /// - Parameters:
    ///   - tested: Number of tests that have been executed (passed + failed).
    ///   - total: Total number of test cases.
    ///   - passed: Number of tests that passed.
    ///   - failed: Number of tests that failed.
    ///   - barColor: Color for the progress bar fill.
    ///   - config: Configuration for display options and accessibility. Defaults to `.init()`.
    public init(
        tested: Int,
        total: Int,
        passed: Int,
        failed: Int,
        barColor: Color,
        config: DSProgressHeaderConfig = .init()
    ) {
        self.tested = tested
        self.total = total
        self.passed = passed
        self.failed = failed
        self.barColor = barColor
        self.config = config
    }

    public var body: some View {
        HStack(spacing: DSLayout.spacing(8)) {
            if config.showsSpinner {
                ProgressView()
                    .scaleEffect(0.6)
                    .frame(width: 12, height: 12)
            }

            Text("Test \(tested)/\(total)")
                .font(theme.typography.caption)
                .fontWeight(.semibold)
                .foregroundColor(theme.colors.textPrimary)

            if passed > 0, !isCompact {
                passedIndicator
            }

            if failed > 0, !isCompact {
                failedIndicator
            }

            Spacer()

            progressBar
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, verticalPadding)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(theme.colors.surfaceElevated)
        )
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(config.accessibilityLabel)
        .accessibilityValue(
            String(format: config.accessibilityValueFormat, tested, total, percentage)
        )
        .accessibilityAddTraits(.updatesFrequently)
        .ifLetIdentifier(config.accessibilityIdentifier)
    }

    // MARK: - Subviews

    private var passedIndicator: some View {
        HStack(spacing: 2) {
            Image(systemName: "checkmark.circle.fill")
                .font(.caption2)
            Text("\(passed)")
                .font(.caption2)
                .fontWeight(.medium)
        }
        .foregroundColor(theme.colors.success)
    }

    private var failedIndicator: some View {
        HStack(spacing: 2) {
            Image(systemName: "xmark.circle.fill")
                .font(.caption2)
            Text("\(failed)")
                .font(.caption2)
                .fontWeight(.medium)
        }
        .foregroundColor(theme.colors.danger)
    }

    /// A thin horizontal bar showing execution progress.
    private var progressBar: some View {
        GeometryReader { geo in
            let fraction = total > 0
                ? Double(tested) / Double(total) : 0
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(theme.colors.border)
                RoundedRectangle(cornerRadius: 2)
                    .fill(barColor)
                    .frame(width: geo.size.width * fraction)
                    .animation(
                        reduceMotion ? nil : .easeInOut(duration: 0.3),
                        value: fraction
                    )
            }
        }
        .frame(width: config.barWidth, height: 4)
    }

    // MARK: - Computed Properties

    private var percentage: Int {
        total > 0 ? Int(Double(tested) / Double(total) * 100) : 0
    }

    private var isCompact: Bool {
        #if os(iOS)
        return sizeClass == .compact
        #else
        return false
        #endif
    }

    // MARK: - Adaptive Layout

    private var horizontalPadding: CGFloat {
        let base = DSLayout.spacing(10)
        if dynamicTypeSize.isAccessibilitySize {
            return base + 4
        }
        if isCompact {
            return base - 2
        }
        return base
    }

    private var verticalPadding: CGFloat {
        let base = DSLayout.spacing(6)
        if dynamicTypeSize.isAccessibilitySize {
            return base + 4
        }
        return base
    }

    private var cornerRadius: CGFloat {
        dynamicTypeSize.isAccessibilitySize ? 8 : 6
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

#Preview("Light - All Passed") {
    DSThemeProvider(theme: .light) {
        DSProgressHeader(
            tested: 5, total: 5,
            passed: 5, failed: 0,
            barColor: .green
        )
        .padding()
    }
}

#Preview("Dark - All Passed") {
    DSThemeProvider(theme: .dark) {
        DSProgressHeader(
            tested: 5, total: 5,
            passed: 5, failed: 0,
            barColor: .green
        )
        .padding()
    }
}

#Preview("Light - Mixed Results") {
    DSThemeProvider(theme: .light) {
        DSProgressHeader(
            tested: 3, total: 5,
            passed: 2, failed: 1,
            barColor: .orange
        )
        .padding()
    }
}

#Preview("Dark - Mixed Results") {
    DSThemeProvider(theme: .dark) {
        DSProgressHeader(
            tested: 3, total: 5,
            passed: 2, failed: 1,
            barColor: .orange
        )
        .padding()
    }
}

#Preview("Light - Running") {
    DSThemeProvider(theme: .light) {
        DSProgressHeader(
            tested: 1, total: 5,
            passed: 1, failed: 0,
            barColor: .blue,
            config: .init(showsSpinner: true)
        )
        .padding()
    }
}

#Preview("Dark - Running") {
    DSThemeProvider(theme: .dark) {
        DSProgressHeader(
            tested: 1, total: 5,
            passed: 1, failed: 0,
            barColor: .blue,
            config: .init(showsSpinner: true)
        )
        .padding()
    }
}
