import SwiftUI

public extension DSBadge {
    /// Creates a badge styled for the given difficulty level string.
    ///
    /// Maps difficulty to badge style automatically:
    /// - "Easy" uses `.success` (green)
    /// - "Medium" uses `.warning` (amber)
    /// - "Hard" uses `.danger` (red)
    /// - Any other value uses `.neutral`
    ///
    /// Usage:
    /// ```swift
    /// DSBadge(text: "Easy", difficultyLevel: "Easy")
    /// DSBadge(text: difficulty.rawValue, difficultyLevel: difficulty.rawValue)
    /// ```
    ///
    /// - Parameters:
    ///   - text: The badge label text (e.g., "Easy", "Medium", "Hard").
    ///   - difficultyLevel: The difficulty level string determining the badge color.
    init(text: String, difficultyLevel: String) {
        self.init(text, config: DSBadgeConfig(style: Self.badgeStyle(forLevel: difficultyLevel)))
    }

    /// Returns the badge style corresponding to a difficulty level string.
    ///
    /// - Parameter level: The difficulty level string ("Easy", "Medium", "Hard").
    /// - Returns: The matching badge style, or `.neutral` for unknown values.
    static func badgeStyle(forLevel level: String) -> DSBadgeStyle {
        switch level.lowercased() {
        case "easy": .success
        case "medium": .warning
        case "hard": .danger
        default: .neutral
        }
    }

    /// Returns the theme color corresponding to a difficulty level string.
    ///
    /// - Parameters:
    ///   - level: The difficulty level string ("Easy", "Medium", "Hard").
    ///   - theme: The current design system theme.
    /// - Returns: The matching semantic color from the theme.
    static func color(forLevel level: String, theme: DSTheme) -> Color {
        switch level.lowercased() {
        case "easy": theme.colors.success
        case "medium": theme.colors.warning
        case "hard": theme.colors.danger
        default: theme.colors.textSecondary
        }
    }
}

// MARK: - Previews

#Preview("Light - All Difficulties") {
    DSThemeProvider(theme: .light) {
        HStack(spacing: 8) {
            DSBadge(text: "Easy", difficultyLevel: "Easy")
            DSBadge(text: "Medium", difficultyLevel: "Medium")
            DSBadge(text: "Hard", difficultyLevel: "Hard")
        }
        .padding()
    }
}

#Preview("Dark - All Difficulties") {
    DSThemeProvider(theme: .dark) {
        HStack(spacing: 8) {
            DSBadge(text: "Easy", difficultyLevel: "Easy")
            DSBadge(text: "Medium", difficultyLevel: "Medium")
            DSBadge(text: "Hard", difficultyLevel: "Hard")
        }
        .padding()
    }
}
