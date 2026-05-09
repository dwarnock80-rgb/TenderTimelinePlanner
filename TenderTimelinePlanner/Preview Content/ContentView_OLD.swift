import SwiftUI

struct ContentView: View {
    @State private var projectName = ""
    @State private var startDate = Date()
    @State private var selectedTemplate = "Under Threshold"

    var body: some View {
        TabView {
            HomeView(
                projectName: $projectName,
                startDate: $startDate,
                selectedTemplate: $selectedTemplate
            )
            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }

            AboutView()
                .tabItem {
                    Image(systemName: "info.circle")
                    Text("About")
                }
        }
        .tint(Color(hex: "0B4543"))
    }
}

struct HomeView: View {
    @Binding var projectName: String
    @Binding var startDate: Date
    @Binding var selectedTemplate: String

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "F7F6F2").ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 28) {
                        HeaderView()

                        CreateTimelineCard(
                            projectName: $projectName,
                            startDate: $startDate,
                            selectedTemplate: $selectedTemplate
                        )

                        NavigationLink {
                            SavedTimelinesView()
                        } label: {
                            SavedTimelinesCard()
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.bottom, 24)
                }
                .ignoresSafeArea(edges: .top)
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

struct CreateTimelineCard: View {
    @Binding var projectName: String
    @Binding var startDate: Date
    @Binding var selectedTemplate: String

    let templates = ["Under Threshold", "Procurement Act Open Tender"]

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Create new timeline")
                .font(.system(size: 28, weight: .bold, design: .serif))
                .foregroundColor(Color(hex: "183A38"))
            
            FieldLabel("Project name")
            
            TextField("e.g. School Catering Contract", text: $projectName)
                .font(.system(size: 22))
                .padding()
                .frame(height: 64)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color(hex: "DDD9D2"), lineWidth: 1.5)
                )
            
            FieldLabel("Start date")
            
            DatePicker("", selection: $startDate, displayedComponents: .date)
                .labelsHidden()
                .datePickerStyle(.compact)
                .frame(maxWidth: .infinity)
                .padding()
                .frame(height: 70)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color(hex: "DDD9D2"), lineWidth: 1.5)
                )
            
            FieldLabel("Template")
            
            Picker("Template", selection: $selectedTemplate) {
                ForEach(templates, id: \.self) { template in
                    Text(template)
                }
            }
            .pickerStyle(.menu)
            .font(.system(size: 21))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .frame(height: 64)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color(hex: "DDD9D2"), lineWidth: 1.5)
            )
            
            Text("Pre-defined sequential steps and durations you can customise.")
                .font(.system(size: 18))
                .foregroundColor(Color(hex: "6E8583"))
                .lineSpacing(3)
            
            struct TimelineDetailView: View {

                let projectName: String
                let startDateText: String
                let templateName: String

                var stages: [DisplayTimelineStage] {
                    if templateName == "Procurement Act Open Tender" {
                        return openTenderStages
                    } else {
                        return underThresholdStages
                    }
                }

                let underThresholdStages: [DisplayTimelineStage] = [
                    ...
                ]

                let openTenderStages: [DisplayTimelineStage] = [
                    ...
                ]

                var body: some View {    }
        .padding(26)
        .background(Color.white)
        .cornerRadius(28)
        .shadow(color: .black.opacity(0.12), radius: 18, x: 0, y: 8)
        .padding(.horizontal, 26)
        .offset(y: -54)
        .padding(.bottom, -54)
    }


struct SavedTimelinesCard: View {
    var body: some View {
        HStack(spacing: 18) {
            Image(systemName: "folder")
                .font(.system(size: 30))
                .foregroundColor(Color(hex: "0B4543"))
                .frame(width: 66, height: 66)
                .background(Color(hex: "E8EEEE"))
                .cornerRadius(16)

            VStack(alignment: .leading, spacing: 4) {
                Text("View saved timelines")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(Color(hex: "183A38"))

                Text("Open and edit previously created projects.")
                    .font(.system(size: 18))
                    .foregroundColor(Color(hex: "6E8583"))
            }

            Spacer()

            Image(systemName: "arrow.right")
                .font(.system(size: 24))
                .foregroundColor(Color(hex: "6E8583"))
        }
        .padding(24)
        .background(Color.white)
        .cornerRadius(24)
        .padding(.horizontal, 26)
    }
}

struct FieldLabel: View {
    let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .font(.system(size: 20, weight: .semibold))
            .foregroundColor(Color(hex: "6E8583"))
    }
}

        self.init(
            red: Double((rgb >> 16) & 0xFF) / 255,
            green: Double((rgb >> 8) & 0xFF) / 255,
            blue: Double(rgb & 0xFF) / 255
        )
    }
}

