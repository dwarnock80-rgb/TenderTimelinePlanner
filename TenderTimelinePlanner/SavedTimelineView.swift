import SwiftUI

struct SavedTimeline: Identifiable {
    let id = UUID()
    let title: String
    let startDate: String
    let lastEdited: String
    let icon: String
    let iconColor: Color
    let iconBackground: Color
}

struct SavedTimelinesView: View {

    private func deleteTimeline(_ timeline: SavedTimeline) {
        timelines.removeAll { $0.id == timeline.id }
    }
    
    @State private var searchText = ""

    @State private var timelines: [SavedTimeline] = [
    ]

    var body: some View {

        ZStack {
            Color(hex: "F7F6F2")
                .ignoresSafeArea()

            VStack(spacing: 0) {

                headerSection

                ScrollView {
                    VStack(spacing: 18) {

                        searchBar

                        ForEach(timelines) { timeline in
                            TimelineRow(timeline: timeline)
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        deleteTimeline(timeline)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
                    }
                    .padding(.top, 18)
                    .padding(.bottom, 120)
                }
            }
        }
    }

    var headerSection: some View {

        HStack {
            Text("Saved Timelines")
                .font(.system(size: 34, weight: .bold, design: .serif))
                .foregroundColor(Color(hex: "183A38"))

            Spacer()

            Button {

            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 26, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 76, height: 76)
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

            Image(systemName: timeline.icon)
                .font(.system(size: 34))
                .foregroundColor(timeline.iconColor)
                .frame(width: 92, height: 92)
                .background(timeline.iconBackground)
                .cornerRadius(24)

            VStack(alignment: .leading, spacing: 8) {

                Text(timeline.title)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(Color(hex: "183A38"))

                Text("Start date: \(timeline.startDate)")
                    .font(.system(size: 18))
                    .foregroundColor(Color(hex: "6E8583"))

                Text("Last edited: \(timeline.lastEdited)")
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
