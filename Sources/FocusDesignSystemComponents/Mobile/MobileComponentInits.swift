import FocusDesignSystemCore
import SwiftUI

public extension DSBarChart {
    init(
        data: [CGFloat] = [4, 6, 3, 7, 5, 2, 8],
        labels: [String] = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
        maxValue: CGFloat = 8,
        title: String = "Weekly Focus Time",
        barColor: Color = DSMobileColor.purple
    ) {
        self.data = data
        self.labels = labels
        self.maxValue = maxValue
        self.title = title
        self.barColor = barColor
    }
}

public extension DSBottomTabBar {
    init(selectedTab: Binding<AppTab>) {
        self._selectedTab = selectedTab
    }
}

public extension DSCalendarGrid {
    init(month: String = "February 2026") {
        self.month = month
    }
}

public extension DSCodeViewer {
    static let sampleCode = """
    function twoSum(nums: number[], target: number): number[] {
        const map = new Map<number, number>();
        for (let i = 0; i < nums.length; i++) {
            const complement = target - nums[i];
            if (map.has(complement)) {
                return [map.get(complement)!, i];
            }
            map.set(nums[i], i);
        }
        return [];
    }
    """

    init(language: String = "TypeScript", code: String? = nil) {
        self.language = language
        self.code = code ?? Self.sampleCode
    }
}

public extension DSDailyGoalCard {
    init(completed: Int = 1, total: Int = 4) {
        self.completed = completed
        self.total = total
    }
}

public extension DSFocusTimeCard {
    init(focusTime: String = "2h 15m", remainingText: String = "35m remaining today") {
        self.focusTime = focusTime
        self.remainingText = remainingText
    }
}

public extension DSHeaderBar {
    init(title: String = "FocusApp", showSettings: Bool = true, onSettingsTap: (() -> Void)? = nil) {
        self.title = title
        self.showSettings = showSettings
        self.onSettingsTap = onSettingsTap
    }
}

public extension DSLineChart {
    init(
        data: [CGFloat] = [3, 5, 4, 8, 6, 9, 7],
        labels: [String] = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
        maxValue: CGFloat = 12,
        title: String = "Problems Solved",
        lineColor: Color = DSMobileColor.green
    ) {
        self.data = data
        self.labels = labels
        self.maxValue = maxValue
        self.title = title
        self.lineColor = lineColor
    }
}

public extension DSMetricCardView {
    init(label: String, value: String) {
        self.label = label
        self.value = value
    }
}

public extension DSPomodoroSegmentedControl {
    init(selected: Binding<PomodoroSegment>) {
        self._selected = selected
    }
}

public extension DSProblemCard {
    init(title: String, difficulty: TaskRowDifficulty, isSolved: Bool = false) {
        self.title = title
        self.difficulty = difficulty
        self.isSolved = isSolved
    }
}

public extension DSScheduleRow {
    init(time: String, title: String, subtitle: String, state: ScheduleRowState = .normal) {
        self.time = time
        self.title = title
        self.subtitle = subtitle
        self.state = state
    }
}

public extension DSSearchBar {
    init(text: Binding<String>, placeholder: String = "Search problems...") {
        self._text = text
        self.placeholder = placeholder
    }
}

public extension DSSettingsRow {
    init(iconName: String, title: String, subtitle: String? = nil, statusText: String? = nil) {
        self.iconName = iconName
        self.title = title
        self.subtitle = subtitle
        self.statusText = statusText
    }
}

public extension DSSidebarNav {
    init(selectedItem: Binding<SidebarItem>) {
        self._selectedItem = selectedItem
    }
}

public extension DSSignOutButton {
    init(onTap: (() -> Void)? = nil) {
        self.onTap = onTap
    }
}

public extension DSStartFocusCTA {
    init(onTap: (() -> Void)? = nil) {
        self.onTap = onTap
    }
}

public extension DSStreakBadge {
    init(streakDays: Int = 12) {
        self.streakDays = streakDays
    }
}

public extension DSSurfaceCard {
    init(
        cornerRadius: CGFloat = DSMobileRadius.medium,
        padding: CGFloat = DSMobileSpacing.space16,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.content = content
    }
}

public extension DSTaskRow {
    init(
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
}

public extension DSDifficultyBadge {
    init(difficulty: TaskRowDifficulty) {
        self.difficulty = difficulty
    }
}

public extension DSTimerRing {
    init(
        timeText: String = "25:00",
        statusText: String = "PAUSED",
        progress: Double = 0.0,
        ringColor: Color = DSMobileColor.red,
        size: CGFloat = 280
    ) {
        self.timeText = timeText
        self.statusText = statusText
        self.progress = progress
        self.ringColor = ringColor
        self.size = size
    }
}
