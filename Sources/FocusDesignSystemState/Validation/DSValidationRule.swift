import Foundation

public protocol DSValidationRule: Sendable {
    var id: String { get }
    func validate(_ value: String) -> DSValidationResult
}

public struct DSRequiredRule: DSValidationRule {
    public let id = "required"
    public let message: String

    public init(message: String = "This field is required.") {
        self.message = message
    }

    public func validate(_ value: String) -> DSValidationResult {
        value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? .invalidMessage(message, code: id)
            : .valid
    }
}

public struct DSEmailRule: DSValidationRule {
    public let id = "email"
    public let message: String

    public init(message: String = "Enter a valid email address.") {
        self.message = message
    }

    public func validate(_ value: String) -> DSValidationResult {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return .valid }
        let pattern = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: trimmed) ? .valid : .invalidMessage(message, code: id)
    }
}

public struct DSPhoneNumberRule: DSValidationRule {
    public let id = "phone"
    public let message: String

    public init(message: String = "Enter a valid phone number.") {
        self.message = message
    }

    public func validate(_ value: String) -> DSValidationResult {
        let digits = value.filter { $0.isNumber }
        guard !digits.isEmpty else { return .valid }
        return (7...15).contains(digits.count) ? .valid : .invalidMessage(message, code: id)
    }
}

public struct DSNameRule: DSValidationRule {
    public let id = "name"
    public let message: String

    public init(message: String = "Enter a valid name.") {
        self.message = message
    }

    public func validate(_ value: String) -> DSValidationResult {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return .valid }
        let pattern = "^[\\p{L}][\\p{L} '\\-’]{1,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: trimmed) ? .valid : .invalidMessage(message, code: id)
    }
}

public struct DSAddressRule: DSValidationRule {
    public let id = "address"
    public let message: String

    public init(message: String = "Enter a valid address.") {
        self.message = message
    }

    public func validate(_ value: String) -> DSValidationResult {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return .valid }
        let hasLetter = trimmed.rangeOfCharacter(from: .letters) != nil
        let hasDigit = trimmed.rangeOfCharacter(from: .decimalDigits) != nil
        return (trimmed.count >= 5 && hasLetter && hasDigit) ? .valid : .invalidMessage(message, code: id)
    }
}

public struct DSMinLengthRule: DSValidationRule {
    public let id: String
    public let minLength: Int
    public let message: String

    public init(minLength: Int, message: String? = nil) {
        self.minLength = minLength
        self.id = "minLength_\(minLength)"
        self.message = message ?? "Must be at least \(minLength) characters."
    }

    public func validate(_ value: String) -> DSValidationResult {
        value.count >= minLength ? .valid : .invalidMessage(message, code: id)
    }
}

public struct DSMaxLengthRule: DSValidationRule {
    public let id: String
    public let maxLength: Int
    public let message: String

    public init(maxLength: Int, message: String? = nil) {
        self.maxLength = maxLength
        self.id = "maxLength_\(maxLength)"
        self.message = message ?? "Must be no more than \(maxLength) characters."
    }

    public func validate(_ value: String) -> DSValidationResult {
        value.count <= maxLength ? .valid : .invalidMessage(message, code: id)
    }
}

public struct DSRegexRule: DSValidationRule {
    public let id: String
    public let pattern: String
    public let message: String

    public init(id: String, pattern: String, message: String) {
        self.id = id
        self.pattern = pattern
        self.message = message
    }

    public func validate(_ value: String) -> DSValidationResult {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return .valid }
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: trimmed) ? .valid : .invalidMessage(message, code: id)
    }
}
