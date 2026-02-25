import SwiftUI

// MARK: - Line Style

/// Visual style for a console output line, determining its color and optional icon.
///
/// Use the ``detect(from:)`` static method to auto-classify a line based on its content.
///
/// ```swift
/// let style = DSConsoleLineStyle.detect(from: "ERROR: file not found")
/// // style == .error
/// ```
public enum DSConsoleLineStyle: String, Sendable, CaseIterable {
    case normal
    case error
    case warning
    case info
    case success

    /// Returns the appropriate color for this line style using the given theme.
    public func color(theme: DSTheme) -> Color {
        switch self {
        case .normal: theme.colors.textPrimary
        case .error: theme.colors.danger
        case .warning: theme.colors.warning
        case .info: theme.colors.accent
        case .success: theme.colors.success
        }
    }

    /// Optional SF Symbol icon name for this line style.
    public var icon: String? {
        switch self {
        case .normal: nil
        case .error: "xmark.circle.fill"
        case .warning: "exclamationmark.triangle.fill"
        case .info: "info.circle.fill"
        case .success: "checkmark.circle.fill"
        }
    }

    /// Detects the line style from the text content by scanning for keywords.
    ///
    /// Checks for error, warning, info, and success patterns commonly seen in
    /// compiler and runtime output.
    ///
    /// - Parameter text: The raw line content.
    /// - Returns: The detected style, defaulting to `.normal`.
    public static func detect(from text: String) -> DSConsoleLineStyle {
        let lowercased = text.lowercased()

        if lowercased.contains("error") || lowercased.contains("exception") ||
            lowercased.contains("fatal") || lowercased.contains("failed") ||
            text.hasPrefix("E ") || text.hasPrefix("[ERROR]") ||
            text.hasPrefix("[E]")
        {
            return .error
        }

        if lowercased.contains("warning") || lowercased.contains("warn") ||
            text.hasPrefix("W ") || text.hasPrefix("[WARNING]") ||
            text.hasPrefix("[WARN]") || text.hasPrefix("[W]")
        {
            return .warning
        }

        if lowercased.contains("[info]") || lowercased.contains("[debug]") ||
            text.hasPrefix("I ") || text.hasPrefix("D ") ||
            text.hasPrefix("[I]") || text.hasPrefix("[D]")
        {
            return .info
        }

        if lowercased.contains("success") || lowercased.contains("passed") ||
            lowercased.contains("completed") || lowercased.contains("\u{2713}") ||
            lowercased.contains("done")
        {
            return .success
        }

        return .normal
    }
}

// MARK: - Line Protocol

/// Protocol for types that can be rendered as a console output line.
///
/// Conform your app-side output model to this protocol and pass it directly
/// to ``DSConsoleOutput``.
///
/// ```swift
/// extension ExecutionOutputLine: DSConsoleLineRepresentable {
///     var style: DSConsoleLineStyle { isError ? .error : .normal }
/// }
/// ```
public protocol DSConsoleLineRepresentable: Identifiable, Sendable {
    /// The text content of the line.
    var text: String { get }
    /// The 1-based line number.
    var lineNumber: Int { get }
    /// The visual style for this line.
    var style: DSConsoleLineStyle { get }
}

// MARK: - Default Line

/// Default implementation of ``DSConsoleLineRepresentable`` for simple use cases.
///
/// Auto-detects the line style from its text content.
public struct DSConsoleLine: DSConsoleLineRepresentable, Sendable {
    public let id: UUID
    public let text: String
    public let lineNumber: Int
    public let style: DSConsoleLineStyle

    public init(
        text: String,
        lineNumber: Int,
        style: DSConsoleLineStyle? = nil
    ) {
        self.id = UUID()
        self.text = text
        self.lineNumber = lineNumber
        self.style = style ?? DSConsoleLineStyle.detect(from: text)
    }
}

// MARK: - Configuration

/// Configuration for ``DSConsoleOutput`` appearance and accessibility.
public struct DSConsoleOutputConfig: Sendable {
    /// Whether to show line numbers in the gutter.
    public let showLineNumbers: Bool
    /// Whether to show the copy button (requires `onCopy` closure).
    public let showCopyButton: Bool
    /// Whether to show type icons next to lines with non-normal styles.
    public let showTypeIcons: Bool
    /// VoiceOver label for the entire console output.
    public let accessibilityLabel: String
    /// Optional Xcode accessibility identifier for UI testing.
    public let accessibilityIdentifier: String?

    public init(
        showLineNumbers: Bool = true,
        showCopyButton: Bool = true,
        showTypeIcons: Bool = true,
        accessibilityLabel: String = "Console output",
        accessibilityIdentifier: String? = nil
    ) {
        self.showLineNumbers = showLineNumbers
        self.showCopyButton = showCopyButton
        self.showTypeIcons = showTypeIcons
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityIdentifier = accessibilityIdentifier
    }
}

// MARK: - View

/// A themed console output view with line numbers, syntax coloring, and an optional copy action.
///
/// Accepts any type conforming to ``DSConsoleLineRepresentable``, or use the convenience
/// initializer with a raw `String` for auto-parsing.
///
/// ```swift
/// // Raw string convenience
/// DSConsoleOutput(output: compilerOutput) { text in
///     UIPasteboard.general.string = text
/// }
///
/// // Generic typed lines
/// DSConsoleOutput(lines: myLines, config: .init(showLineNumbers: false))
/// ```
public struct DSConsoleOutput<Line: DSConsoleLineRepresentable>: View {
    private let lines: [Line]
    private let config: DSConsoleOutputConfig
    private let onCopy: ((String) -> Void)?

