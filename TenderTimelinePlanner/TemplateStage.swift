import Foundation

struct TemplateStage: Sendable {
    let order: Int
    let name: String
    let duration: Int
    let durationType: DurationType
    let isMilestone: Bool
    let colourName: String
    let notes: String?
}
