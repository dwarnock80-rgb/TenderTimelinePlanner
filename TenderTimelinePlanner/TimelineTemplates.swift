import Foundation

struct TimelineTemplates {

    static func stages(for templateName: String, startDate: Date) -> [EditableTimelineStage] {
        let rawStages: [EditableTimelineStage]

        if templateName == "Procurement Act Open Tender" {
            rawStages = openTenderTemplate
        } else if templateName == "Competitive Flexible Process" {
            rawStages = competitiveFlexibleTemplate
        } else {
            rawStages = underThresholdTemplate
        }

        return TimelineDateCalculator.recalculate(
            stages: rawStages,
            from: startDate
        )
    }

    static let underThresholdTemplate: [EditableTimelineStage] = [
        EditableTimelineStage(title: "Draft tender documents", duration: 14, durationType: .calendarDays, startDate: Date(), endDate: Date(), isMilestone: false, colourHex: "EF4444"),
        EditableTimelineStage(title: "Approve Tender Docs", duration: 7, durationType: .calendarDays, startDate: Date(), endDate: Date(), isMilestone: false, colourHex: "F97316"),
        EditableTimelineStage(title: "Publish Tender Notice on FTS", duration: 0, durationType: .milestone, startDate: Date(), endDate: Date(), isMilestone: true, colourHex: "F59E0B"),
        EditableTimelineStage(title: "Tender Period", duration: 14, durationType: .calendarDays, startDate: Date(), endDate: Date(), isMilestone: false, colourHex: "EAB308"),
        EditableTimelineStage(title: "Evaluation and Moderation", duration: 14, durationType: .calendarDays, startDate: Date(), endDate: Date(), isMilestone: false, colourHex: "84CC16"),
        EditableTimelineStage(title: "Award Decision", duration: 0, durationType: .milestone, startDate: Date(), endDate: Date(), isMilestone: true, colourHex: "22C55E"),
        EditableTimelineStage(title: "Issue Award Letters", duration: 1, durationType: .calendarDays, startDate: Date(), endDate: Date(), isMilestone: false, colourHex: "10B981"),
        EditableTimelineStage(title: "Voluntary Standstill", duration: 8, durationType: .workingDays, startDate: Date(), endDate: Date(), isMilestone: false, colourHex: "14B8A6"),
        EditableTimelineStage(title: "Sign Contract", duration: 7, durationType: .calendarDays, startDate: Date(), endDate: Date(), isMilestone: false, colourHex: "06B6D4"),
        EditableTimelineStage(title: "Publish Contract Details Notice", duration: 30, durationType: .calendarDays, startDate: Date(), endDate: Date(), isMilestone: false, colourHex: "0EA5E9")
    ]

    static let openTenderTemplate: [EditableTimelineStage] = [
        EditableTimelineStage(title: "Publish Preliminary Market Engagement Notice", duration: 1, durationType: .milestone, startDate: Date(), endDate: Date(), isMilestone: true, colourHex: "EF4444"),
        EditableTimelineStage(title: "Market Engagement Period", duration: 21, durationType: .calendarDays, startDate: Date(), endDate: Date(), isMilestone: false, colourHex: "F97316"),
        EditableTimelineStage(title: "Draft tender documents", duration: 14, durationType: .calendarDays, startDate: Date(), endDate: Date(), isMilestone: false, colourHex: "F59E0B"),
        EditableTimelineStage(title: "Approve Tender Docs", duration: 7, durationType: .calendarDays, startDate: Date(), endDate: Date(), isMilestone: false, colourHex: "EAB308"),
        EditableTimelineStage(title: "Publish Tender Notice on FTS", duration: 0, durationType: .milestone, startDate: Date(), endDate: Date(), isMilestone: true, colourHex: "84CC16"),
        EditableTimelineStage(title: "Tender Period", duration: 25, durationType: .calendarDays, startDate: Date(), endDate: Date(), isMilestone: false, colourHex: "22C55E"),
        EditableTimelineStage(title: "Evaluation and Moderation", duration: 14, durationType: .calendarDays, startDate: Date(), endDate: Date(), isMilestone: false, colourHex: "10B981"),
        EditableTimelineStage(title: "Award Decision", duration: 1, durationType: .milestone, startDate: Date(), endDate: Date(), isMilestone: true, colourHex: "14B8A6"),
        EditableTimelineStage(title: "Publish Contract Award Notice", duration: 1, durationType: .milestone, startDate: Date(), endDate: Date(), isMilestone: true, colourHex: "06B6D4"),
        EditableTimelineStage(title: "Issue Assessment Summaries", duration: 1, durationType: .calendarDays, startDate: Date(), endDate: Date(), isMilestone: false, colourHex: "0EA5E9"),
        EditableTimelineStage(title: "Standstill", duration: 8, durationType: .workingDays, startDate: Date(), endDate: Date(), isMilestone: false, colourHex: "6366F1"),
        EditableTimelineStage(title: "Sign Contract", duration: 7, durationType: .calendarDays, startDate: Date(), endDate: Date(), isMilestone: false, colourHex: "8B5CF6"),
        EditableTimelineStage(title: "Publish Contract Details Notice", duration: 30, durationType: .calendarDays, startDate: Date(), endDate: Date(), isMilestone: false, colourHex: "EF4444")
    ]

