import SwiftUI

struct SavedTimelinesView: View {

    @State private var searchText = ""
    @State private var timelines: [SavedTimeline] = []

    private var filteredTimelines: [SavedTimeline] {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return timelines
        }

        return timelines.filter { timeline in
            timeline.projectName.localizedCaseInsensitiveContains(searchText) ||
            timeline.templateName.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {

        ZStack {
            Color(hex: "F7F6F2")
                .ignoresSafeArea()

            VStack(spacing: 0) {

                headerSection

                ScrollView {
                    VStack(spacing: 18) {

                        searchBar

                        if filteredTimelines.isEmpty {
                            Text("No saved timelines yet")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(Color(hex: "6E8583"))
                                .frame(maxWidth: .infinity)
                                .padding(.top, 30)
                        } else {
                            ForEach(filteredTimelines) { timeline in
                                NavigationLink {
                                    TimelineDetailView(
                                        projectName: timeline.projectName,
                                        startDateText: timeline.startDateText,
                                        templateName: timeline.templateName,
                                        initialStages: timeline.stages
                                    )
                                } label: {
                                    TimelineRow(timeline: timeline)
                                }
                                .buttonStyle(.plain)
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        deleteTimeline(timeline)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                    }
                    .padding(.top, 18)
                    .padding(.bottom, 120)
                }
            }
        }
        .onAppear {
            timelines = SavedTimelineStore.load()
        }
    }

    private func deleteTimeline(_ timeline: SavedTimeline) {
        SavedTimelineStore.delete(timeline)
        timelines = SavedTimelineStore.load()
    }

    var headerSection: some View {

        HStack {
            Text("Saved Timelines")
                .font(.system(size: 34, weight: .bold, design: .serif))
                .foregroundColor(Color(hex: "183A38"))

            Spacer()

            Button {
                timelines = SavedTimelineStore.load()
            } label: {
                Image(systemName: "arrow.clockwise")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 60, height: 60)
                    .background(Color(hex: "0B4543"))
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 4)
            }
        }
        .padding(.horizontal, 28)
        .padding(.top, 72)
        .padding(.bottom, 26)
    }

    var searchBar: some View {

        HStack(spacing: 14) {

            Image(systemName: "magnifyingglass")
                .font(.system(size: 24))
                .foregroundColor(Color(hex: "6E8583"))

            TextField("Search projects", text: $searchText)
                .font(.system(size: 22))
        }
        .padding()
        .frame(height: 72)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color(hex: "DDD9D2"), lineWidth: 1.5)
        )
        .cornerRadius(18)
        .padding(.horizontal, 26)
    }
}

struct TimelineRow: View {

    let timeline: SavedTimeline

    var body: some View {

        HStack(spacing: 20) {

            Image(systemName: "calendar.badge.clock")
                .font(.system(size: 34))
                .foregroundColor(Color(hex: "EBAA2D"))
                .frame(width: 92, height: 92)
                .background(Color(hex: "FFF1D6"))
                .cornerRadius(24)

            VStack(alignment: .leading, spacing: 8) {

                Text(timeline.projectName)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(Color(hex: "183A38"))
                    .lineLimit(2)

                Text("Start date: \(timeline.startDateText)")
                    .font(.system(size: 18))
                    .foregroundColor(Color(hex: "6E8583"))

                Text("Last edited: \(timeline.updatedAt.formatted(date: .abbreviated, time: .shortened))")
                    .font(.system(size: 18))
                    .foregroundColor(Color(hex: "6E8583"))
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(Color(hex: "6E8583"))
        }
        .padding(24)
        .background(Color.white)
        .cornerRadius(26)
        .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)
        .padding(.horizontal, 26)
    }
}
