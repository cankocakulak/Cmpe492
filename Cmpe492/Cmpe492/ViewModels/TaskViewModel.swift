//
//  TaskViewModel.swift
//  Cmpe492
//
//  Created for Story 1.3 - MVVM structure and Task CRUD operations
//

import Foundation
import CoreData
import Combine
import os

@MainActor
final class TaskViewModel: NSObject, ObservableObject {
    enum Filter {
        case all
        case inbox
        case upcoming
        case today
    }

    @Published private(set) var tasks: [Task] = []
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    @Published var restoreInputText: String?

    var completedCount: Int {
        tasks.filter { $0.stateValue == .completed }.count
    }

    private let context: NSManagedObjectContext
    private let filter: Filter
    private var referenceDate: Date
    private var defaultScheduledDate: Date?
    private let fetchedResultsController: NSFetchedResultsController<Task>
    private let logger = Logger(subsystem: "Cmpe492", category: "TaskViewModel")
    private var filterLabel: String {
        switch filter {
        case .all: return "all"
        case .inbox: return "inbox"
        case .upcoming: return "upcoming"
        case .today: return "today"
        }
    }

    init(
        context: NSManagedObjectContext = PersistenceController.shared.container.viewContext,
        filter: Filter = .all,
        referenceDate: Date = Date()
    ) {
        self.context = context
        self.filter = filter
        self.referenceDate = referenceDate

        let request: NSFetchRequest<Task> = Task.fetchRequest()
        switch filter {
        case .all:
            defaultScheduledDate = nil
        case .inbox:
            request.predicate = NSPredicate(format: "scheduledDate == nil")
            defaultScheduledDate = nil
        case .upcoming:
            let startOfTomorrow = DateHelpers.startOfTomorrow(for: referenceDate)
            request.predicate = NSPredicate(format: "scheduledDate >= %@", startOfTomorrow as NSDate)
            defaultScheduledDate = startOfTomorrow
        case .today:
            let todayStart = DateHelpers.startOfDay(for: referenceDate)
            let tomorrowStart = DateHelpers.startOfTomorrow(for: referenceDate)
            request.predicate = NSPredicate(
                format: "scheduledDate >= %@ AND scheduledDate < %@",
                todayStart as NSDate,
                tomorrowStart as NSDate
            )
            defaultScheduledDate = todayStart
        }
        request.sortDescriptors = [
            NSSortDescriptor(key: "sortOrder", ascending: true),
            NSSortDescriptor(key: "createdAt", ascending: true)
        ]
        request.fetchBatchSize = 50

        self.fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        super.init()

        fetchedResultsController.delegate = self

        do {
            try PerformanceMetrics.measure("fetchTasks_initial_\(filterLabel)") {
                try fetchedResultsController.performFetch()
            }
            tasks = sortTasks(fetchedResultsController.fetchedObjects ?? [])
        } catch {
            logger.error("Initial fetch failed: \(error.localizedDescription)")
        }
    }

    func createTask(text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        let now = Date()
        let task = Task(context: context)
        task.id = UUID()
        task.text = trimmed
        task.state = TaskState.notStarted.rawValue
        task.createdAt = now
        task.updatedAt = now
        task.completedAt = nil
        task.scheduledDate = defaultScheduledDate
        task.sortOrder = nextSortOrder()

        // Optimistic UI update happens as soon as the task is inserted into the context
        saveWithRetry(task: task, originalText: trimmed, attempt: 1)
    }

    func deleteTask(_ task: Task) {
        context.delete(task)
        do {
            try context.save()
        } catch {
            logger.error("Delete failed: \(error.localizedDescription)")
            handleSaveFailure(originalText: nil)
        }
    }

    func updateTaskText(_ task: Task, text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        task.text = trimmed
        task.updatedAt = Date()
        do {
            try context.save()
        } catch {
            logger.error("Update failed: \(error.localizedDescription)")
            handleSaveFailure(originalText: nil, error: error)
        }
    }

    func updateTaskState(taskID: UUID, to state: TaskState, now: Date = Date()) {
        guard let task = fetchTask(with: taskID) else {
            logger.error("Update state failed: task not found")
            return
        }

        switch state {
        case .active:
            task.markActive(now: now)
        case .completed:
            task.markCompleted(now: now)
        case .notStarted:
            task.markNotStarted(now: now)
        }

        do {
            try context.save()
        } catch {
            logger.error("Update state failed: \(error.localizedDescription)")
            handleSaveFailure(originalText: nil, error: error)
        }
    }

