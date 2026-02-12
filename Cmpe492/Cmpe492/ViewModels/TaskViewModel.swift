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

    private let context: NSManagedObjectContext
    private let filter: Filter
    private var referenceDate: Date
    private var defaultScheduledDate: Date?
    private let fetchedResultsController: NSFetchedResultsController<Task>
    private let logger = Logger(subsystem: "Cmpe492", category: "TaskViewModel")

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
            try fetchedResultsController.performFetch()
            tasks = fetchedResultsController.fetchedObjects ?? []
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

    func refresh() {
        do {
            try fetchedResultsController.performFetch()
            tasks = fetchedResultsController.fetchedObjects ?? []
        } catch {
            logger.error("Refresh failed: \(error.localizedDescription)")
        }
    }

    func clearRestoreInput() {
        restoreInputText = nil
    }

    func refreshForNewDay(referenceDate: Date = Date()) {
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
            let tasksForDate = (grouped[date] ?? []).sorted { lhs, rhs in
                if lhs.sortOrder != rhs.sortOrder {
                    return lhs.sortOrder < rhs.sortOrder
                }
                let lhsCreated = lhs.createdAt ?? .distantPast
                let rhsCreated = rhs.createdAt ?? .distantPast
                return lhsCreated < rhsCreated
            }
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
        tasks = fetchedResultsController.fetchedObjects ?? []
    }
}

struct TaskSection: Identifiable {
    let date: Date
    let title: String
    let tasks: [Task]

    var id: Date { date }
}
