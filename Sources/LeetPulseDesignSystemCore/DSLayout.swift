import CoreGraphics

public enum DSLayout {
    public enum SpacingToken {
        case space2
        case space4
        case space8
        case space12
        case space16
        case space24
        case space32
        case space48
        case space64
    }

    public static func spacing(_ token: SpacingToken) -> CGFloat {
        switch token {
        case .space2: 2
        case .space4: 4
        case .space8: 8
        case .space12: 12
        case .space16: 16
        case .space24: 24
        case .space32: 32
        case .space48: 48
        case .space64: 64
        }
    }

    public static func spacing(_ value: CGFloat) -> CGFloat {
        value
    }
}
