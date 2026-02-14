import Foundation

enum TaskListKind: Int, CaseIterable, Identifiable {
    case inbox
    case today
    case upcoming

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .inbox:
            return "Inbox"
        case .today:
            return "Today"
        case .upcoming:
            return "Upcoming"
        }
    }

    var emptyMessage: String {
        switch self {
        case .inbox:
            return "No inbox tasks"
        case .today:
            return "Nothing scheduled today"
        case .upcoming:
            return "No upcoming tasks"
        }
    }

    func defaultScheduledDate(using calendar: Calendar = .current, dayStart: Date) -> Date? {
        switch self {
        case .inbox:
            return nil
        case .today:
            return dayStart
        case .upcoming:
            return calendar.startOfTomorrow(from: dayStart)
        }
    }
}
