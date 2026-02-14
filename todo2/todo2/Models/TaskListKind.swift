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

    var next: TaskListKind {
        switch self {
        case .inbox:
            return .today
        case .today:
            return .upcoming
        case .upcoming:
            return .upcoming
        }
    }

    var previous: TaskListKind {
        switch self {
        case .inbox:
            return .inbox
        case .today:
            return .inbox
        case .upcoming:
            return .today
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
