public final class DSValidation: @unchecked Sendable {
    private let validator: DSValidator

    public init(validator: DSValidator) {
        self.validator = validator
    }

    public func isValid(_ value: String) -> Bool {
        validator.validate(value).isValid
    }

    public func validate(_ value: String) -> DSValidationResult {
        validator.validate(value)
    }
}
