import SwiftUI

struct TimelineDetailView: View {

    let projectName: String
    let startDateText: String
    let templateName: String

    @State private var stages: [EditableTimelineStage] = []
    @State private var stageBeingEdited: EditableTimelineStage?
    @State private var showingEditSheet = false
    @State private var showingAddCustomStep = false
    @State private var csvExportURL: URL?
    @State private var showingCSVShareSheet = false
    @State private var ganttExportURL: URL?
    @State private var showingGanttShareSheet = false

    private var actualStartDate: Date {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.date(from: startDateText) ?? Date()
    }

    var body: some View {
        ZStack {
            Color(hex: "F7F6F2").ignoresSafeArea()
            
            VStack(spacing: 0) {
                header
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        startDateRow
                        exportButtons
                        columnHeaders
                        
                        ForEach(Array(stages.enumerated()), id: \.element.id) { index, stage in
                            EditableTimelineStageRow(
                                stage: stage,
                                index: index + 1,
                                onEdit: {
                                    stageBeingEdited = stage
                                    showingEditSheet = true
                                }
                            )
                        }
                        
                        addCustomStepButton
                        infoBox
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            stages = TimelineTemplates.stages(
                for: templateName,
                startDate: actualStartDate
            )
        }
        .sheet(item: $stageBeingEdited) { stage in
            EditStageView(stage: stage) { updatedStage in
                updateStage(updatedStage)
            }
        }
        .sheet(isPresented: $showingAddCustomStep) {
            AddCustomStepView(stages: stages) { newStage, insertionIndex in
                stages.insert(newStage, at: insertionIndex)
                
                stages = TimelineDateCalculator.recalculate(
                    stages: stages,
                    from: actualStartDate
                )
            }
        }
        .sheet(isPresented: $showingCSVShareSheet) {
            if let csvExportURL {
                ShareSheet(activityItems: [csvExportURL])
            }
        }
        .sheet(isPresented: $showingGanttShareSheet) {
            if let ganttExportURL {
                ShareSheet(activityItems: [ganttExportURL])
            }
        }
    }
    
    private func updateStage(_ updatedStage: EditableTimelineStage) {
        guard let index = stages.firstIndex(where: { $0.id == updatedStage.id }) else {
            return
        }

        stages[index].title = updatedStage.title
        stages[index].duration = updatedStage.duration
        stages[index].durationType = updatedStage.durationType
        stages[index].isMilestone = updatedStage.durationType == .milestone

        stages = TimelineDateCalculator.recalculate(
            stages: stages,
            from: actualStartDate
        )
    }
    
    private func exportCSV() {
        var csv = "Step,Title,Start Date,End Date,Duration,Duration Type\n"

        for (index, stage) in stages.enumerated() {
            let start = stage.startDate.formatted(date: .abbreviated, time: .omitted)
            let end = stage.endDate.formatted(date: .abbreviated, time: .omitted)

            let durationTypeText: String

            switch stage.durationType {
            case .calendarDays:
                durationTypeText = "Calendar days"
            case .workingDays:
                durationTypeText = "Working days"
            case .milestone:
                durationTypeText = "Milestone"
            }

            let row = "\(index + 1),\"\(stage.title)\",\"\(start)\",\"\(end)\",\(stage.duration),\"\(durationTypeText)\"\n"
            csv += row
        }

        let fileName = "\(projectName.isEmpty ? "Tender Timeline" : projectName).csv"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)

        do {
            try csv.write(to: url, atomically: true, encoding: .utf8)
            csvExportURL = url
            print("CSV created at: \(url)")
            showingCSVShareSheet = true
        } catch {
            print("Failed to export CSV: \(error)")
        }
    }
    
