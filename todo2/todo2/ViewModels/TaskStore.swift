import Foundation
import CoreData
import Combine

@MainActor
final class TaskStore: ObservableObject {
    struct UndoAction {
        let id = UUID()
        let label: String
        let action: () -> Void
    }

    struct DeletedSnapshot {
        let id: UUID
        let text: String
        let createdAt: Date
        let updatedAt: Date
        let scheduledDate: Date?
        let completedAt: Date?
        let stateRaw: Int16
        let sortOrder: Double
    }

    @Published var errorMessage: String?
    @Published var undoAction: UndoAction?

    private let context: NSManagedObjectContext
    private let calendar: Calendar

    init(context: NSManagedObjectContext, calendar: Calendar = .current) {
        self.context = context
        self.calendar = calendar
    }

    func createTask(text: String, scheduledDate: Date?, dayStart: Date) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        let task = Task(context: context)
        let now = Date()
        task.id = UUID()
        task.text = trimmed
        task.createdAt = now
        task.updatedAt = now
        task.state = .notStarted
        task.completedAt = nil
        task.scheduledDate = normalizedScheduledDate(scheduledDate, dayStart: dayStart)
        task.sortOrder = insertSortOrder(for: task, dayStart: dayStart, insertAtTop: true)

        saveContext()
    }

    func cycleState(for task: Task, dayStart: Date) {
        let nextState = task.state.next
        setState(task, to: nextState, dayStart: dayStart)
    }

    func setState(_ task: Task, to newState: TaskState, dayStart: Date) {
        let previousState = task.state
        task.state = newState
        task.touchUpdatedAt()

        if newState == .completed {
            task.completedAt = Date()
        } else if previousState == .completed {
            task.completedAt = nil
        }

        task.sortOrder = insertSortOrder(for: task, dayStart: dayStart, insertAtTop: true)
        saveContext()
    }

    func delete(_ task: Task) {
        guard let snapshot = snapshot(for: task) else {
            context.delete(task)
            saveContext()
            return
        }

        context.delete(task)
        saveContext()

        registerUndo(label: "Deleted") { [weak self] in
            self?.restore(snapshot: snapshot)
        }
    }

    func reschedule(_ task: Task, to scheduledDate: Date?, dayStart: Date, label: String) {
        let oldDate = task.scheduledDate
        let oldOrder = task.sortOrder
        let newDate = normalizedScheduledDate(scheduledDate, dayStart: dayStart)

        task.scheduledDate = newDate
        task.sortOrder = insertSortOrder(for: task, dayStart: dayStart, insertAtTop: true)
        task.touchUpdatedAt()
        saveContext()

        registerUndo(label: label) { [weak self, weak task] in
            guard let self, let task else { return }
            task.scheduledDate = oldDate
            task.sortOrder = oldOrder
            task.touchUpdatedAt()
            self.saveContext()
        }
    }

    func move(_ task: Task, to kind: TaskListKind, dayStart: Date) {
        let targetDate = kind.defaultScheduledDate(using: calendar, dayStart: dayStart)
        reschedule(task, to: targetDate, dayStart: dayStart, label: "Move")
    }

    func reorder(tasks: [Task], from sourceIndex: Int, to destinationIndex: Int) {
        guard sourceIndex != destinationIndex else { return }
        let previousOrders = tasks.map { ($0.objectID, $0.sortOrder) }
        var reordered = tasks
        let task = reordered.remove(at: sourceIndex)
        let insertIndex = destinationIndex > sourceIndex ? destinationIndex - 1 : destinationIndex
        reordered.insert(task, at: insertIndex)

        for (index, task) in reordered.enumerated() {
            task.sortOrder = Double(index)
            task.touchUpdatedAt()
        }
        saveContext()

        registerUndo(label: "Reorder") { [weak self] in
            guard let self else { return }
            for (objectID, order) in previousOrders {
                if let task = try? self.context.existingObject(with: objectID) as? Task {
                    task.sortOrder = order
                    task.touchUpdatedAt()
                }
            }
            self.saveContext()
        }
    }

    func reorder(tasks: [Task], fromOffsets: IndexSet, toOffset: Int) {
        let previousOrders = tasks.map { ($0.objectID, $0.sortOrder) }
        var reordered = tasks
        reordered = move(reordered, fromOffsets: fromOffsets, toOffset: toOffset)

        for (index, task) in reordered.enumerated() {
            task.sortOrder = Double(index)
            task.touchUpdatedAt()
        }
        saveContext()

        registerUndo(label: "Reorder") { [weak self] in
            guard let self else { return }
            for (objectID, order) in previousOrders {
                if let task = try? self.context.existingObject(with: objectID) as? Task {
                    task.sortOrder = order
                    task.touchUpdatedAt()
                }
            }
            self.saveContext()
        }
    }

    func performUndo() {
        undoAction?.action()
        undoAction = nil
    }

    func clearError() {
        errorMessage = nil
    }

    private func registerUndo(label: String, action: @escaping () -> Void) {
        let undo = UndoAction(label: label, action: action)
        undoAction = undo
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let self else { return }
            if self.undoAction?.id == undo.id {
                self.undoAction = nil
            }
        }
    }

    private func normalizedScheduledDate(_ date: Date?, dayStart: Date) -> Date? {
        guard let date else { return nil }
        return calendar.startOfDay(for: date)
    }

    private func insertSortOrder(for task: Task, dayStart: Date, insertAtTop: Bool) -> Double {
        let request = NSFetchRequest<NSDictionary>(entityName: "Task")
        request.resultType = .dictionaryResultType
        request.propertiesToFetch = ["sortOrder"]

        let scheduledPredicate = predicateForScheduledDate(task.scheduledDate, dayStart: dayStart)
        let statePredicate = NSPredicate(format: "stateRaw == %d", task.state.rawValue)

        let compound = NSCompoundPredicate(andPredicateWithSubpredicates: [scheduledPredicate, statePredicate])
        request.predicate = compound

        let sortDescriptor = NSSortDescriptor(key: "sortOrder", ascending: insertAtTop)
        request.sortDescriptors = [sortDescriptor]
        request.fetchLimit = 1

        do {
            if let result = try context.fetch(request).first,
               let order = result["sortOrder"] as? Double {
                return insertAtTop ? order - 1 : order + 1
            }
        } catch {
            errorMessage = "Failed to compute sort order."
        }

        return 0
    }

    private func predicateForScheduledDate(_ scheduledDate: Date?, dayStart: Date) -> NSPredicate {
        if let scheduledDate {
            let tomorrowStart = calendar.startOfTomorrow(from: dayStart)
            if scheduledDate < dayStart {
                return NSPredicate(format: "scheduledDate < %@", dayStart as NSDate)
            }
            if scheduledDate >= tomorrowStart {
                return NSPredicate(format: "scheduledDate >= %@", tomorrowStart as NSDate)
            }
            return NSPredicate(format: "scheduledDate >= %@ AND scheduledDate < %@", dayStart as NSDate, tomorrowStart as NSDate)
        }
        return NSPredicate(format: "scheduledDate == nil")
    }

    private func saveContext() {
        do {
            try context.save()
        } catch {
            errorMessage = "Save failed: \((error as NSError).localizedDescription)"
        }
    }

    private func snapshot(for task: Task) -> DeletedSnapshot? {
        guard let id = task.id,
              let text = task.text,
              let createdAt = task.createdAt,
              let updatedAt = task.updatedAt else { return nil }

        return DeletedSnapshot(
            id: id,
            text: text,
            createdAt: createdAt,
            updatedAt: updatedAt,
            scheduledDate: task.scheduledDate,
            completedAt: task.completedAt,
            stateRaw: task.stateRaw,
            sortOrder: task.sortOrder
        )
    }

    private func restore(snapshot: DeletedSnapshot) {
        let task = Task(context: context)
        task.id = snapshot.id
        task.text = snapshot.text
        task.createdAt = snapshot.createdAt
        task.updatedAt = snapshot.updatedAt
        task.scheduledDate = snapshot.scheduledDate
        task.completedAt = snapshot.completedAt
        task.stateRaw = snapshot.stateRaw
        task.sortOrder = snapshot.sortOrder
        saveContext()
    }

    private func move(_ items: [Task], fromOffsets: IndexSet, toOffset: Int) -> [Task] {
        var result = items
        let moving = fromOffsets.map { result[$0] }
        for index in fromOffsets.sorted(by: >) {
            result.remove(at: index)
        }
        let destination = min(toOffset, result.count)
        result.insert(contentsOf: moving, at: destination)
        return result
    }
}
