import Foundation

struct TimelineCalculator {

    static func generateStages(
        templateName: String,
        startDate: Date
    ) -> [EditableTimelineStage] {

        return TimelineTemplates.stages(
            for: templateName,
            startDate: startDate
        )
    }
}
