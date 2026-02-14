import Foundation

struct TaskFilter {
    static func tasks(for kind: TaskListKind, from tasks: [Task], dayStart: Date, calendar: Calendar = .current) -> [Task] {
        let tomorrowStart = calendar.startOfTomorrow(from: dayStart)
        let filtered: [Task]
        switch kind {
        case .inbox:
            filtered = tasks.filter { $0.scheduledDate == nil }
        case .today:
            filtered = tasks.filter { task in
                guard let scheduled = task.scheduledDate else { return false }
                return scheduled >= dayStart && scheduled < tomorrowStart
            }
        case .upcoming:
            filtered = tasks.filter { task in
                guard let scheduled = task.scheduledDate else { return false }
                return scheduled >= tomorrowStart
            }
        }

        return sort(filtered)
    }

    static func sort(_ tasks: [Task]) -> [Task] {
        tasks.sorted { lhs, rhs in
            if lhs.state.sortRank != rhs.state.sortRank {
                return lhs.state.sortRank < rhs.state.sortRank
            }
            if lhs.sortOrder != rhs.sortOrder {
                return lhs.sortOrder < rhs.sortOrder
            }
            let lhsCreated = lhs.createdAt ?? .distantPast
            let rhsCreated = rhs.createdAt ?? .distantPast
            return lhsCreated < rhsCreated
        }
    }
}
