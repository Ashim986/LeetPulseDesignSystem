// DSScheduleRow.swift
// FocusApp — Schedule row (72px height)
// Spec: FIGMA_SETUP_GUIDE.md §3.17

import SwiftUI

public enum ScheduleRowState {
    case active
    case normal
    case faded
}

public struct DSScheduleRow: View {
    var time: String
    var title: String
    var subtitle: String
    var state: ScheduleRowState = .normal


    public init(
        time: String,
        title: String,
        subtitle: String,
        state: ScheduleRowState = .normal
    ) {
        self.time = time
        self.title = title
        self.subtitle = subtitle
        self.state = state
    }

    public var body: some View {
        HStack(spacing: DSMobileSpacing.space16) {
            Text(time)
                .font(DSMobileTypography.subbodyStrong)
                .foregroundColor(timeColor)
                .frame(width: 60, alignment: .leading)

            VStack(alignment: .leading, spacing: DSMobileSpacing.space2) {
                Text(title)
                    .font(DSMobileTypography.bodyStrong)
                    .foregroundColor(DSMobileColor.gray900)

                Text(subtitle)
                    .font(DSMobileTypography.caption)
                    .foregroundColor(DSMobileColor.gray500)
            }

            Spacer()
        }
        .padding(DSMobileSpacing.space16)
        .frame(height: 72)
        .background(backgroundColor)
        .cornerRadius(DSMobileRadius.medium)
        .opacity(state == .faded ? 0.5 : 1.0)
    }

    private var timeColor: Color {
        switch state {
        case .active: return DSMobileColor.purple
        case .normal: return DSMobileColor.gray500
        case .faded: return DSMobileColor.gray400
        }
    }

    private var backgroundColor: Color {
        switch state {
        case .active: return DSMobileColor.purple.opacity(0.08)
        case .normal, .faded: return Color.clear
        }
    }
}

#Preview {
    VStack(spacing: DSMobileSpacing.space8) {
        DSScheduleRow(
            time: "09:00 AM",
            title: "Morning Review",
            subtitle: "Review yesterday's problems",
            state: .active
        )
        DSScheduleRow(
            time: "10:30 AM",
            title: "Graph Theory",
            subtitle: "BFS and DFS practice",
            state: .normal
        )
        DSScheduleRow(
            time: "02:00 PM",
            title: "Mock Interview",
            subtitle: "System Design with Peer",
            state: .faded
        )
    }
    .padding()
}
