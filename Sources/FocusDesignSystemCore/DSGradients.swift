import SwiftUI

/// Reusable gradient definitions for the design system.
public struct DSGradients: Sendable {
    public let purpleGradient: LinearGradient
    public let indigoGradient: LinearGradient

    public init(
        purpleGradient: LinearGradient,
        indigoGradient: LinearGradient
    ) {
        self.purpleGradient = purpleGradient
        self.indigoGradient = indigoGradient
    }
}
