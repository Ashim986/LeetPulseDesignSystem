// DSTaskRow.swift
// FocusApp — Task row (361x56)
// Spec: FIGMA_SETUP_GUIDE.md §3.8

import SwiftUI
import LeetPulseDesignSystemCore

public enum TaskRowDifficulty: String {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"

    var bgColor: Color {
        switch self {
        case .easy: return DSMobileColor.easyBg
        case .medium: return DSMobileColor.mediumBg
        case .hard: return DSMobileColor.hardBg
        }
    }

    var textColor: Color {
        switch self {
        case .easy: return DSMobileColor.easyText
        case .medium: return DSMobileColor.mediumText
        case .hard: return DSMobileColor.hardText
        }
    }
}

public struct DSTaskRow: View {
    var title: String
    var subtitle: String?
    var isCompleted: Bool = false
    var difficulty: TaskRowDifficulty?
    var progressText: String? // e.g. "1/4" for habit rows


    public init(
        title: String,
        subtitle: String? = nil,
        isCompleted: Bool = false,
        difficulty: TaskRowDifficulty? = nil,
        progressText: String? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.isCompleted = isCompleted
        self.difficulty = difficulty
        self.progressText = progressText
    }

    public var body: some View {
        HStack(spacing: DSMobileSpacing.space12) {
            // Check icon
            if isCompleted {
                ZStack {
                    Circle()
                        .fill(DSMobileColor.purple)
                        .frame(width: 24, height: 24)
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                }
            } else {
                Circle()
                    .strokeBorder(DSMobileColor.gray300, style: StrokeStyle(lineWidth: 1.5, dash: [3]))
                    .frame(width: 24, height: 24)
            }

            // Title + Subtitle
            VStack(alignment: .leading, spacing: DSMobileSpacing.space2) {
                Text(title)
                    .font(DSMobileTypography.bodyStrong)
                    .foregroundColor(isCompleted ? DSMobileColor.gray400 : DSMobileColor.gray900)
                    .strikethrough(isCompleted)

                if let subtitle {
                    Text(subtitle)
                        .font(DSMobileTypography.caption)
                        .foregroundColor(DSMobileColor.gray500)
                }
            }

            Spacer()

            // Progress text or difficulty badge
            if let progressText {
                Text(progressText)
                    .font(DSMobileTypography.subbodyStrong)
                    .foregroundColor(DSMobileColor.gray500)
            }

            if let difficulty {
                DSDifficultyBadge(difficulty: difficulty)
            }

            // Chevron
            Image(systemName: "chevron.right")
                .font(.system(size: 12))
                .foregroundColor(DSMobileColor.gray400)
        }
        .padding(.horizontal, DSMobileSpacing.space16)
        .frame(height: 56)
    }
}

public struct DSDifficultyBadge: View {
    var difficulty: TaskRowDifficulty


    public init(difficulty: TaskRowDifficulty) {
        self.difficulty = difficulty
    }

    public var body: some View {
        Text(difficulty.rawValue)
            .font(DSMobileTypography.captionStrong)
            .foregroundColor(difficulty.textColor)
            .padding(.horizontal, DSMobileSpacing.space8)
            .padding(.vertical, DSMobileSpacing.space4)
            .background(difficulty.bgColor)
            .cornerRadius(DSMobileRadius.small)
    }
}

#Preview {
    VStack(spacing: 0) {
        DSTaskRow(
            title: "Complete Two Sum",
            subtitle: "Arrays & Hashing - LeetCode 75",
            isCompleted: true,
            difficulty: .easy
        )
        Divider()
        DSTaskRow(
            title: "Read System Design Chapter 5",
            subtitle: "System Design",
            isCompleted: false
        )
        Divider()
        DSTaskRow(
            title: "Exercise",
            isCompleted: true,
            progressText: "1/4"
        )
    }
}