    static let competitiveFlexibleTemplate: [EditableTimelineStage] = [
        EditableTimelineStage(title: "Publish Preliminary Market Engagement Notice", duration: 1, durationType: .milestone, startDate: Date(), endDate: Date(), isMilestone: true, colourHex: "EF4444"),
        EditableTimelineStage(title: "Market Engagement Period", duration: 21, durationType: .calendarDays, startDate: Date(), endDate: Date(), isMilestone: false, colourHex: "F97316"),
        EditableTimelineStage(title: "Draft tender documents", duration: 14, durationType: .calendarDays, startDate: Date(), endDate: Date(), isMilestone: false, colourHex: "F59E0B"),
        EditableTimelineStage(title: "Approve Tender Docs", duration: 7, durationType: .calendarDays, startDate: Date(), endDate: Date(), isMilestone: false, colourHex: "EAB308"),
        EditableTimelineStage(title: "Publish Tender Notice on FTS", duration: 0, durationType: .milestone, startDate: Date(), endDate: Date(), isMilestone: true, colourHex: "84CC16"),
        EditableTimelineStage(title: "Participation Stage", duration: 25, durationType: .calendarDays, startDate: Date(), endDate: Date(), isMilestone: false, colourHex: "22C55E"),
        EditableTimelineStage(title: "1st Stage Tender Period", duration: 30, durationType: .calendarDays, startDate: Date(), endDate: Date(), isMilestone: false, colourHex: "10B981"),
        EditableTimelineStage(title: "Evaluation and Moderation", duration: 14, durationType: .calendarDays, startDate: Date(), endDate: Date(), isMilestone: false, colourHex: "14B8A6"),
        EditableTimelineStage(title: "2nd Stage Tender Period", duration: 14, durationType: .calendarDays, startDate: Date(), endDate: Date(), isMilestone: false, colourHex: "06B6D4"),
        EditableTimelineStage(title: "Evaluation and Moderation", duration: 14, durationType: .calendarDays, startDate: Date(), endDate: Date(), isMilestone: false, colourHex: "0EA5E9"),
        EditableTimelineStage(title: "Award Decision", duration: 1, durationType: .milestone, startDate: Date(), endDate: Date(), isMilestone: true, colourHex: "3B82F6"),
        EditableTimelineStage(title: "Publish Contract Award Notice", duration: 1, durationType: .milestone, startDate: Date(), endDate: Date(), isMilestone: true, colourHex: "6366F1"),
        EditableTimelineStage(title: "Issue Assessment Summaries", duration: 1, durationType: .calendarDays, startDate: Date(), endDate: Date(), isMilestone: false, colourHex: "EF4444"),
        EditableTimelineStage(title: "Standstill", duration: 8, durationType: .workingDays, startDate: Date(), endDate: Date(), isMilestone: false, colourHex: "F97316"),
        EditableTimelineStage(title: "Sign Contract", duration: 7, durationType: .calendarDays, startDate: Date(), endDate: Date(), isMilestone: false, colourHex: "F59E0B"),
        EditableTimelineStage(title: "Publish Contract Details Notice", duration: 30, durationType: .calendarDays, startDate: Date(), endDate: Date(), isMilestone: false, colourHex: "EAB308")
    ]
}
