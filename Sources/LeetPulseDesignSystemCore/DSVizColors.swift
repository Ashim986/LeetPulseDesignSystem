import SwiftUI

/// Okabe-Ito colorblind-safe categorical palette for data visualizations.
///
/// Eight perceptually distinct colors that remain distinguishable across
/// the three most common forms of color vision deficiency. Each color has
/// light-mode and dark-mode variants configured via ``DSTheme``.
public struct DSVizColors: Sendable {
    // Okabe-Ito categorical palette (8 colors)
    public let primary: Color      // Orange
    public let secondary: Color    // Sky Blue
    public let tertiary: Color     // Bluish Green
    public let quaternary: Color   // Yellow
    public let quinary: Color      // Blue
    public let senary: Color       // Vermillion
    public let septenary: Color    // Reddish Purple
    public let octenary: Color     // Neutral anchor

    // Semantic aliases
    public var highlight: Color { secondary }   // Sky Blue -- attention
    public var selected: Color { primary }      // Orange -- selection
    public var error: Color { senary }          // Vermillion -- error state

    public init(
        primary: Color,
        secondary: Color,
        tertiary: Color,
        quaternary: Color,
        quinary: Color,
        senary: Color,
        septenary: Color,
        octenary: Color
    ) {
        self.primary = primary
        self.secondary = secondary
        self.tertiary = tertiary
        self.quaternary = quaternary
        self.quinary = quinary
        self.senary = senary
        self.septenary = septenary
        self.octenary = octenary
    }
}