    @MainActor
    private func exportGanttImage() async {
        let renderer = ImageRenderer(
            content: GanttExportView(
                projectName: projectName.isEmpty ? "Tender Timeline" : projectName,
                stages: stages
            )
        )

        renderer.scale = 3

        if let image = renderer.uiImage,
           let data = image.pngData() {

            let fileName = "\(projectName.isEmpty ? "Tender Timeline Gantt" : projectName + " Gantt").png"
            let url = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)

            do {
                try data.write(to: url)
                ganttExportURL = url
                print("Gantt image created at: \(url)")
                showingGanttShareSheet = true
            } catch {
                print("Failed to export Gantt image: \(error)")
            }
        }
    }
    var header: some View {
        HStack {
            Image(systemName: "chevron.left")
                .font(.system(size: 26, weight: .medium))

            Text(projectName.isEmpty ? "Test" : projectName)
                .font(.system(size: 34, weight: .bold, design: .serif))
                .padding(.leading, 20)

            Spacer()

            Image(systemName: "ellipsis")
                .rotationEffect(.degrees(90))
                .font(.system(size: 28, weight: .bold))
        }
        .foregroundColor(Color(hex: "183A38"))
        .padding(.horizontal, 28)
        .padding(.top, 70)
        .padding(.bottom, 28)
        .background(Color.white)
    }

    var startDateRow: some View {
        HStack(spacing: 14) {
            Image(systemName: "calendar")
                .font(.system(size: 24))
                .foregroundColor(Color(hex: "EBAA2D"))

            Text("Start date")
                .font(.system(size: 21))
                .foregroundColor(Color(hex: "6E8583"))

            Text(startDateText)
                .font(.system(size: 21, weight: .bold))
                .foregroundColor(Color(hex: "183A38"))
        }
        .padding(.top, 24)
    }

    var exportButtons: some View {
        HStack(spacing: 14) {
            ExportButton(title: "Export CSV") {
                exportCSV()
            }
            ExportButton(title: "Export Gantt") {
                Task {
                    await exportGanttImage()
                }
            }
        }
    }

    var columnHeaders: some View {
        HStack {
            Text("STEP")
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("DATES")
                .frame(width: 110)

            Text("DURATION")
                .frame(width: 105)
        }
        .font(.system(size: 16, weight: .bold))
        .foregroundColor(Color(hex: "6E8583"))
        .padding(.top, 8)
        .padding(.leading, 86)
    }

    var addCustomStepButton: some View {
        Button {
            showingAddCustomStep = true

            stages = TimelineDateCalculator.recalculate(
                stages: stages,
                from: actualStartDate
            )
        } label: {
            HStack {
                Spacer()
                Image(systemName: "plus")
                Text("Add Custom Step")
                    .fontWeight(.bold)
                Spacer()
            }
            .font(.system(size: 22))
            .foregroundColor(Color(hex: "183A38"))
            .frame(height: 72)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        Color(hex: "DDD9D2"),
                        style: StrokeStyle(lineWidth: 2, dash: [8])
                    )
            )
        }
        .padding(.top, 18)
    }

    var infoBox: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: "info.circle")
                .font(.system(size: 24))
                .foregroundColor(Color(hex: "6E8583"))

            Text("Editing a duration will automatically update all subsequent steps. Dates adjust for UK bank holidays and weekends.")
                .font(.system(size: 18))
                .foregroundColor(Color(hex: "6E8583"))
                .lineSpacing(4)
        }
        .padding(22)
        .background(Color(hex: "EFEEE9"))
        .cornerRadius(18)
    }
}

struct EditableTimelineStageRow: View {

    let stage: EditableTimelineStage
    let index: Int
    let onEdit: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 18) {
                ZStack {
                    Circle()
                        .fill(Color(hex: stage.colourHex))
                        .frame(width: 60, height: 60)

                    if stage.isMilestone {
                        Image(systemName: "flag")
                            .font(.system(size: 28))
                            .foregroundColor(.white)
                    } else {
                        Text("\(index)")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                    }
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text(stage.title)
                        .font(.system(size: 23, weight: .bold))
                        .foregroundColor(Color(hex: "183A38"))

                    Text(dateText(for: stage))
                        .font(.system(size: 20))
                        .foregroundColor(Color(hex: "6E8583"))
                }

                Spacer()

                VStack(spacing: 2) {
                    Text("\(stage.duration)")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(Color(hex: "EBAA2D"))

                    Text(durationUnitText(for: stage))
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "6E8583"))
                }
                .frame(width: 82)

                Button {
                    onEdit()
                } label: {
                    Image(systemName: "ellipsis")
                        .rotationEffect(.degrees(90))
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(Color(hex: "6E8583"))
                }
            }
            .padding(.vertical, 18)

            Divider()
                .background(Color(hex: "DDD9D2"))
        }
    }

    private func dateText(for stage: EditableTimelineStage) -> String {
        if stage.durationType == .milestone {
            return stage.startDate.formatted(date: .abbreviated, time: .omitted)
        }

        return "\(stage.startDate.formatted(date: .abbreviated, time: .omitted)) → \(stage.endDate.formatted(date: .abbreviated, time: .omitted))"
    }

    private func durationUnitText(for stage: EditableTimelineStage) -> String {
        switch stage.durationType {
        case .calendarDays:
            return "days"
        case .workingDays:
            return "work days"
        case .milestone:
            return ""
        }
    }
}

struct ExportButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: "square.and.arrow.down")
                    .font(.system(size: 22))

                Text(title)
                    .font(.system(size: 20, weight: .semibold))
            }
            .foregroundColor(Color(hex: "183A38"))
            .padding(.horizontal, 22)
            .frame(height: 54)
            .background(Color.white)
            .cornerRadius(14)
            .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
        }
    }
}
