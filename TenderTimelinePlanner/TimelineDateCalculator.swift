import Foundation

struct TimelineDateCalculator {

    static func recalculate(
        stages: [EditableTimelineStage],
        from startDate: Date
    ) -> [EditableTimelineStage] {

        var recalculated: [EditableTimelineStage] = []
        var currentStart = startDate

        for stage in stages {
            var updated = stage
            updated.startDate = currentStart

            if stage.durationType == .milestone {
                updated.endDate = currentStart
            } else if stage.durationType == .workingDays {
                updated.endDate = addWorkingDays(stage.duration, to: currentStart)
            } else {
                let rawEnd = Calendar.current.date(
                    byAdding: .day,
                    value: stage.duration,
                    to: currentStart
                ) ?? currentStart

                updated.endDate = moveToNextWorkingDayIfNeeded(rawEnd)
            }

            recalculated.append(updated)
            currentStart = updated.endDate
        }

        return recalculated
    }

    static func addWorkingDays(_ days: Int, to date: Date) -> Date {
        var result = date
        var added = 0

        while added < days {
            result = Calendar.current.date(byAdding: .day, value: 1, to: result) ?? result

            if isWorkingDay(result) {
                added += 1
            }
        }

        return result
    }

    static func moveToNextWorkingDayIfNeeded(_ date: Date) -> Date {
        var result = date

        while !isWorkingDay(result) {
            result = Calendar.current.date(byAdding: .day, value: 1, to: result) ?? result
        }

        return result
    }

    static func isWorkingDay(_ date: Date) -> Bool {
        let weekday = Calendar.current.component(.weekday, from: date)

        // Sunday = 1, Saturday = 7
        if weekday == 1 || weekday == 7 {
            return false
        }

        return !ukBankHolidays.contains {
            Calendar.current.isDate($0, inSameDayAs: date)
        }
    }

    static let ukBankHolidays: [Date] = [
        makeDate(2026, 1, 1),
        makeDate(2026, 4, 3),
        makeDate(2026, 4, 6),
        makeDate(2026, 5, 4),
        makeDate(2026, 5, 25),
        makeDate(2026, 8, 31),
        makeDate(2026, 12, 25),
        makeDate(2026, 12, 28)
    ]

    static func makeDate(_ year: Int, _ month: Int, _ day: Int) -> Date {
        Calendar.current.date(from: DateComponents(year: year, month: month, day: day)) ?? Date()
    }
}
