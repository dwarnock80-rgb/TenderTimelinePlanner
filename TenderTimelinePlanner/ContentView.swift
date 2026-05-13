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

                    VStack(spacing: 14) {

                        HeaderView()

                        VStack(alignment: .leading, spacing: 12) {

                            Text("Create new timeline")
                                .font(.system(size: 24, weight: .bold, design: .serif))

                            VStack(alignment: .leading, spacing: 6) {

                                Text("Project name")
                                    .foregroundColor(.gray)

                                TextField(
                                    "e.g. School Catering Contract",
                                    text: $projectName
                                )
                                .padding(.horizontal, 14)
                                .frame(height: 48)
                                .background(Color.white)
                                .cornerRadius(12)
                            }

                            VStack(alignment: .leading, spacing: 6) {

                                Text("Start date")
                                    .foregroundColor(.gray)

                                DatePicker(
                                    "",
                                    selection: $startDate,
                                    displayedComponents: .date
                                )
                                .labelsHidden()
                                .padding(.horizontal, 14)
                                .frame(height: 48)
                                .background(Color.white)
                                .cornerRadius(12)
                            }

                            VStack(alignment: .leading, spacing: 6) {

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
                                .padding(.horizontal, 14)
                                .frame(height: 48)
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
                                .frame(height: 50)
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
                                .padding(.horizontal, 14)
                                .frame(height: 54)
                                .background(Color.white)
                                .cornerRadius(14)
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(20)
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(22)
                        .padding(.horizontal, 18)
                        .padding(.bottom, 10)
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

        VStack(spacing: 10) {

            Image(systemName: "triangle")
                .font(.system(size: 26, weight: .medium))
                .foregroundColor(Color(hex: "E7AE42"))
                .frame(width: 58, height: 58)
                .overlay(
                    Rectangle()
                        .stroke(Color(hex: "E7AE42"), lineWidth: 3)
                )
                .padding(.top, 42)

            Text("Tender Timeline")
                .font(.system(size: 32, weight: .bold, design: .serif))
                .foregroundColor(.white)

            Text("Plan procurement timelines with clarity and control.")
                .font(.system(size: 16))
                .foregroundColor(Color.white.opacity(0.65))
                .multilineTextAlignment(.center)
                .lineSpacing(2)
                .padding(.horizontal, 44)
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 32)
        .background(Color(hex: "0B4543"))
    }
}
