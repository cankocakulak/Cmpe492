import CoreData

extension Task {
    var state: TaskState {
        get { TaskState(rawValue: stateRaw ?? TaskState.notStarted.rawValue) ?? .notStarted }
        set { stateRaw = newValue.rawValue }
    }

    var safeText: String {
        text ?? ""
    }

    var isCompleted: Bool {
        state == .completed
    }

    func touchUpdatedAt() {
        updatedAt = Date()
    }
}
