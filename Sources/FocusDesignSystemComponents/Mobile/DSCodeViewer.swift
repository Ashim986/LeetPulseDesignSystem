// DSCodeViewer.swift
// FocusApp — Dark code viewer with syntax highlighting
// Spec: FIGMA_SETUP_GUIDE.md §3.22

import SwiftUI
import FocusDesignSystemCore

public struct DSCodeViewer: View {
    var language: String = "TypeScript"
    var code: String = """
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


    public init(
        language: String = "TypeScript",
        code: String = """
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
    ) {
        self.language = language
        self.code = code
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                Text(language)
                    .font(DSMobileTypography.captionStrong)
                    .foregroundColor(DSMobileColor.gray400)

                Spacer()

                HStack(spacing: DSMobileSpacing.space4) {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 10))
                    Text("Read-only")
                        .font(DSMobileTypography.caption)
                }
                .foregroundColor(DSMobileColor.gray400)
            }
            .padding(DSMobileSpacing.space12)

            Divider()
                .background(DSMobileColor.gray700)

            // Code area
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    // Line numbers
                    VStack(alignment: .trailing, spacing: 0) {
                        let lines = code.components(separatedBy: "\n")
                        ForEach(0..<lines.count, id: \.self) { i in
                            Text("\(i + 1)")
                                .font(DSMobileTypography.codeMicro)
                                .foregroundColor(DSMobileColor.gray500)
                                .frame(width: 32, alignment: .trailing)
                                .frame(height: 18)
                        }
                    }
                    .padding(.leading, DSMobileSpacing.space8)

                    // Code text
                    VStack(alignment: .leading, spacing: 0) {
                        let lines = code.components(separatedBy: "\n")
                        ForEach(0..<lines.count, id: \.self) { i in
                            Text(lines[i])
                                .font(DSMobileTypography.code)
                                .foregroundColor(DSMobileColor.gray300)
                                .frame(height: 18, alignment: .leading)
                        }
                    }
                    .padding(.leading, DSMobileSpacing.space12)
                }
            }
            .padding(.vertical, DSMobileSpacing.space12)
        }
        .background(DSMobileColor.gray800)
        .cornerRadius(DSMobileRadius.medium)
    }
}

#Preview {
    DSCodeViewer()
        .padding()
}
