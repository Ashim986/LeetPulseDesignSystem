public struct DSValidator: Sendable {
    public let rules: [any DSValidationRule]

    public init(_ rules: [any DSValidationRule]) {
        self.rules = rules
    }

    public func validate(_ value: String) -> DSValidationResult {
        for rule in rules {
            let result = rule.validate(value)
            if !result.isValid {
                return result
            }
        }
        return .valid
    }
}
