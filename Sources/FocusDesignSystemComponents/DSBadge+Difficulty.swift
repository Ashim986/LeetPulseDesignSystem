import FocusDesignSystemCore
import SwiftUI

public extension DSBadge {
    /// Creates a badge styled for the given difficulty level.
    ///
    /// Maps difficulty to badge style automatically:
    /// - `.easy` uses `.success` (green)
    /// - `.medium` uses `.warning` (amber)
    /// - `.hard` uses `.danger` (red)
    ///
    /// Usage:
    /// ```swift
    /// DSBadge(text: "Easy", difficulty: .easy)
    /// DSBadge(text: "Hard", difficulty: .hard)
    /// ```
    ///
    /// - Parameters:
    ///   - text: The badge label text (e.g., "Easy", "Medium", "Hard").
    ///   - difficulty: The difficulty level determining the badge color.
    init(text: String, difficulty: Difficulty) {
        self.init(text, config: DSBadgeConfig(style: Self.badgeStyle(for: difficulty)))
    }

    /// Returns the badge style corresponding to a difficulty level.
    ///
    /// - Parameter difficulty: The difficulty level.
    /// - Returns: The matching badge style.
    static func badgeStyle(for difficulty: Difficulty) -> DSBadgeStyle {
        switch difficulty {
        case .easy: .success
        case .medium: .warning
        case .hard: .danger
        }
    }

    /// Returns the theme color corresponding to a difficulty level.
    ///
    /// - Parameters:
    ///   - difficulty: The difficulty level.
    ///   - theme: The current design system theme.
    /// - Returns: The matching semantic color from the theme.
    static func color(for difficulty: Difficulty, theme: DSTheme) -> Color {
        switch difficulty {
        case .easy: theme.colors.success
        case .medium: theme.colors.warning
        case .hard: theme.colors.danger
        }
    }
}

// MARK: - Previews

#Preview("Light - All Difficulties") {
    DSThemeProvider(theme: .light) {
        HStack(spacing: 8) {
            DSBadge(text: "Easy", difficulty: .easy)
            DSBadge(text: "Medium", difficulty: .medium)
            DSBadge(text: "Hard", difficulty: .hard)
        }
        .padding()
    }
}

#Preview("Dark - All Difficulties") {
    DSThemeProvider(theme: .dark) {
        HStack(spacing: 8) {
            DSBadge(text: "Easy", difficulty: .easy)
            DSBadge(text: "Medium", difficulty: .medium)
            DSBadge(text: "Hard", difficulty: .hard)
        }
        .padding()
    }
}
