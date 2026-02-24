import LeetPulseDesignSystemCore
import SwiftUI

// MARK: - Configuration

/// Configuration for ``DSExpandableText`` appearance and accessibility.
///
/// ```swift
/// DSExpandableTextConfig(
///     lineLimit: 5,
///     expandLabel: "Read more",
///     collapseLabel: "Read less"
/// )
/// ```
public struct DSExpandableTextConfig: Sendable {
    /// Maximum number of lines shown when collapsed.
    public let lineLimit: Int
    /// Label for the expand button.
    public let expandLabel: String
    /// Label for the collapse button.
    public let collapseLabel: String
    /// Font for the text content. Defaults to monospaced caption for code output.
    public let font: Font
    /// VoiceOver label for the entire component.
    public let accessibilityLabel: String
    /// Optional Xcode accessibility identifier for UI testing.
    public let accessibilityIdentifier: String?

    public init(
        lineLimit: Int = 3,
        expandLabel: String = "Show more",
        collapseLabel: String = "Show less",
        font: Font = .system(size: 11, design: .monospaced),
        accessibilityLabel: String = "Expandable text",
        accessibilityIdentifier: String? = nil
    ) {
        self.lineLimit = lineLimit
        self.expandLabel = expandLabel
        self.collapseLabel = collapseLabel
        self.font = font
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityIdentifier = accessibilityIdentifier
    }
}

// MARK: - View

/// A text view that truncates long content with a show more/less toggle.
///
/// Owns its expansion state internally -- the parent does not need to manage it.
/// Respects reduce-motion by suppressing the expand/collapse animation.
///
/// ```swift
/// DSExpandableText(text: longErrorMessage)
///
/// DSExpandableText(
///     text: compilerOutput,
///     config: .init(lineLimit: 5, expandLabel: "Read full output")
/// )
/// ```
public struct DSExpandableText: View {
    private let text: String
    private let config: DSExpandableTextConfig

    @State private var isExpanded: Bool = false
    @Environment(\.dsTheme) private var theme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    /// Creates an expandable text view.
    ///
    /// - Parameters:
    ///   - text: The full text content. Lines are split by newline characters.
    ///   - config: Appearance and accessibility overrides.
    public init(
        text: String,
        config: DSExpandableTextConfig = .init()
    ) {
        self.text = text
        self.config = config
    }

    public var body: some View {
        let lines = text.components(separatedBy: "\n")
        let needsTruncation = lines.count > config.lineLimit
        let isAccessibilitySize = dynamicTypeSize.isAccessibilitySize
        let contentPadding: CGFloat = isAccessibilitySize ? 8 : 4

        VStack(alignment: .leading, spacing: DSLayout.spacing(contentPadding)) {
            Text(isExpanded || !needsTruncation ? text : truncatedText(lines))
                .font(config.font)
                .foregroundColor(theme.colors.textSecondary)
                .textSelection(.enabled)
                .frame(maxWidth: .infinity, alignment: .leading)

            if needsTruncation {
                Button {
                    if reduceMotion {
                        isExpanded.toggle()
                    } else {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isExpanded.toggle()
                        }
                    }
                } label: {
                    Text(isExpanded ? config.collapseLabel : config.expandLabel)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(theme.colors.primary)
                }
                .buttonStyle(.plain)
                .accessibilityAddTraits(.isButton)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(config.accessibilityLabel)
        .accessibilityValue(isExpanded ? "expanded" : "collapsed")
        .accessibilityHint("Double tap to " + (isExpanded ? "collapse" : "expand"))
        .ifLetIdentifier(config.accessibilityIdentifier)
    }

    // MARK: - Truncation

    private func truncatedText(_ lines: [String]) -> String {
        if lines.count <= config.lineLimit {
            return text
        }
        return lines.prefix(config.lineLimit).joined(separator: "\n") + "..."
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

#Preview("Short text (no truncation)") {
    DSThemeProvider(theme: .light) {
        DSExpandableText(
            text: "Line 1: error\nLine 2: detail"
        )
        .padding()
    }
}

#Preview("Long text (truncates)") {
    DSThemeProvider(theme: .dark) {
        DSExpandableText(
            text: """
            error: cannot convert value of type 'String' to expected argument type 'Int'
            note: in argument to function 'calculate'
            note: defined at line 42 in Solution.swift
            error: missing return in function expected to return 'Int'
            note: add 'return' statement
            warning: variable 'temp' was never used
            """
        )
        .padding()
    }
}
