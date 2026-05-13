import SwiftUI

struct GanttExportView: View {

    let projectName: String
    let stages: [EditableTimelineStage]

    private let exportWidth: CGFloat = 1800
    private let stageColumnWidth: CGFloat = 350
    private let chartWidth: CGFloat = 1410
    private let titleHeight: CGFloat = 88
    private let headerHeight: CGFloat = 86
    private let rowHeight: CGFloat = 58
    private let footerHeight: CGFloat = 46

    var body: some View {
        VStack(spacing: 0) {
            titleBar
            headerRow

            ForEach(Array(stages.enumerated()), id: \.element.id) { index, stage in
                ganttRow(stage: stage, index: index + 1)
            }

            footer
        }
        .frame(width: exportWidth, alignment: .topLeading)
        .background(Color.white)
    }

    private var titleBar: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 6) {
                Text("The Accidental Procurer")
                    .font(.system(size: 28, weight: .bold, design: .serif))
                    .foregroundColor(Color(hex: "EBAA2D"))

                Text(projectName)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white.opacity(0.9))
            }

            Spacer()

            Text("Start: \(Self.dateFormatter.string(from: timelineStart))")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white.opacity(0.75))
        }
        .padding(.horizontal, 30)
        .frame(width: exportWidth, height: titleHeight)
        .background(Color(hex: "0B4543"))
    }

    private var headerRow: some View {
        HStack(spacing: 0) {
            Text("Stage")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color(hex: "183A38"))
                .frame(width: stageColumnWidth, alignment: .leading)
                .padding(.leading, 30)

            ZStack(alignment: .leading) {
                monthGrid(showLabels: true)

                Text("Timeline")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color(hex: "183A38"))
                    .padding(.leading, 6)
            }
            .frame(width: chartWidth, height: headerHeight)
        }
        .frame(width: exportWidth, height: headerHeight)
        .background(Color(hex: "E9E4DC"))
    }

    private func ganttRow(stage: EditableTimelineStage, index: Int) -> some View {
        HStack(spacing: 0) {
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(Color(hex: stage.colourHex))
                        .frame(width: 30, height: 30)

                    Text("\(index)")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                }

                Text(stage.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color(hex: "183A38"))
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            .padding(.leading, 30)
            .frame(width: stageColumnWidth, height: rowHeight, alignment: .leading)

            ZStack(alignment: .leading) {
                monthGrid(showLabels: false)
                ganttMark(for: stage)
            }
            .frame(width: chartWidth, height: rowHeight)
        }
        .frame(width: exportWidth, height: rowHeight)
        .background(index.isMultiple(of: 2) ? Color(hex: "F4F1EA") : Color.white)
    }

    private func ganttMark(for stage: EditableTimelineStage) -> some View {
        let x = barOffset(for: stage)

        return Group {
            if stage.durationType == .milestone {
                Rectangle()
                    .fill(Color(hex: stage.colourHex))
                    .frame(width: 24, height: 24)
                    .rotationEffect(.degrees(45))
                    .offset(x: x - 12)
            } else {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(hex: stage.colourHex))
                    .frame(width: barWidth(for: stage), height: 30)
                    .overlay {
                        if barWidth(for: stage) > 92 {
                            Text(barLabel(for: stage))
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .minimumScaleFactor(0.75)
                                .padding(.horizontal, 6)
                        }
                    }
                    .offset(x: x)
            }
        }
    }

    private func monthGrid(showLabels: Bool) -> some View {
        HStack(spacing: 0) {
            ForEach(monthStarts, id: \.self) { month in
                ZStack(alignment: .topLeading) {
                    Rectangle()
                        .fill(Color.clear)

                    Rectangle()
                        .fill(Color(hex: "BDB7AE"))
                        .frame(width: 1)

                    if showLabels {
                        Text(Self.monthFormatter.string(from: month))
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color(hex: "6E8583"))
                            .padding(.top, 14)
                            .padding(.leading, 6)
                    }
                }
                .frame(width: chartWidth / CGFloat(max(monthStarts.count, 1)))
            }
        }
    }

    private var footer: some View {
        Text("Generated by The Accidental Procurer - Tender Timeline Planner")
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(.white.opacity(0.65))
            .frame(width: exportWidth, height: footerHeight)
            .background(Color(hex: "0B4543"))
    }

    private var timelineStart: Date {
        stages.map(\.startDate).min() ?? Date()
    }

    private var timelineEnd: Date {
        stages.map(\.endDate).max() ?? Date()
    }

    private var chartStart: Date {
        Calendar.current.dateInterval(of: .month, for: timelineStart)?.start ?? timelineStart
    }

    private var chartEnd: Date {
        let monthStart = Calendar.current.dateInterval(of: .month, for: timelineEnd)?.start ?? timelineEnd
        return Calendar.current.date(byAdding: .month, value: 1, to: monthStart) ?? timelineEnd
    }

    private var monthStarts: [Date] {
        var months: [Date] = []
        var current = chartStart

        while current < chartEnd {
            months.append(current)
            current = Calendar.current.date(byAdding: .month, value: 1, to: current) ?? chartEnd
        }

        return months
    }

    private var totalDays: CGFloat {
        let days = Calendar.current.dateComponents([.day], from: chartStart, to: chartEnd).day ?? 1
        return CGFloat(max(days, 1))
    }

    private func dayOffset(from date: Date) -> CGFloat {
        let days = Calendar.current.dateComponents([.day], from: chartStart, to: date).day ?? 0
        return CGFloat(max(days, 0))
    }

    private func barOffset(for stage: EditableTimelineStage) -> CGFloat {
        dayOffset(from: stage.startDate) / totalDays * chartWidth
    }

    private func barWidth(for stage: EditableTimelineStage) -> CGFloat {
        let days = Calendar.current.dateComponents([.day], from: stage.startDate, to: stage.endDate).day ?? 1
        let width = CGFloat(max(days, 1)) / totalDays * chartWidth
        return max(width, 12)
    }

    private func barLabel(for stage: EditableTimelineStage) -> String {
        "\(Self.shortDateFormatter.string(from: stage.startDate)) - \(Self.shortDateFormatter.string(from: stage.endDate))"
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter
    }()

    private static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return formatter
    }()

    private static let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yy"
        return formatter
    }()
}
