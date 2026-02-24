import SwiftUI

public enum DSThemeKind: String, Sendable {
    case light
    case dark
}

public struct DSColors: Sendable {
    public let background: Color
    public let surface: Color
    public let surfaceElevated: Color
    public let primary: Color
    public let secondary: Color
    public let accent: Color
    public let textPrimary: Color
    public let textSecondary: Color
    public let border: Color
    public let success: Color
    public let warning: Color
    public let danger: Color

    public init(
        background: Color,
        surface: Color,
        surfaceElevated: Color,
        primary: Color,
        secondary: Color,
        accent: Color,
        textPrimary: Color,
        textSecondary: Color,
        border: Color,
        success: Color,
        warning: Color,
        danger: Color
    ) {
        self.background = background
        self.surface = surface
        self.surfaceElevated = surfaceElevated
        self.primary = primary
        self.secondary = secondary
        self.accent = accent
        self.textPrimary = textPrimary
        self.textSecondary = textSecondary
        self.border = border
        self.success = success
        self.warning = warning
        self.danger = danger
    }
}

// MARK: - DSColors Utility Tokens

public extension DSColors {
    /// Transparent surface -- use via `theme.colors.surfaceClear` instead of `Color.clear`.
    var surfaceClear: Color { Color.clear }

    /// High-contrast foreground for use on top of visualization colors.
    var foregroundOnViz: Color { Color.white }

    /// Dimmed text for disabled controls.
    var textDisabled: Color { textSecondary.opacity(0.6) }
}

public struct DSTypography: Sendable {
    public let title: Font
    public let subtitle: Font
    public let body: Font
    public let caption: Font
    public let mono: Font

    public init(
        title: Font,
        subtitle: Font,
        body: Font,
        caption: Font,
        mono: Font
    ) {
        self.title = title
        self.subtitle = subtitle
        self.body = body
        self.caption = caption
        self.mono = mono
    }
}

public struct DSSpacing: Sendable {
    public let xs: CGFloat
    public let sm: CGFloat
    public let md: CGFloat
    public let lg: CGFloat
    public let xl: CGFloat

    public init(xs: CGFloat, sm: CGFloat, md: CGFloat, lg: CGFloat, xl: CGFloat) {
        self.xs = xs
        self.sm = sm
        self.md = md
        self.lg = lg
        self.xl = xl
    }
}

public struct DSRadii: Sendable {
    public let sm: CGFloat
    public let md: CGFloat
    public let lg: CGFloat
    public let pill: CGFloat

    public init(sm: CGFloat, md: CGFloat, lg: CGFloat, pill: CGFloat) {
        self.sm = sm
        self.md = md
        self.lg = lg
        self.pill = pill
    }
}

public struct DSShadow: Sendable {
    public let color: Color
    public let radius: CGFloat
    public let x: CGFloat
    public let y: CGFloat

    public init(color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) {
        self.color = color
        self.radius = radius
        self.x = x
        self.y = y
    }
}

public struct DSTheme: Sendable {
    public let kind: DSThemeKind
    public let colors: DSColors
    public let vizColors: DSVizColors
    public let gradients: DSGradients
    public let typography: DSTypography
    public let spacing: DSSpacing
    public let radii: DSRadii
    public let shadow: DSShadow

    public init(
        kind: DSThemeKind,
        colors: DSColors,
        vizColors: DSVizColors,
        gradients: DSGradients,
        typography: DSTypography,
        spacing: DSSpacing,
        radii: DSRadii,
        shadow: DSShadow
    ) {
        self.kind = kind
        self.colors = colors
        self.vizColors = vizColors
        self.gradients = gradients
        self.typography = typography
        self.spacing = spacing
        self.radii = radii
        self.shadow = shadow
    }
}

// MARK: - Color(hex: String)

public extension Color {
    /// Creates a color from a 6-digit hex string (e.g. "E69F00").
    /// Leading "#" or "0x" prefixes are stripped automatically.
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let red, green, blue: UInt64
        switch hex.count {
        case 6:
            (red, green, blue) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            (red, green, blue) = (0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(red) / 255,
            green: Double(green) / 255,
            blue: Double(blue) / 255,
            opacity: 1
        )
    }
}

// MARK: - Light and Dark Themes