    func cycleTaskState(taskID: UUID, now: Date = Date()) {
        guard let task = fetchTask(with: taskID) else {
            logger.error("Cycle state failed: task not found")
            return
        }

        let nextState: TaskState
        switch task.stateValue {
        case .notStarted:
            nextState = .active
        case .active:
            nextState = .completed
        case .completed:
            nextState = .notStarted
        }

        updateTaskState(taskID: taskID, to: nextState, now: now)
    }

    func moveTasks(fromOffsets: IndexSet, toOffset: Int, persist: Bool = true) {
        guard !fromOffsets.isEmpty,
              fromOffsets.allSatisfy({ tasks.indices.contains($0) }),
              let firstIndex = fromOffsets.first else {
            return
        }

        let movingState = tasks[firstIndex].stateValue
        let shouldClampToStateGroup = fromOffsets.allSatisfy { index in
            tasks[index].stateValue == movingState
        }
        var clampedOffset = toOffset
        if shouldClampToStateGroup {
            let groupIndices = tasks.indices.filter { tasks[$0].stateValue == movingState }
            if let start = groupIndices.first, let end = groupIndices.last {
                clampedOffset = min(max(toOffset, start), end + 1)
            }
        }

        var reordered = tasks
        PerformanceMetrics.measure("reorderTasks") {
            let movingTasks = fromOffsets.map { reordered[$0] }
            for index in fromOffsets.sorted(by: >) {
                reordered.remove(at: index)
            }
            let adjustedOffset = clampedOffset - fromOffsets.filter { $0 < clampedOffset }.count
            reordered.insert(contentsOf: movingTasks, at: max(0, min(reordered.count, adjustedOffset)))
        }
        let now = Date()
        for (order, item) in reordered.enumerated() {
            item.sortOrder = Int32(order)
            item.updatedAt = now
        }

        tasks = sortTasks(reordered)
        if persist {
            persistSortOrderInBackground(taskIDs: tasks.map(\.objectID))
        }
    }

    func persistCurrentOrder() {
        persistSortOrderInBackground(taskIDs: tasks.map(\.objectID))
    }

    func moveTaskToToday(taskID: UUID, insertAt index: Int) {
        let todayStart = DateHelpers.startOfDay(for: referenceDate)
        moveTask(taskID: taskID, toScheduledDate: todayStart, insertAt: index)
    }

    func moveTaskToTomorrow(taskID: UUID, insertAt index: Int) {
        let tomorrowStart = DateHelpers.startOfTomorrow(for: referenceDate)
        moveTaskToDateGroup(taskID: taskID, scheduledDate: tomorrowStart, insertAt: index, groupDate: tomorrowStart)
    }

    func moveTaskToInbox(taskID: UUID, insertAt index: Int) {
        moveTask(taskID: taskID, toScheduledDate: nil, insertAt: index)
    }

    func setScheduledDate(taskID: UUID, date: Date?) {
        guard let task = fetchTask(with: taskID) else {
            logger.error("Set scheduled date failed: task not found")
            return
        }

        let normalizedDate = date.map { DateHelpers.startOfDay(for: $0) }
        task.scheduledDate = normalizedDate
        task.updatedAt = Date()
        task.sortOrder = nextSortOrder(for: normalizedDate)

        do {
            try context.save()
        } catch {
            logger.error("Set scheduled date failed: \(error.localizedDescription)")
            handleSaveFailure(originalText: nil, error: error)
        }
    }

    func restoreTask(taskID: UUID, toScheduledDate scheduledDate: Date?, insertAt index: Int) {
        guard let task = fetchTask(with: taskID) else {
            logger.error("Restore task failed: task not found")
            return
        }

        let normalizedDate = scheduledDate.map { DateHelpers.startOfDay(for: $0) }
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        if let normalizedDate {
            let start = DateHelpers.startOfDay(for: normalizedDate)
            let end = DateHelpers.startOfTomorrow(for: normalizedDate)
            request.predicate = NSPredicate(
                format: "scheduledDate >= %@ AND scheduledDate < %@",
                start as NSDate,
                end as NSDate
            )
        } else {
            request.predicate = NSPredicate(format: "scheduledDate == nil")
        }
        request.sortDescriptors = [
            NSSortDescriptor(key: "sortOrder", ascending: true),
            NSSortDescriptor(key: "createdAt", ascending: true)
        ]

        do {
            var groupTasks = try context.fetch(request)
            groupTasks.removeAll { $0.id == taskID }
            let clampedIndex = max(0, min(groupTasks.count, index))
            groupTasks.insert(task, at: clampedIndex)

            let now = Date()
            task.scheduledDate = normalizedDate
            for (order, item) in groupTasks.enumerated() {
                item.sortOrder = Int32(order)
                item.updatedAt = now
            }

            try context.save()
        } catch {
            logger.error("Restore task failed: \(error.localizedDescription)")
            handleSaveFailure(originalText: nil, error: error)
        }
    }

