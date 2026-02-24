public enum DSValidationResult: Equatable, Sendable {
    case valid
    case invalid(DSValidationError)

    public var isValid: Bool {
        switch self {
        case .valid: return true
        case .invalid: return false
        }
    }

    public var error: DSValidationError? {
        switch self {
        case .valid: return nil
        case .invalid(let error): return error
        }
    }

    public var message: String? {
        error?.message
    }
}

public extension DSValidationResult {
    static func invalidMessage(_ message: String, code: String? = nil) -> DSValidationResult {
        .invalid(DSValidationError(message: message, code: code))
    }
}
