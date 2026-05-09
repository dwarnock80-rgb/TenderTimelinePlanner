import SwiftUI

struct GanttExportView: View {

    let projectName: String
    let stages: [EditableTimelineStage]

    private let dateColumnWidth: CGFloat = 90
    private let chartWidth: CGFloat = 520
    private let rowHeight: CGFloat = 42

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text(projectName)
                .font(.system(size: 28, weight: .bold, design: .serif))
                .foregroundColor(Color(hex: "183A38"))

            Text("Gantt timeline export")
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "6E8583"))

            VStack(alignment: .leading, spacing: 10) {
                ForEach(stages) { stage in
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(stage.title)
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(Color(hex: "183A38"))
                                .lineLimit(1)

                            Text("\(stage.startDate.formatted(date: .abbreviated, time: .omitted)) → \(stage.endDate.formatted(date: .abbreviated, time: .omitted))")
                                .font(.system(size: 11))
                                .foregroundColor(Color(hex: "6E8583"))
                        }
                        .frame(width: 210, alignment: .leading)

                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(hex: "EFEEE9"))
                                .frame(width: chartWidth, height: 24)

                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(hex: stage.colourHex))
                                .frame(
                                    width: barWidth(for: stage),
                                    height: 24
                                )
                                .offset(x: barOffset(for: stage))
                        }
                    }
                    .frame(height: rowHeight)
                }
            }
        }
        .padding(28)
        .frame(width: 820, alignment: .leading)
        .background(Color(hex: "F7F6F2"))
    }

    private var timelineStart: Date {
        stages.map(\.startDate).min() ?? Date()
    }

    private var timelineEnd: Date {
        stages.map(\.endDate).max() ?? Date()
    }

    private var totalDays: CGFloat {
        let days = Calendar.current.dateComponents([.day], from: timelineStart, to: timelineEnd).day ?? 1
        return CGFloat(max(days, 1))
    }

    private func dayOffset(from date: Date) -> CGFloat {
        let days = Calendar.current.dateComponents([.day], from: timelineStart, to: date).day ?? 0
        return CGFloat(max(days, 0))
    }

    private func barOffset(for stage: EditableTimelineStage) -> CGFloat {
        if stage.durationType == .milestone {
            return dayOffset(from: stage.startDate) / totalDays * chartWidth
        }

        return dayOffset(from: stage.startDate) / totalDays * chartWidth
    }

    private func barWidth(for stage: EditableTimelineStage) -> CGFloat {
        if stage.durationType == .milestone {
            return 10
        }

        let days = Calendar.current.dateComponents([.day], from: stage.startDate, to: stage.endDate).day ?? 1
        let width = CGFloat(max(days, 1)) / totalDays * chartWidth

        return max(width, 10)
    }
}