public extension DSTheme {
    static let light = DSTheme(
        kind: .light,
        colors: DSColors(
            background: Color(hex: "F8F7FC"),          // Light purple tint
            surface: Color.white,
            surfaceElevated: Color(hex: "F0EFF6"),     // Light elevated
            primary: Color(hex: "6B4EE6"),             // Slightly deeper purple
            secondary: Color(red: 0.28, green: 0.33, blue: 0.41),
            accent: Color(hex: "00B894"),              // Slightly muted cyan
            textPrimary: Color(hex: "1A1A2E"),         // Dark purple-black
            textSecondary: Color(red: 0.42, green: 0.42, blue: 0.50),
            border: Color(hex: "E0DFF0"),              // Subtle light border
            success: Color(red: 0.09, green: 0.64, blue: 0.29),
            warning: Color(red: 0.96, green: 0.62, blue: 0.04),
            danger: Color(red: 0.86, green: 0.15, blue: 0.15)
        ),
        vizColors: DSVizColors(
            primary: Color(hex: "E69F00"),     // Orange
            secondary: Color(hex: "56B4E9"),   // Sky Blue
            tertiary: Color(hex: "009E73"),    // Bluish Green
            quaternary: Color(hex: "F0E442"),  // Yellow
            quinary: Color(hex: "0072B2"),     // Blue
            senary: Color(hex: "D55E00"),      // Vermillion
            septenary: Color(hex: "CC79A7"),   // Reddish Purple
            octenary: Color(hex: "000000")     // Black
        ),
        gradients: DSGradients(
            purpleGradient: LinearGradient(
                colors: [Color(hex: "6B4EE6"), Color(hex: "7C5CFC")],
                startPoint: .leading,
                endPoint: .trailing
            ),
            indigoGradient: LinearGradient(
                colors: [Color(hex: "1A1A2E"), Color(hex: "2D2B55")],
                startPoint: .top,
                endPoint: .bottom
            )
        ),
        typography: DSTypography(
            title: .system(size: 22, weight: .bold),
            subtitle: .system(size: 15, weight: .semibold),
            body: .system(size: 13, weight: .regular),
            caption: .system(size: 11, weight: .regular),
            mono: .system(size: 12, weight: .regular, design: .monospaced)
        ),
        spacing: DSSpacing(xs: 4, sm: 8, md: 12, lg: 16, xl: 24),
        radii: DSRadii(sm: 6, md: 10, lg: 16, pill: 999),
        shadow: DSShadow(
            color: Color.black.opacity(0.12),
            radius: 8,
            x: 0,
            y: 3
        )
    )

    static let dark = DSTheme(
        kind: .dark,
        colors: DSColors(
            background: Color(hex: "0F0F14"),          // Near-black purple
            surface: Color(hex: "1A1A24"),             // Dark card
            surfaceElevated: Color(hex: "242434"),     // Elevated dark
            primary: Color(hex: "7C5CFC"),             // Vibrant purple
            secondary: Color(red: 0.58, green: 0.64, blue: 0.73),
            accent: Color(hex: "00D4AA"),              // Bright cyan
            textPrimary: Color(hex: "F0F0F5"),         // Off-white
            textSecondary: Color(hex: "8888A0"),       // Muted
            border: Color(hex: "2A2A3A"),              // Subtle dark
            success: Color(red: 0.29, green: 0.87, blue: 0.5),
            warning: Color(red: 0.98, green: 0.75, blue: 0.21),
            danger: Color(red: 0.97, green: 0.44, blue: 0.44)
        ),
        vizColors: DSVizColors(
            primary: Color(hex: "FFB733"),     // Lightened Orange
            secondary: Color(hex: "7CC8F0"),   // Lightened Sky Blue
            tertiary: Color(hex: "33C49A"),    // Lightened Bluish Green
            quaternary: Color(hex: "F5ED6E"),  // Lightened Yellow
            quinary: Color(hex: "3399CC"),     // Lightened Blue
            senary: Color(hex: "FF8533"),      // Lightened Vermillion
            septenary: Color(hex: "DDA0C0"),   // Lightened Reddish Purple
            octenary: Color(hex: "FFFFFF")     // White
        ),
        gradients: DSGradients(
            purpleGradient: LinearGradient(
                colors: [Color(hex: "7C5CFC"), Color(hex: "9B7DFF")],
                startPoint: .leading,
                endPoint: .trailing
            ),
            indigoGradient: LinearGradient(
                colors: [Color(hex: "0F0F14"), Color(hex: "1A1A2E")],
                startPoint: .top,
                endPoint: .bottom
            )
        ),
        typography: DSTypography(
            title: .system(size: 22, weight: .bold),
            subtitle: .system(size: 15, weight: .semibold),
            body: .system(size: 13, weight: .regular),
            caption: .system(size: 11, weight: .regular),
            mono: .system(size: 12, weight: .regular, design: .monospaced)
        ),
        spacing: DSSpacing(xs: 4, sm: 8, md: 12, lg: 16, xl: 24),
        radii: DSRadii(sm: 6, md: 10, lg: 16, pill: 999),
        shadow: DSShadow(
            color: Color.black.opacity(0.45),
            radius: 10,
            x: 0,
            y: 4
        )
    )
}

private struct DSThemeKey: EnvironmentKey {
    static let defaultValue = DSTheme.light
}

public extension EnvironmentValues {
    var dsTheme: DSTheme {
        get { self[DSThemeKey.self] }
        set { self[DSThemeKey.self] = newValue }
    }
}

public struct DSThemeProvider<Content: View>: View {
    private let theme: DSTheme
    private let content: Content

    public init(theme: DSTheme, @ViewBuilder content: () -> Content) {
        self.theme = theme
        self.content = content()
    }

    public var body: some View {
        content.environment(\.dsTheme, theme)
    }
}
