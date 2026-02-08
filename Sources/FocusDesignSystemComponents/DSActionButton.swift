import SwiftUI

/// A lightweight action surface.
///
/// This intentionally applies no layout or styling beyond `.buttonStyle(.plain)`,
/// so callers can fully control appearance while still standardizing interactive
/// behavior through a single component.
public struct DSActionButton<Label: View>: View {
    private let action: () -> Void
    private let label: () -> Label

    public init(action: @escaping () -> Void, @ViewBuilder label: @escaping () -> Label) {
        self.action = action
        self.label = label
    }

    public var body: some View {
        Button(action: action, label: label)
            .buttonStyle(.plain)
    }
}