    @Environment(\.dsTheme) private var theme
    @Environment(\.horizontalSizeClass) private var sizeClass
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    /// Creates a console output view with pre-parsed lines.
    ///
    /// - Parameters:
    ///   - lines: Array of line objects conforming to ``DSConsoleLineRepresentable``.
    ///   - config: Appearance and accessibility overrides.
    ///   - onCopy: Platform-agnostic copy callback. Pass `nil` to hide the copy button.
    public init(
        lines: [Line],
        config: DSConsoleOutputConfig = .init(),
        onCopy: ((String) -> Void)? = nil
    ) {
        self.lines = lines
        self.config = config
        self.onCopy = onCopy
    }

    public var body: some View {
        let isAccessibilitySize = dynamicTypeSize.isAccessibilitySize
        let isCompact = sizeClass == .compact
        let shouldShowLineNumbers = config.showLineNumbers && !isCompact
        let lineSpacing: CGFloat = isAccessibilitySize ? 6 : 2

        Group {
            if lines.isEmpty {
                emptyPlaceholder
            } else {
                VStack(alignment: .leading, spacing: DSLayout.spacing(0)) {
                    ForEach(lines) { line in
                        lineRow(
                            line,
                            showLineNumbers: shouldShowLineNumbers,
                            lineSpacing: lineSpacing
                        )
                    }
                }
            }
        }
        .padding(isAccessibilitySize ? DSLayout.spacing(12) : DSLayout.spacing(8))
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(theme.colors.surfaceElevated.opacity(0.6))
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(theme.colors.border, lineWidth: 1)
                )
        )
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(config.accessibilityLabel)
        .accessibilityValue("\(lines.count) lines")
        .accessibilityAddTraits(.isStaticText)
        .ifLetIdentifier(config.accessibilityIdentifier)
    }

    // MARK: - Subviews

    private var emptyPlaceholder: some View {
        Text("No output")
            .font(theme.typography.caption)
            .foregroundColor(theme.colors.textSecondary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func lineRow(
        _ line: Line,
        showLineNumbers: Bool,
        lineSpacing: CGFloat
    ) -> some View {
        let lineColor = line.style.color(theme: theme)
        return HStack(alignment: .top, spacing: DSLayout.spacing(0)) {
            if showLineNumbers {
                Text("\(line.lineNumber)")
                    .font(theme.typography.mono)
                    .foregroundColor(theme.colors.textSecondary)
                    .frame(width: 28, alignment: .trailing)
                    .padding(.trailing, DSLayout.spacing(8))

                Rectangle()
                    .fill(theme.colors.border)
                    .frame(width: 1)
                    .padding(.trailing, DSLayout.spacing(8))
            }

            if config.showTypeIcons, let icon = line.style.icon {
                Image(systemName: icon)
                    .font(.caption2)
                    .foregroundColor(lineColor)
                    .frame(width: 12)
                    .padding(.trailing, DSLayout.spacing(4))
            }

            Text(line.text.isEmpty ? " " : line.text)
                .font(theme.typography.mono)
                .foregroundColor(lineColor)
                .textSelection(.enabled)

            Spacer(minLength: 0)

            if config.showCopyButton, let onCopy {
                Button {
                    onCopy(line.text)
                } label: {
                    Image(systemName: "doc.on.doc")
                        .font(.caption2)
                        .foregroundColor(theme.colors.textSecondary)
                }
                .buttonStyle(.plain)
                .padding(.leading, DSLayout.spacing(8))
                .accessibilityLabel("Copy line \(line.lineNumber)")
            }
        }
        .padding(.vertical, lineSpacing)
        .background(lineBackground(for: line.style))
    }

    private func lineBackground(for style: DSConsoleLineStyle) -> Color {
        switch style {
        case .error: theme.colors.danger.opacity(0.1)
        case .warning: theme.colors.warning.opacity(0.1)
        default: Color.clear
        }
    }
}

// MARK: - Raw String Convenience

public extension DSConsoleOutput where Line == DSConsoleLine {
    /// Creates a console output view from a raw output string.
    ///
    /// Each line is auto-parsed and classified using ``DSConsoleLineStyle/detect(from:)``.
    ///
    /// - Parameters:
    ///   - output: Raw multi-line string (e.g., compiler or runtime output).
    ///   - config: Appearance and accessibility overrides.
    ///   - onCopy: Platform-agnostic copy callback. Pass `nil` to hide the copy button.
    init(
        output: String,
        config: DSConsoleOutputConfig = .init(),
        onCopy: ((String) -> Void)? = nil
    ) {
        let parsed = output.components(separatedBy: "\n").enumerated().map { index, content in
            DSConsoleLine(text: content, lineNumber: index + 1)
        }
        self.init(lines: parsed, config: config, onCopy: onCopy)
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

#Preview("Normal Output") {
    DSThemeProvider(theme: .dark) {
        DSConsoleOutput(
            output: "Starting build...\nCompiling main.swift\nLinking executable\nBuild completed successfully"
        )
        .padding()
    }
}

#Preview("Mixed Error/Warning") {
    DSThemeProvider(theme: .light) {
        DSConsoleOutput(
            output: """
            Compiling Solution.swift
            [WARNING] Unused variable 'temp' at line 12
            Running test cases...
            ERROR: expected [1,2,3] but got [1,3,2]
            Test failed: case 3
            2 of 3 tests passed
            """
        ) { text in
            // copy callback
        }
        .padding()
    }
}

#Preview("Empty") {
    DSThemeProvider(theme: .dark) {
        DSConsoleOutput(output: "")
            .padding()
    }
}
