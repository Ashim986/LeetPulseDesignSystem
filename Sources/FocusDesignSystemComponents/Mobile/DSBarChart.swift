// DSBarChart.swift
// FocusApp — Bar chart (361x240)
// Spec: FIGMA_SETUP_GUIDE.md §3.18

import SwiftUI
import FocusDesignSystemCore

public struct DSBarChart: View {
    var data: [CGFloat] = [4, 6, 3, 7, 5, 2, 8]
    var labels: [String] = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    var maxValue: CGFloat = 8
    var title: String = "Weekly Focus Time"
    var barColor: Color = DSMobileColor.purple

    var body: some View {
        DSSurfaceCard {
            VStack(alignment: .leading, spacing: DSMobileSpacing.space12) {
                Text(title)
                    .font(DSMobileTypography.bodyStrong)
                    .foregroundColor(DSMobileColor.textPrimary)

                GeometryReader { geo in
                    let chartWidth = geo.size.width
                    let chartHeight = geo.size.height - 24 // Space for labels
                    let barWidth: CGFloat = 32
                    let totalBars = CGFloat(data.count)
                    let spacing = (chartWidth - barWidth * totalBars) / (totalBars + 1)

                    ZStack(alignment: .bottomLeading) {
                        // Grid lines (dashed)
                        ForEach(0..<5, id: \.self) { i in
                            let y = chartHeight * CGFloat(i) / 4
                            Path { path in
                                path.move(to: CGPoint(x: 0, y: y))
                                path.addLine(to: CGPoint(x: chartWidth, y: y))
                            }
                            .stroke(DSMobileColor.gray200, style: StrokeStyle(lineWidth: 0.5, dash: [4]))
                        }

                        // Bars
                        HStack(alignment: .bottom, spacing: spacing) {
                            ForEach(0..<data.count, id: \.self) { index in
                                VStack(spacing: DSMobileSpacing.space4) {
                                    RoundedRectangle(cornerRadius: DSMobileRadius.small)
                                        .fill(barColor)
                                        .frame(
                                            width: barWidth,
                                            height: maxValue > 0
                                                ? chartHeight * data[index] / maxValue
                                                : 0
                                        )

                                    Text(labels[index])
                                        .font(DSMobileTypography.caption)
                                        .foregroundColor(DSMobileColor.gray400)
                                        .frame(width: barWidth)
                                }
                            }
                        }
                        .padding(.leading, spacing)
                    }
                }
                .frame(height: 200)
            }
        }
    }
}

#Preview {
    DSBarChart()
        .padding()
}
