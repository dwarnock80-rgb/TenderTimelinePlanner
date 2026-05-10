import Foundation

enum DurationType: String, Codable, CaseIterable, Sendable {
    case calendarDays
    case workingDays
    case milestone
}
