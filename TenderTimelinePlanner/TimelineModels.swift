import SwiftUI

enum StageDurationType: String, Codable, CaseIterable {
    case calendarDays
    case workingDays
    case milestone
}

struct EditableTimelineStage: Identifiable, Codable {
    var id = UUID()
    var title: String
    var duration: Int
    var durationType: StageDurationType
    var startDate: Date
    var endDate: Date
    var isMilestone: Bool
    var colourHex: String
}