    var tomorrowStartDate: Date {
        DateHelpers.startOfTomorrow(for: referenceDate)
    }

    func refresh() {
        do {
            try PerformanceMetrics.measure("fetchTasks_refresh_\(filterLabel)") {
                try fetchedResultsController.performFetch()
            }
            tasks = sortTasks(fetchedResultsController.fetchedObjects ?? [])
        } catch {
            logger.error("Refresh failed: \(error.localizedDescription)")
        }
    }

    func clearRestoreInput() {
        restoreInputText = nil
    }

    func refreshForNewDay(referenceDate: Date = Date()) {
        // Intentional: refresh filters only; never mutate scheduledDate (no automatic rollover).
        self.referenceDate = referenceDate

        switch filter {
        case .today:
            let todayStart = DateHelpers.startOfDay(for: referenceDate)
            let tomorrowStart = DateHelpers.startOfTomorrow(for: referenceDate)
            fetchedResultsController.fetchRequest.predicate = NSPredicate(
                format: "scheduledDate >= %@ AND scheduledDate < %@",
                todayStart as NSDate,
                tomorrowStart as NSDate
            )
            defaultScheduledDate = todayStart
        case .upcoming:
            let startOfTomorrow = DateHelpers.startOfTomorrow(for: referenceDate)
            fetchedResultsController.fetchRequest.predicate = NSPredicate(
                format: "scheduledDate >= %@",
                startOfTomorrow as NSDate
            )
            defaultScheduledDate = startOfTomorrow
        case .all, .inbox:
            break
        }

        refresh()
    }

    func groupedTasksByScheduledDate() -> [TaskSection] {
        let grouped = Dictionary(grouping: tasks) { task -> Date in
            let scheduled = task.scheduledDate ?? referenceDate
            return DateHelpers.startOfDay(for: scheduled)
        }

        let sortedDates = grouped.keys.sorted()
        return sortedDates.map { date in
            let tasksForDate = grouped[date] ?? []
            return TaskSection(
                date: date,
                title: DateHelpers.sectionTitle(for: date, referenceDate: referenceDate),
                tasks: tasksForDate
            )
        }
    }

    private func nextSortOrder() -> Int32 {
        let maxOrder = tasks.map { $0.sortOrder }.max() ?? -1
        return maxOrder + 1
    }

    private func nextSortOrder(for scheduledDate: Date?) -> Int32 {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        if let scheduledDate {
            let start = DateHelpers.startOfDay(for: scheduledDate)
            let end = DateHelpers.startOfTomorrow(for: scheduledDate)
            request.predicate = NSPredicate(
                format: "scheduledDate >= %@ AND scheduledDate < %@",
                start as NSDate,
                end as NSDate
            )
        } else {
            request.predicate = NSPredicate(format: "scheduledDate == nil")
        }
        request.sortDescriptors = [NSSortDescriptor(key: "sortOrder", ascending: false)]
        request.fetchLimit = 1

        do {
            let maxTask = try context.fetch(request).first
            return (maxTask?.sortOrder ?? -1) + 1
        } catch {
            logger.error("Fetch max sortOrder failed: \(error.localizedDescription)")
            return nextSortOrder()
        }
    }

    private func moveTask(taskID: UUID, toScheduledDate scheduledDate: Date?, insertAt index: Int) {
        guard let task = fetchTask(with: taskID) else {
            logger.error("Move task failed: task not found")
            return
        }

        var updated = tasks.filter { $0.id != taskID }
        let clampedIndex = max(0, min(updated.count, index))
        updated.insert(task, at: clampedIndex)

        let now = Date()
        task.scheduledDate = scheduledDate
        for (order, item) in updated.enumerated() {
            item.sortOrder = Int32(order)
            item.updatedAt = now
        }

        do {
            try context.save()
            tasks = updated
        } catch {
            logger.error("Move task failed: \(error.localizedDescription)")
            handleSaveFailure(originalText: nil, error: error)
        }
    }

