import SwiftUI

public struct DSNavItem: Identifiable, Hashable, Sendable {
    public let id: String
    public let title: String
    public let systemImage: String?
    public let badge: String?
    public let isEnabled: Bool

    public init(
        id: String,
        title: String,
        systemImage: String? = nil,
        badge: String? = nil,
        isEnabled: Bool = true
    ) {
        self.id = id
        self.title = title
        self.systemImage = systemImage
        self.badge = badge
        self.isEnabled = isEnabled
    }
}
