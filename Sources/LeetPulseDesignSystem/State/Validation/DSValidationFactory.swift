public struct DSValidationFactory: Sendable {
    public init() {}

    public static func required(message: String = "This field is required.") -> DSValidator {
        DSValidator([DSRequiredRule(message: message)])
    }

    public static func email(required: Bool = false) -> DSValidator {
        var rules: [any DSValidationRule] = []
        if required {
            rules.append(DSRequiredRule())
        }
        rules.append(DSEmailRule())
        return DSValidator(rules)
    }

    public static func phone(required: Bool = false) -> DSValidator {
        var rules: [any DSValidationRule] = []
        if required {
            rules.append(DSRequiredRule())
        }
        rules.append(DSPhoneNumberRule())
        return DSValidator(rules)
    }

    public static func name(required: Bool = false, minLength: Int? = 2) -> DSValidator {
        var rules: [any DSValidationRule] = []
        if required {
            rules.append(DSRequiredRule())
        }
        if let minLength {
            rules.append(DSMinLengthRule(minLength: minLength))
        }
        rules.append(DSNameRule())
        return DSValidator(rules)
    }

    public static func address(required: Bool = false) -> DSValidator {
        var rules: [any DSValidationRule] = []
        if required {
            rules.append(DSRequiredRule())
        }
        rules.append(DSAddressRule())
        return DSValidator(rules)
    }

    public static func custom(_ rules: [any DSValidationRule]) -> DSValidator {
        DSValidator(rules)
    }
}
