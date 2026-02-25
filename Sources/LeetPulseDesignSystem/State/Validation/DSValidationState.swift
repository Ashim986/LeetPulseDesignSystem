public struct DSValidationState: Equatable, Sendable {
    public var result: DSValidationResult
    public var isDirty: Bool

    public init(result: DSValidationResult = .valid, isDirty: Bool = false) {
        self.result = result
        self.isDirty = isDirty
    }

    public var isValid: Bool { result.isValid }
    public var error: DSValidationError? { result.error }
    public var message: String? { result.message }
}

public enum DSValidationEvent: Sendable {
    case setResult(DSValidationResult)
    case setDirty(Bool)
    case reset
}

public struct DSValidationReducer: ReducerProtocol {
    public init() {}

    public mutating func reduce(state: inout DSValidationState, event: DSValidationEvent) {
        switch event {
        case .setResult(let result):
            state.result = result
            state.isDirty = true
        case .setDirty(let value):
            state.isDirty = value
        case .reset:
            state.result = .valid
            state.isDirty = false
        }
    }
}
