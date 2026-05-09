import SwiftUI

struct EditStageView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var title: String
    @State private var duration: Int
    @State private var durationType: StageDurationType

    let stage: EditableTimelineStage
    let onSave: (EditableTimelineStage) -> Void

    init(stage: EditableTimelineStage, onSave: @escaping (EditableTimelineStage) -> Void) {
        self.stage = stage
        self.onSave = onSave

        _title = State(initialValue: stage.title)
        _duration = State(initialValue: stage.duration)
        _durationType = State(initialValue: stage.durationType)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Step") {
                    TextField("Step title", text: $title)
                }

                Section("Duration") {
                    Stepper(value: $duration, in: 0...365) {
                        HStack {
                            Text("Days")
                            Spacer()
                            Text("\(duration)")
                                .fontWeight(.bold)
                        }
                    }

                    Picker("Duration type", selection: $durationType) {
                        Text("Calendar days").tag(StageDurationType.calendarDays)
                        Text("Working days").tag(StageDurationType.workingDays)
                        Text("Milestone").tag(StageDurationType.milestone)
                    }
                }
            }
            .navigationTitle("Edit step")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        var updated = stage
                        updated.title = title
                        updated.duration = duration
                        updated.durationType = durationType
                        updated.isMilestone = durationType == .milestone

                        onSave(updated)
                        dismiss()
                    }
                }
            }
        }
    }
}
