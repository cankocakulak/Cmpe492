import Foundation
import CoreData

struct AnalyticsSnapshot {
    let completedToday: Int
    let completedWeek: Int
    let completedMonth: Int
    let completedLastWeek: Int
    let completedLastMonth: Int
}

enum AnalyticsService {
    static func snapshot(context: NSManagedObjectContext, calendar: Calendar = .current) -> AnalyticsSnapshot {
        let now = Date()
        let todayStart = calendar.startOfDay(for: now)
        let tomorrowStart = calendar.startOfTomorrow(from: todayStart)

        let weekInterval = calendar.dateInterval(of: .weekOfYear, for: now) ?? DateInterval(start: todayStart, duration: 7 * 24 * 60 * 60)
        let monthInterval = calendar.dateInterval(of: .month, for: now) ?? DateInterval(start: todayStart, duration: 30 * 24 * 60 * 60)

        let lastWeekStart = calendar.date(byAdding: .weekOfYear, value: -1, to: weekInterval.start) ?? weekInterval.start
        let lastWeekEnd = weekInterval.start

        let lastMonthStart = calendar.date(byAdding: .month, value: -1, to: monthInterval.start) ?? monthInterval.start
        let lastMonthEnd = monthInterval.start

        return AnalyticsSnapshot(
            completedToday: countCompleted(from: todayStart, to: tomorrowStart, context: context),
            completedWeek: countCompleted(from: weekInterval.start, to: weekInterval.end, context: context),
            completedMonth: countCompleted(from: monthInterval.start, to: monthInterval.end, context: context),
            completedLastWeek: countCompleted(from: lastWeekStart, to: lastWeekEnd, context: context),
            completedLastMonth: countCompleted(from: lastMonthStart, to: lastMonthEnd, context: context)
        )
    }

    private static func countCompleted(from start: Date, to end: Date, context: NSManagedObjectContext) -> Int {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        request.predicate = NSPredicate(format: "completedAt >= %@ AND completedAt < %@", start as NSDate, end as NSDate)
        request.includesSubentities = false

        do {
            return try context.count(for: request)
        } catch {
            return 0
        }
    }
}
