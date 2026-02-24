import SwiftUI

public struct DSActionButton<Label: View>: View {
    private let isEnabled: Bool
    private let action: () -> Void
    private let label: Label

    public init(
        isEnabled: Bool = true,
        action: @escaping () -> Void,
        @ViewBuilder label: () -> Label
    ) {
        self.isEnabled = isEnabled
        self.action = action
        self.label = label()
    }

    public var body: some View {
        label
            .contentShape(Rectangle())
            .onTapGesture {
                guard isEnabled else { return }
                action()
            }
            .opacity(isEnabled ? 1.0 : 0.6)
            .allowsHitTesting(isEnabled)
    }
}
