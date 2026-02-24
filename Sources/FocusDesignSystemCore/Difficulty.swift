import Foundation

/// Represents problem difficulty levels used throughout the design system.
///
/// Maps to badge styles and theme colors for visual differentiation:
/// - `.easy` renders with success styling (green)
/// - `.medium` renders with warning styling (amber/orange)
/// - `.hard` renders with danger styling (red)
public enum Difficulty: String, Codable, CaseIterable, Sendable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
}
