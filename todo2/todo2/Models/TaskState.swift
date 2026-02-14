import Foundation

enum TaskState: Int16, CaseIterable {
    case notStarted = 0
    case active = 1
    case completed = 2

    var displayName: String {
        switch self {
        case .notStarted:
            return "Not Started"
        case .active:
            return "Active"
        case .completed:
            return "Completed"
        }
    }

    var sortRank: Int {
        switch self {
        case .active:
            return 0
        case .notStarted:
            return 1
        case .completed:
            return 2
        }
    }

    var next: TaskState {
        switch self {
        case .notStarted:
            return .active
        case .active:
            return .completed
        case .completed:
            return .notStarted
        }
    }
}
