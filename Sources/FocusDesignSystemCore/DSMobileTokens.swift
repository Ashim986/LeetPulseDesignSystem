import SwiftUI

public enum DSMobileColor {
    // Brand
    public static let purple = Color(hex: 0x6366F1)
    public static let indigo = Color(hex: 0x1E1B4B)
    public static let indigoLight = Color(hex: 0x312E81)
    public static let green = Color(hex: 0x10B981)
    public static let greenLight = Color(hex: 0xD1FAE5)
    public static let cyan = Color(hex: 0x22D3EE)
    public static let amber = Color(hex: 0xF59E0B)
    public static let amberLight = Color(hex: 0xFEF3C7)
    public static let red = Color(hex: 0xEF4444)
    public static let redLight = Color(hex: 0xFEE2E2)

    // Neutrals
    public static let gray50 = Color(hex: 0xF9FAFB)
    public static let gray100 = Color(hex: 0xF3F4F6)
    public static let gray200 = Color(hex: 0xE5E7EB)
    public static let gray300 = Color(hex: 0xD1D5DB)
    public static let gray400 = Color(hex: 0x9CA3AF)
    public static let gray500 = Color(hex: 0x6B7280)
    public static let gray600 = Color(hex: 0x4B5563)
    public static let gray700 = Color(hex: 0x374151)
    public static let gray800 = Color(hex: 0x1F2937)
    public static let gray900 = Color(hex: 0x111827)

    // Semantic (Light Mode)
    public static let background = gray50
    public static let surface = Color.white
    public static let surfaceElevated = gray100
    public static let textPrimary = gray900
    public static let textSecondary = gray600
    public static let divider = gray200
    public static let accent = purple
    public static let success = green
    public static let warning = amber
    public static let error = red

    // Gradients
    public static let purpleGradient = LinearGradient(
        colors: [Color(hex: 0x6366F1), Color(hex: 0x8B5CF6)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // Difficulty badge colors
    public static let easyBg = Color(hex: 0xD1FAE5)
    public static let easyText = Color(hex: 0x059669)
    public static let mediumBg = Color(hex: 0xFEF3C7)
    public static let mediumText = Color(hex: 0xD97706)
    public static let hardBg = Color(hex: 0xFEE2E2)
    public static let hardText = Color(hex: 0xDC2626)

    // Streak badge
    public static let streakBg = Color(hex: 0xFFF7ED)
    public static let streakBorder = Color(hex: 0xFDBA74)
    public static let streakText = Color(hex: 0xEA580C)
}

public enum DSMobileTypography {
    public static let title = Font.system(size: 32, weight: .bold)
    public static let headline = Font.system(size: 24, weight: .bold)
    public static let section = Font.system(size: 20, weight: .semibold)
    public static let body = Font.system(size: 16, weight: .regular)
    public static let bodyStrong = Font.system(size: 16, weight: .semibold)
    public static let subbody = Font.system(size: 14, weight: .regular)
    public static let subbodyStrong = Font.system(size: 14, weight: .semibold)
    public static let caption = Font.system(size: 12, weight: .regular)
    public static let captionStrong = Font.system(size: 12, weight: .semibold)
    public static let micro = Font.system(size: 11, weight: .regular)
    public static let microStrong = Font.system(size: 11, weight: .semibold)
    public static let code = Font.system(size: 12, design: .monospaced)
    public static let codeMicro = Font.system(size: 11, design: .monospaced)
    public static let timerLarge = Font.system(size: 64, weight: .bold)
}

public enum DSMobileSpacing {
    public static let space2: CGFloat = 2
    public static let space4: CGFloat = 4
    public static let space8: CGFloat = 8
    public static let space12: CGFloat = 12
    public static let space16: CGFloat = 16
    public static let space24: CGFloat = 24
    public static let space32: CGFloat = 32
    public static let space48: CGFloat = 48
    public static let space64: CGFloat = 64
}

public enum DSMobileRadius {
    public static let small: CGFloat = 8
    public static let medium: CGFloat = 12
    public static let large: CGFloat = 16
    public static let full: CGFloat = 9999
}

extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double(hex & 0xFF) / 255.0,
            opacity: alpha
        )
    }
}
