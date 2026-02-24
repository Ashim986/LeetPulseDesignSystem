// DSPomodoroSegmentedControl.swift
// FocusApp — Pomodoro segmented control (329x44)
// Spec: FIGMA_SETUP_GUIDE.md §3.12

import SwiftUI
import LeetPulseDesignSystemCore

public enum PomodoroSegment: String, CaseIterable {
    case focus = "Focus"
    case shortBreak = "Short Break"
    case longBreak = "Long Break"

    var iconName: String {
        switch self {
        case .focus: return "scope"
        case .shortBreak: return "cup.and.saucer"
        case .longBreak: return "moon"
        }
    }
}

public struct DSPomodoroSegmentedControl: View {
    @Binding var selected: PomodoroSegment

    public init(selected: Binding<PomodoroSegment>) {
        self._selected = selected
    }

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(PomodoroSegment.allCases, id: \.self) { segment in
                segmentButton(for: segment)
            }
        }
        .padding(DSMobileSpacing.space4)
        .background(DSMobileColor.gray100)
        .clipShape(Capsule())
    }

    @ViewBuilder
    private func segmentButton(for segment: PomodoroSegment) -> some View {
        let isSelected = selected == segment
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                selected = segment
            }
        } label: {
            segmentLabel(for: segment, isSelected: isSelected)
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private func segmentLabel(for segment: PomodoroSegment, isSelected: Bool) -> some View {
        HStack(spacing: DSMobileSpacing.space4) {
            Image(systemName: segment.iconName)
                .font(.system(size: 14))
            Text(segment.rawValue)
                .font(DSMobileTypography.subbodyStrong)
        }
        .foregroundColor(isSelected ? DSMobileColor.gray900 : DSMobileColor.gray500)
        .frame(maxWidth: .infinity)
        .frame(height: 36)
        .background(isSelected ? DSMobileColor.surface : Color.clear)
        .shadow(color: isSelected ? .black.opacity(0.05) : .clear, radius: 3, y: 1)
        .clipShape(Capsule())
    }
}

#Preview {
    DSPomodoroSegmentedControl(selected: .constant(.focus))
        .padding()
}
