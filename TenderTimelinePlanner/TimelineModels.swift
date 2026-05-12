import SwiftUI

enum StageDurationType: String, Codable, CaseIterable, Sendable {
    case calendarDays
    case workingDays
    case milestone
}

struct EditableTimelineStage: Identifiable, Codable, Sendable {
    var id = UUID()
    var title: String
    var duration: Int
    var durationType: StageDurationType
    var startDate: Date
    var endDate: Date
    var isMilestone: Bool
    var colourHex: String
}

struct SavedTimeline: Identifiable, Codable, Sendable {
    var id = UUID()
    var projectName: String
    var startDateText: String
    var templateName: String
    var stages: [EditableTimelineStage]
    var createdAt = Date()
    var updatedAt = Date()
}

enum SavedTimelineStore {
    private static let storageKey = "savedTimelines"

    static func load() -> [SavedTimeline] {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else {
            return []
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        return (try? decoder.decode([SavedTimeline].self, from: data)) ?? []
    }

    static func save(_ timeline: SavedTimeline) {
        var timelines = load()

        if let index = timelines.firstIndex(where: { existing in
            existing.projectName == timeline.projectName &&
            existing.startDateText == timeline.startDateText &&
            existing.templateName == timeline.templateName
        }) {
            var updated = timeline
            updated.id = timelines[index].id
            updated.createdAt = timelines[index].createdAt
            updated.updatedAt = Date()
            timelines[index] = updated
        } else {
            timelines.insert(timeline, at: 0)
        }

        persist(timelines)
    }

    static func delete(_ timeline: SavedTimeline) {
        let timelines = load().filter { $0.id != timeline.id }
        persist(timelines)
    }

    private static func persist(_ timelines: [SavedTimeline]) {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        guard let data = try? encoder.encode(timelines) else {
            return
        }

        UserDefaults.standard.set(data, forKey: storageKey)
    }
}
