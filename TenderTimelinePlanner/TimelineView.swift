import SwiftUI

struct TimelineView: View {

    let contractStartDate: Date

    @State private var stages: [TimelineStage] = []
    @State private var showingAddStage = false

    var body: some View {

        List {

            Section(header: Text("Contract")) {
                Text(contractStartDate.formatted(date: .long, time: .omitted))
            }

            Section(header: Text("Procurement Timeline")) {

                ForEach($stages) { $stage in

                    NavigationLink(
                        destination: EditBasicTimelineStageView(stage: $stage)
                    ) {

                        VStack(alignment: .leading) {

                            Text(stage.title)
                                .font(.headline)

                            Text(
                                stage.date.formatted(
                                    date: .abbreviated,
                                    time: .omitted
                                )
                            )
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        }

                    }

                }
                .onDelete(perform: deleteStage)
                .onMove(perform: moveStage)

            }

        }
        .navigationTitle("Timeline")
        .navigationBarItems(
            leading: EditButton(),
            trailing:
                Button(action: {
                    showingAddStage = true
                }) {
                    Image(systemName: "plus")
                }
        )
        .sheet(isPresented: $showingAddStage) {

            AddStageView { stage in
                stages.append(stage)
            }

        }
        .onAppear {

            if stages.isEmpty {

                stages = [
                    TimelineStage(
                        title: "Procurement Planning",
                        date: contractStartDate.addingTimeInterval(-180 * 86400)
                    ),
                    TimelineStage(
                        title: "Tender Publication",
                        date: contractStartDate.addingTimeInterval(-120 * 86400)
                    ),
                    TimelineStage(
                        title: "Tender Return Deadline",
                        date: contractStartDate.addingTimeInterval(-90 * 86400)
                    ),
                    TimelineStage(
                        title: "Evaluation",
                        date: contractStartDate.addingTimeInterval(-60 * 86400)
                    ),
                    TimelineStage(
                        title: "Award",
                        date: contractStartDate.addingTimeInterval(-30 * 86400)
                    ),
                    TimelineStage(
                        title: "Contract Start",
                        date: contractStartDate
                    )
                ]

            }

        }

    }

    func deleteStage(at offsets: IndexSet) {
        stages.remove(atOffsets: offsets)
    }

    func moveStage(from source: IndexSet, to destination: Int) {
        stages.move(fromOffsets: source, toOffset: destination)
    }

}

struct EditBasicTimelineStageView: View {

    @Environment(\.dismiss) private var dismiss

    @Binding var stage: TimelineStage

    var body: some View {
        Form {
            Section(header: Text("Stage Details")) {
                TextField("Title", text: $stage.title)

                DatePicker(
                    "Date",
                    selection: $stage.date,
                    displayedComponents: .date
                )
            }

            Section(header: Text("Notes")) {
                TextEditor(text: $stage.notes)
                    .frame(minHeight: 120)
            }
        }
        .navigationTitle("Edit Stage")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    dismiss()
                }
            }
        }
    }
}

struct AddStageView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var title: String = ""
    @State private var date: Date = Date()
    @State private var notes: String = ""

    let onAdd: (TimelineStage) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Stage Details")) {
                    TextField("Title", text: $title)

                    DatePicker(
                        "Date",
                        selection: $date,
                        displayedComponents: .date
                    )
                }

                Section(header: Text("Notes")) {
                    TextEditor(text: $notes)
                        .frame(minHeight: 120)
                }
            }
            .navigationTitle("Add Stage")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Add") {
                    let newStage = TimelineStage(
                        title: title,
                        date: date,
                        notes: notes
                    )

                    onAdd(newStage)
                    dismiss()
                }
                .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            )
        }
    }
}
