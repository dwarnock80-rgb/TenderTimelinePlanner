import SwiftUI

struct AddCustomStepView: View {

    @Environment(\.dismiss) private var dismiss

    let stages: [EditableTimelineStage]
    let onAdd: (EditableTimelineStage, Int) -> Void

    @State private var title = "New custom step"
    @State private var duration = 7
    @State private var durationType: StageDurationType = .calendarDays
    @State private var insertionIndex = 0

    var body: some View {
        NavigationStack {
            Form {
                Section("Step details") {
                    TextField("Step title", text: $title)

                    Stepper(value: $duration, in: 0...365) {
                        HStack {
                            Text("Duration")
                            Spacer()
                            Text("\(duration) days")
                                .fontWeight(.bold)
                        }
                    }

                    Picker("Duration type", selection: $durationType) {
                        Text("Calendar days").tag(StageDurationType.calendarDays)
                        Text("Working days").tag(StageDurationType.workingDays)
                        Text("Milestone").tag(StageDurationType.milestone)
                    }
                }

                Section("Position") {
                    Picker("Insert position", selection: $insertionIndex) {
                        Text("At beginning").tag(0)

                        ForEach(Array(stages.enumerated()), id: \.element.id) { index, stage in
                            Text("After \(stage.title)").tag(index + 1)
                        }
                    }
                }
            }
            .navigationTitle("Add custom step")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let newStage = EditableTimelineStage(
                            title: title,
                            duration: duration,
                            durationType: durationType,
                            startDate: Date(),
                            endDate: Date(),
                            isMilestone: durationType == .milestone,
                            colourHex: "64748B"
                        )

                        onAdd(newStage, insertionIndex)
                        dismiss()
                    }
                }
            }
        }
    }
}
