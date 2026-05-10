import Foundation

struct ProcurementTimeline: Identifiable, Codable, Sendable {
    var id: UUID = UUID()
    var projectName: String
    var startDate: Date
    var templateName: String
    var stages: [TimelineStage]
    var createdAt: Date = Date()
    var updatedAt: Date = Date()
}
