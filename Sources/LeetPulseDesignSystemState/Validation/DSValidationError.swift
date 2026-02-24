public struct DSValidationError: Equatable, Sendable {
    public let code: String?
    public let message: String

    public init(message: String, code: String? = nil) {
        self.message = message
        self.code = code
    }
}