    private func moveTaskToDateGroup(taskID: UUID, scheduledDate: Date, insertAt index: Int, groupDate: Date) {
        guard let task = fetchTask(with: taskID) else {
            logger.error("Move task failed: task not found")
            return
        }

        let now = Date()
        task.scheduledDate = scheduledDate
        task.updatedAt = now

        var groupTasks = tasks.filter { item in
            guard let date = item.scheduledDate else { return false }
            return DateHelpers.startOfDay(for: date) == groupDate
        }
        groupTasks.removeAll { $0.id == taskID }
        let clampedIndex = max(0, min(groupTasks.count, index))
        groupTasks.insert(task, at: clampedIndex)

        for (order, item) in groupTasks.enumerated() {
            item.sortOrder = Int32(order)
            item.updatedAt = now
        }

        do {
            try context.save()
            refresh()
        } catch {
            logger.error("Move task failed: \(error.localizedDescription)")
            handleSaveFailure(originalText: nil, error: error)
        }
    }

    private func fetchTask(with id: UUID) -> Task? {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            return try context.fetch(request).first
        } catch {
            logger.error("Fetch task failed: \(error.localizedDescription)")
            return nil
        }
    }

    private lazy var backgroundContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = self.context.persistentStoreCoordinator
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }()

    private func persistSortOrderInBackground(taskIDs: [NSManagedObjectID]) {
        guard !taskIDs.isEmpty else { return }
        let backgroundContext = backgroundContext
        let logger = logger
        backgroundContext.perform {
            PerformanceMetrics.measure("sortOrderPersist") {
                let now = Date()
                for (index, objectID) in taskIDs.enumerated() {
                    guard let task = try? backgroundContext.existingObject(with: objectID) as? Task else {
                        continue
                    }
                    task.sortOrder = Int32(index)
                    task.updatedAt = now
                }

                do {
                    try backgroundContext.save()
                } catch {
                    logger.error("Background sort order save failed: \(error.localizedDescription)")
                }
            }
        }
    }

    private func saveWithRetry(task: Task, originalText: String, attempt: Int) {
        let attemptLabel = "saveAttempt_\(attempt)"
        context.perform { [weak self] in
            guard let self else { return }
            PerformanceMetrics.measure(attemptLabel) {
                do {
                    try self.context.save()
                } catch {
                    self.logger.error("Save attempt \(attempt) failed: \(error.localizedDescription)")
                    if attempt < 3 {
                        let delaySeconds = pow(2.0, Double(attempt - 1)) * 0.2
                        DispatchQueue.main.asyncAfter(deadline: .now() + delaySeconds) { [weak self] in
                            self?.saveWithRetry(task: task, originalText: originalText, attempt: attempt + 1)
                        }
                    } else {
                        // Roll back the failed insert and surface the error to the UI
                        self.context.delete(task)
                        self.context.processPendingChanges()
                        self.handleSaveFailure(originalText: originalText, error: error)
                    }
                }
            }
        }
    }

    private func handleSaveFailure(originalText: String?, error: Error? = nil) {
        let nsError = error as NSError?
        if nsError?.domain == NSCocoaErrorDomain && nsError?.code == NSFileWriteOutOfSpaceError {
            errorMessage = "Unable to save task. Please check device storage."
        } else {
            errorMessage = "Failed to save task. Please try again."
        }
        showError = true
        if let originalText {
            restoreInputText = originalText
        }
    }
}

extension TaskViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tasks = sortTasks(fetchedResultsController.fetchedObjects ?? [])
    }
}

private extension TaskViewModel {
    func sortTasks(_ input: [Task]) -> [Task] {
        input.sorted { lhs, rhs in
            let lhsOrder = stateOrder(for: lhs.stateValue)
            let rhsOrder = stateOrder(for: rhs.stateValue)
            if lhsOrder != rhsOrder {
                return lhsOrder < rhsOrder
            }

            if lhs.sortOrder != rhs.sortOrder {
                return lhs.sortOrder < rhs.sortOrder
            }

            let lhsDate = lhs.createdAt ?? Date.distantPast
            let rhsDate = rhs.createdAt ?? Date.distantPast
            return lhsDate < rhsDate
        }
    }

    func stateOrder(for state: TaskState) -> Int {
        switch state {
        case .active:
            return 0
        case .notStarted:
            return 1
        case .completed:
            return 2
        }
    }
}

struct TaskSection: Identifiable {
    let date: Date
    let title: String
    let tasks: [Task]

    var id: Date { date }
}
