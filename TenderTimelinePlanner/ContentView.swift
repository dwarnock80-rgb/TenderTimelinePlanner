import SwiftUI

struct ContentView: View {

    @State private var projectName = ""
    @State private var startDate = Date()
    @State private var selectedTemplate = "Under Threshold"

    let templates = [
        "Under Threshold",
        "Procurement Act Open Tender",
        "Competitive Flexible Process"
    ]

    var body: some View {

        TabView {

            NavigationStack {

                ScrollView {

                    VStack(spacing: 24) {

                        HeaderView()

                        VStack(alignment: .leading, spacing: 20) {

                            Text("Create new timeline")
                                .font(.system(size: 28, weight: .bold, design: .serif))

                            VStack(alignment: .leading, spacing: 8) {

                                Text("Project name")
                                    .foregroundColor(.gray)

                                TextField(
                                    "e.g. School Catering Contract",
                                    text: $projectName
                                )
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                            }

                            VStack(alignment: .leading, spacing: 8) {

                                Text("Start date")
                                    .foregroundColor(.gray)

                                DatePicker(
                                    "",
                                    selection: $startDate,
                                    displayedComponents: .date
                                )
                                .labelsHidden()
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                            }

                            VStack(alignment: .leading, spacing: 8) {

                                Text("Template")
                                    .foregroundColor(.gray)

                                Picker(
                                    "Template",
                                    selection: $selectedTemplate
                                ) {
                                    ForEach(templates, id: \.self) {
                                        Text($0)
                                    }
                                }
                                .pickerStyle(.menu)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                            }

                            NavigationLink {

                                TimelineDetailView(
                                    projectName: projectName,
                                    startDateText: startDate.formatted(
                                        date: .abbreviated,
                                        time: .omitted
                                    ),
                                    templateName: selectedTemplate
                                )

                            } label: {

                                HStack {

                                    Spacer()

                                    Text("Generate Timeline")
                                        .fontWeight(.bold)

                                    Spacer()
                                }
                                .padding()
                                .background(Color.orange.opacity(0.7))
                                .foregroundColor(.white)
                                .cornerRadius(14)
                            }

                            NavigationLink {

                                SavedTimelinesView()

                            } label: {

                                HStack {

                                    Image(systemName: "folder")

                                    VStack(alignment: .leading) {

                                        Text("View saved timelines")
                                            .fontWeight(.bold)

                                        Text("Open and edit projects")
                                            .font(.caption)
                                    }

                                    Spacer()
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(14)
                            }
                            .buttonStyle(.plain)
                        }
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(24)
                        .padding()
                    }
                }
                .background(Color(.systemGroupedBackground))
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }

            AboutView()
                .tabItem {
                    Label("About", systemImage: "info.circle")
                }
        }
    }
}

struct HeaderView: View {

    var body: some View {

        VStack(spacing: 18) {

            Image(systemName: "triangle")
                .font(.system(size: 36, weight: .medium))
                .foregroundColor(Color(hex: "E7AE42"))
                .frame(width: 92, height: 92)
                .overlay(
                    Rectangle()
                        .stroke(Color(hex: "E7AE42"), lineWidth: 4)
                )
                .padding(.top, 70)

            Text("Tender Timeline")
                .font(.system(size: 42, weight: .bold, design: .serif))
                .foregroundColor(.white)

            Text("Plan procurement timelines with clarity and control.")
                .font(.system(size: 20))
                .foregroundColor(Color.white.opacity(0.65))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, 50)
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 76)
        .background(Color(hex: "0B4543"))
    }
}
