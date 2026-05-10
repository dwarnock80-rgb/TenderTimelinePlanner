import Foundation

struct TimelineStage: Identifiable, Codable, Sendable {
    var id = UUID()
    var title: String
    var date: Date
    var notes: String = ""
}
