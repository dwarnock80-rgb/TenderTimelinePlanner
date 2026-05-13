import SwiftUI

struct TimelineDetailView: View {

    @Environment(\.dismiss) private var dismiss

    let projectName: String
    let startDateText: String
    let templateName: String
    let initialStages: [EditableTimelineStage]?

    @State private var stages: [EditableTimelineStage] = []
    @State private var stageBeingEdited: EditableTimelineStage?
    @State private var showingEditSheet = false
    @State private var showingAddCustomStep = false
    @State private var csvExportURL: URL?
    @State private var showingCSVShareSheet = false
    @State private var ganttExportURL: URL?
    @State private var showingGanttShareSheet = false
    @State private var showingSavedConfirmation = false
    @State private var hasLoadedStages = false

    private var actualStartDate: Date {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.date(from: startDateText) ?? Date()
    }

    init(
        projectName: String,
        startDateText: String,
        templateName: String,
        initialStages: [EditableTimelineStage]? = nil
    ) {
        self.projectName = projectName
        self.startDateText = startDateText
        self.templateName = templateName
        self.initialStages = initialStages
    }

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 0) {
                header
                
                List {
                    startDateRow
                        .listRowInsets(EdgeInsets(top: 18, leading: 20, bottom: 8, trailing: 20))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.white)

                    exportButtons
                        .listRowInsets(EdgeInsets(top: 2, leading: 20, bottom: 18, trailing: 20))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.white)

                    columnHeaders
                        .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 6, trailing: 20))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.white)

                    ForEach(Array(stages.enumerated()), id: \.element.id) { index, stage in
                        EditableTimelineStageRow(
                            stage: stage,
                            index: index + 1,
                            onEdit: {
                                stageBeingEdited = stage
                                showingEditSheet = true
                            }
                        )
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                deleteStage(stage)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.white)
                    }

                    addCustomStepButton
                        .listRowInsets(EdgeInsets(top: 10, leading: 20, bottom: 8, trailing: 20))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.white)

                    infoBox
                        .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 40, trailing: 20))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.white)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            loadStagesIfNeeded()
        }
        .alert("Timeline saved", isPresented: $showingSavedConfirmation) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("You can reopen it from Saved Timelines.")
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

    private func loadStagesIfNeeded() {
        guard !hasLoadedStages else {
            return
        }

        if let initialStages {
            stages = initialStages
        } else {
            stages = TimelineTemplates.stages(
                for: templateName,
                startDate: actualStartDate
            )
        }

        hasLoadedStages = true
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

    private func deleteStage(_ stage: EditableTimelineStage) {
        stages.removeAll { $0.id == stage.id }

        stages = TimelineDateCalculator.recalculate(
            stages: stages,
            from: actualStartDate
        )
    }

    private func saveTimeline() {
        SavedTimelineStore.save(
            SavedTimeline(
                projectName: projectName.isEmpty ? "Untitled Timeline" : projectName,
                startDateText: startDateText,
                templateName: templateName,
                stages: stages
            )
        )

        showingSavedConfirmation = true
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
        HStack(spacing: 16) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 23, weight: .medium))
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.plain)

            Text(projectName.isEmpty ? "Test" : projectName)
                .font(.system(size: 28, weight: .bold, design: .serif))
                .lineLimit(1)
                .minimumScaleFactor(0.75)
                .padding(.leading, 4)

            Spacer()

            Menu {
                Button {
                    saveTimeline()
                } label: {
                    Label("Save", systemImage: "tray.and.arrow.down")
                }
            } label: {
                Image(systemName: "ellipsis")
                    .rotationEffect(.degrees(90))
                    .font(.system(size: 24, weight: .bold))
                    .frame(width: 44, height: 44)
            }
        }
        .foregroundColor(Color(hex: "183A38"))
        .padding(.horizontal, 20)
        .padding(.top, 62)
        .padding(.bottom, 24)
        .background(Color.white)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color(hex: "E5E1DB"))
                .frame(height: 1)
        }
    }

    var startDateRow: some View {
        HStack(spacing: 14) {
            Image(systemName: "calendar")
                .font(.system(size: 22, weight: .medium))
                .foregroundColor(Color(hex: "EBAA2D"))
                .frame(width: 26)

            Text("Start date")
                .font(.system(size: 22))
                .foregroundColor(Color(hex: "6E8583"))

            Text(startDateText)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(Color(hex: "183A38"))
                .lineLimit(1)
                .minimumScaleFactor(0.78)
        }
    }

    var exportButtons: some View {
        HStack(spacing: 12) {
            ExportButton(title: "Export CSV") {
                exportCSV()
            }
            ExportButton(title: "Export Gantt") {
                Task {
                    await exportGanttImage()
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    var columnHeaders: some View {
        HStack(spacing: 12) {
            Text("STEP")
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("DATES")
                .frame(width: 82)

            Text("DURATION")
                .frame(width: 92)
        }
        .font(.system(size: 15, weight: .bold))
        .foregroundColor(Color(hex: "6E8583"))
        .tracking(2)
        .padding(.leading, 74)
        .padding(.trailing, 48)
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
            .frame(height: 58)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        Color(hex: "DDD9D2"),
                        style: StrokeStyle(lineWidth: 2, dash: [8])
                    )
            )
        }
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
        .cornerRadius(12)
    }
}

struct EditableTimelineStageRow: View {

    let stage: EditableTimelineStage
    let index: Int
    let onEdit: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Color(hex: stage.colourHex))
                        .frame(width: 46, height: 46)

                    if stage.isMilestone {
                        Image(systemName: "flag")
                            .font(.system(size: 22, weight: .medium))
                            .foregroundColor(.white)
                    } else {
                        Text("\(index)")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .frame(width: 54)

                VStack(alignment: .leading, spacing: 5) {
                    Text(stage.title)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color(hex: "183A38"))
                        .lineLimit(2)
                        .truncationMode(.tail)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(dateText(for: stage))
                        .font(.system(size: 17))
                        .foregroundColor(Color(hex: "6E8583"))
                        .lineLimit(1)
                        .minimumScaleFactor(0.82)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                VStack(spacing: 2) {
                    Text("\(stage.duration)")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color(hex: "EBAA2D"))
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)

                    Text(durationUnitText(for: stage))
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "6E8583"))
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                }
                .frame(width: 48)

                Button {
                    onEdit()
                } label: {
                    Image(systemName: "ellipsis")
                        .rotationEffect(.degrees(90))
                        .font(.system(size: 19, weight: .bold))
                        .foregroundColor(Color(hex: "6E8583"))
                        .frame(width: 28, height: 44)
                }
            }
            .frame(minHeight: 86)
            .padding(.vertical, 8)

            Divider()
                .background(Color(hex: "DDD9D2"))
        }
    }

    private func dateText(for stage: EditableTimelineStage) -> String {
        if stage.durationType == .milestone {
            return Self.dateFormatter.string(from: stage.startDate)
        }

        return "\(Self.dateFormatter.string(from: stage.startDate)) → \(Self.dateFormatter.string(from: stage.endDate))"
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

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter
    }()
}

struct ExportButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: "square.and.arrow.down")
                    .font(.system(size: 20, weight: .medium))

                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }
            .foregroundColor(Color(hex: "183A38"))
            .padding(.horizontal, 14)
            .frame(maxWidth: .infinity)
            .frame(height: 40)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(hex: "DDD9D2"), lineWidth: 1.5)
            )
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.08), radius: 3, x: 0, y: 2)
        }
    }
}
