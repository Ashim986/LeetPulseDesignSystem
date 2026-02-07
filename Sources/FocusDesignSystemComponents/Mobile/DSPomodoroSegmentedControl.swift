// DSPomodoroSegmentedControl.swift
// FocusApp — Pomodoro segmented control (329x44)
// Spec: FIGMA_SETUP_GUIDE.md §3.12

import SwiftUI
import FocusDesignSystemCore

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

    var body: some View {
        HStack(spacing: 0) {
            ForEach(PomodoroSegment.allCases, id: \.self) { segment in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selected = segment
                    }
                } label: {
                    HStack(spacing: DSMobileSpacing.space4) {
                        Image(systemName: segment.iconName)
                            .font(.system(size: 14))
                        Text(segment.rawValue)
                            .font(DSMobileTypography.subbodyStrong)
                    }
                    .foregroundColor(
                        selected == segment ? DSMobileColor.gray900 : DSMobileColor.gray500
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: 36)
                    .background(
                        selected == segment
                            ? DSMobileColor.surface
                                .shadow(.drop(color: .black.opacity(0.05), radius: 3, y: 1))
                            : Color.clear
                    )
                    .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(DSMobileSpacing.space4)
        .background(DSMobileColor.gray100)
        .clipShape(Capsule())
    }
}

#Preview {
    DSPomodoroSegmentedControl(selected: .constant(.focus))
        .padding()
}
