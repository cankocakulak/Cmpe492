//
//  TaskViewModelTests.swift
//  Cmpe492Tests
//
//  Created for Story 1.3 - TaskViewModel CRUD tests
//

import XCTest
import Foundation
import CoreData
@testable import Cmpe492

@MainActor
final class TaskViewModelTests: XCTestCase {
    private var controller: PersistenceController!
    private var context: NSManagedObjectContext!

    override func setUp() {
        super.setUp()
        controller = PersistenceController(inMemory: true)
        context = controller.container.viewContext
    }

    final class FailingSaveContext: NSManagedObjectContext {
        override func save() throws {
            throw NSError(domain: NSCocoaErrorDomain, code: 133030, userInfo: nil)
        }
    }

    func testCreateTaskWithEmptyTextDoesNothing() throws {
        let viewModel = TaskViewModel(context: context)
        viewModel.createTask(text: "   ")
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))
        XCTAssertEqual(viewModel.tasks.count, 0)
    }

    func testCreateTaskSetsRequiredFields() throws {
        let viewModel = TaskViewModel(context: context)
        viewModel.createTask(text: "Test Task")
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        XCTAssertEqual(viewModel.tasks.count, 1)
        guard let task = viewModel.tasks.first else {
            XCTFail("Task should exist")
            return
        }

        XCTAssertNotNil(task.id)
        XCTAssertEqual(task.text, "Test Task")
        XCTAssertEqual(task.state, TaskState.notStarted.rawValue)
        XCTAssertNotNil(task.createdAt)
        XCTAssertNotNil(task.updatedAt)
        XCTAssertNil(task.completedAt)
        XCTAssertNil(task.scheduledDate)
    }

    func testCreateTaskSortOrderIncrements() throws {
        let viewModel = TaskViewModel(context: context)
        viewModel.createTask(text: "First")
        viewModel.createTask(text: "Second")
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        XCTAssertEqual(viewModel.tasks.count, 2)
        let orders = viewModel.tasks.map { $0.sortOrder }
        XCTAssertEqual(orders, orders.sorted())
    }

    func testCreateTaskRetriesAndSurfacesErrorOnFailure() throws {
        let failingContext = FailingSaveContext(concurrencyType: .mainQueueConcurrencyType)
        failingContext.persistentStoreCoordinator = controller.container.persistentStoreCoordinator

        let viewModel = TaskViewModel(context: failingContext)
        viewModel.createTask(text: "Will Fail")

        let exp = expectation(description: "wait for retry attempts")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.5)

        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, "Failed to save task. Please try again.")
        XCTAssertEqual(viewModel.restoreInputText, "Will Fail")
    }

    func testCreateTaskPerformance() throws {
        measure {
            let viewModel = TaskViewModel(context: context)
            viewModel.createTask(text: "Perf Task")
            RunLoop.main.run(until: Date().addingTimeInterval(0.01))
        }
    }

    func testDeleteTaskRemovesFromContext() throws {
        let task = Task(context: context)
        task.id = UUID()
        task.text = "Delete Me"
        task.state = TaskState.notStarted.rawValue
        task.createdAt = Date()
        task.updatedAt = task.createdAt
        task.completedAt = nil
        task.scheduledDate = nil
        task.sortOrder = 0

        let taskID = task.id!
        try context.save()

        let viewModel = TaskViewModel(context: context)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))
        XCTAssertEqual(viewModel.tasks.count, 1)

        viewModel.deleteTask(task)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        XCTAssertEqual(viewModel.tasks.count, 0)

        let fetch: NSFetchRequest<Task> = Task.fetchRequest()
        fetch.predicate = NSPredicate(format: "id == %@", taskID as CVarArg)
        let deleted = try context.fetch(fetch)
        XCTAssertTrue(deleted.isEmpty)
    }

    func testDeleteTaskFailureRollsBackAndShowsError() throws {
        let baseTask = Task(context: context)
        baseTask.id = UUID()
        baseTask.text = "Cannot Delete"
        baseTask.state = TaskState.notStarted.rawValue
        baseTask.createdAt = Date()
        baseTask.updatedAt = baseTask.createdAt
        baseTask.completedAt = nil
        baseTask.scheduledDate = nil
        baseTask.sortOrder = 0
        try context.save()

        let failingContext = FailingSaveContext(concurrencyType: .mainQueueConcurrencyType)
        failingContext.persistentStoreCoordinator = controller.container.persistentStoreCoordinator

        let fetch: NSFetchRequest<Task> = Task.fetchRequest()
        fetch.predicate = NSPredicate(format: "id == %@", baseTask.id! as CVarArg)
        guard let failingTask = try failingContext.fetch(fetch).first else {
            XCTFail("Expected task in failing context")
            return
        }

        let viewModel = TaskViewModel(context: failingContext)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))
        viewModel.deleteTask(failingTask)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, "Unable to delete task. Please try again.")
        XCTAssertEqual(viewModel.tasks.count, 1)

        let refreshed = TaskViewModel(context: context)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))
        XCTAssertEqual(refreshed.tasks.count, 1)
    }

    func testInboxFilterReturnsOnlyUnscheduledTasks() throws {
        let inboxTaskId = UUID()
        let scheduledTaskId = UUID()

        let inboxTask = Task(context: context)
        inboxTask.id = inboxTaskId
        inboxTask.text = "Inbox"
        inboxTask.state = TaskState.notStarted.rawValue
        inboxTask.createdAt = Date()
        inboxTask.updatedAt = inboxTask.createdAt
        inboxTask.completedAt = nil
        inboxTask.scheduledDate = nil
        inboxTask.sortOrder = 0

        let scheduledTask = Task(context: context)
        scheduledTask.id = scheduledTaskId
        scheduledTask.text = "Scheduled"
        scheduledTask.state = TaskState.notStarted.rawValue
        scheduledTask.createdAt = Date().addingTimeInterval(1)
        scheduledTask.updatedAt = scheduledTask.createdAt
        scheduledTask.completedAt = nil
        scheduledTask.scheduledDate = Date().addingTimeInterval(3600)
        scheduledTask.sortOrder = 1

        try context.save()

        let inboxViewModel = TaskViewModel(context: context, filter: .inbox)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        XCTAssertEqual(inboxViewModel.tasks.count, 1)
        XCTAssertEqual(inboxViewModel.tasks.first?.id, inboxTaskId)
        XCTAssertNil(inboxViewModel.tasks.first?.scheduledDate)
    }

    func testInboxFilterSortsBySortOrderThenCreatedAt() throws {
        let baseDate = Date()

        let taskA = Task(context: context)
        taskA.id = UUID()
        taskA.text = "Sort A"
        taskA.state = TaskState.notStarted.rawValue
        taskA.createdAt = baseDate.addingTimeInterval(20)
        taskA.updatedAt = taskA.createdAt
        taskA.completedAt = nil
        taskA.scheduledDate = nil
        taskA.sortOrder = 1

        let taskB = Task(context: context)
        taskB.id = UUID()
        taskB.text = "Sort B"
        taskB.state = TaskState.notStarted.rawValue
        taskB.createdAt = baseDate.addingTimeInterval(10)
        taskB.updatedAt = taskB.createdAt
        taskB.completedAt = nil
        taskB.scheduledDate = nil
        taskB.sortOrder = 0

        let taskC = Task(context: context)
        taskC.id = UUID()
        taskC.text = "Sort C"
        taskC.state = TaskState.notStarted.rawValue
        taskC.createdAt = baseDate.addingTimeInterval(5)
        taskC.updatedAt = taskC.createdAt
        taskC.completedAt = nil
        taskC.scheduledDate = nil
        taskC.sortOrder = 1

        try context.save()

        let inboxViewModel = TaskViewModel(context: context, filter: .inbox)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        let orderedIds = inboxViewModel.tasks.map { $0.id }
        XCTAssertEqual(orderedIds, [taskB.id, taskC.id, taskA.id])
    }

    func testInboxCreateTaskKeepsScheduledDateNil() throws {
        let inboxViewModel = TaskViewModel(context: context, filter: .inbox)
        inboxViewModel.createTask(text: "Inbox Task")
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        XCTAssertEqual(inboxViewModel.tasks.count, 1)
        XCTAssertNil(inboxViewModel.tasks.first?.scheduledDate)
    }

    func testMoveTasksReordersAndPersistsSortOrder() throws {
        let taskA = Task(context: context)
        taskA.id = UUID()
        taskA.text = "A"
        taskA.state = TaskState.notStarted.rawValue
        taskA.createdAt = Date()
        taskA.updatedAt = taskA.createdAt
        taskA.completedAt = nil
        taskA.scheduledDate = nil
        taskA.sortOrder = 0

        let taskB = Task(context: context)
        taskB.id = UUID()
        taskB.text = "B"
        taskB.state = TaskState.notStarted.rawValue
        taskB.createdAt = Date().addingTimeInterval(1)
        taskB.updatedAt = taskB.createdAt
        taskB.completedAt = nil
        taskB.scheduledDate = nil
        taskB.sortOrder = 1

        let taskC = Task(context: context)
        taskC.id = UUID()
        taskC.text = "C"
        taskC.state = TaskState.notStarted.rawValue
        taskC.createdAt = Date().addingTimeInterval(2)
        taskC.updatedAt = taskC.createdAt
        taskC.completedAt = nil
        taskC.scheduledDate = nil
        taskC.sortOrder = 2

        try context.save()

        let inboxViewModel = TaskViewModel(context: context, filter: .inbox)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        inboxViewModel.moveTasks(fromOffsets: IndexSet(integer: 2), toOffset: 0)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        let reorderedIds = inboxViewModel.tasks.map { $0.id }
        XCTAssertEqual(reorderedIds, [taskC.id, taskA.id, taskB.id])

        let exp = expectation(description: "wait for background sort order persist")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)

        let refreshed = TaskViewModel(context: context, filter: .inbox)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))
        XCTAssertEqual(refreshed.tasks.map { $0.id }, reorderedIds)
    }

    func testRestoreTaskRevertsScheduledDateAndSortOrder() throws {
        let calendar = Calendar.current
        let referenceDate = calendar.date(from: DateComponents(year: 2026, month: 2, day: 12, hour: 10))!
        let todayStart = DateHelpers.startOfDay(for: referenceDate)

        let inboxTaskA = Task(context: context)
        inboxTaskA.id = UUID()
        inboxTaskA.text = "Inbox A"
        inboxTaskA.state = TaskState.notStarted.rawValue
        inboxTaskA.createdAt = referenceDate
        inboxTaskA.updatedAt = referenceDate
        inboxTaskA.completedAt = nil
        inboxTaskA.scheduledDate = nil
        inboxTaskA.sortOrder = 0

        let inboxTaskB = Task(context: context)
        inboxTaskB.id = UUID()
        inboxTaskB.text = "Inbox B"
        inboxTaskB.state = TaskState.notStarted.rawValue
        inboxTaskB.createdAt = referenceDate.addingTimeInterval(1)
        inboxTaskB.updatedAt = inboxTaskB.createdAt
        inboxTaskB.completedAt = nil
        inboxTaskB.scheduledDate = nil
        inboxTaskB.sortOrder = 1

        let todayTask = Task(context: context)
        todayTask.id = UUID()
        todayTask.text = "Today Task"
        todayTask.state = TaskState.notStarted.rawValue
        todayTask.createdAt = referenceDate.addingTimeInterval(2)
        todayTask.updatedAt = todayTask.createdAt
        todayTask.completedAt = nil
        todayTask.scheduledDate = todayStart
        todayTask.sortOrder = 0

        try context.save()

        let inboxViewModel = TaskViewModel(context: context, filter: .inbox, referenceDate: referenceDate)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        inboxViewModel.restoreTask(taskID: todayTask.id!, toScheduledDate: nil, insertAt: 1)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        XCTAssertNil(todayTask.scheduledDate)
        XCTAssertEqual(todayTask.sortOrder, 1)

        let refreshedInbox = TaskViewModel(context: context, filter: .inbox, referenceDate: referenceDate)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))
        XCTAssertEqual(refreshedInbox.tasks.map { $0.id }, [inboxTaskA.id, todayTask.id, inboxTaskB.id])
    }

    func testReorderPerformanceWithHundredTasks() throws {
        for index in 0..<100 {
            let task = Task(context: context)
            task.id = UUID()
            task.text = "Task \(index)"
            task.state = TaskState.notStarted.rawValue
            task.createdAt = Date().addingTimeInterval(TimeInterval(index))
            task.updatedAt = task.createdAt
            task.completedAt = nil
            task.scheduledDate = nil
            task.sortOrder = Int32(index)
        }

        try context.save()

        let viewModel = TaskViewModel(context: context, filter: .inbox)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        measure {
            guard viewModel.tasks.count == 100 else {
                XCTFail("Expected 100 tasks for performance test")
                return
            }
            viewModel.moveTasks(fromOffsets: IndexSet(integer: 0), toOffset: viewModel.tasks.count, persist: false)
            RunLoop.main.run(until: Date().addingTimeInterval(0.01))
            viewModel.moveTasks(fromOffsets: IndexSet(integer: viewModel.tasks.count - 1), toOffset: 0, persist: false)
            RunLoop.main.run(until: Date().addingTimeInterval(0.01))
        }
    }

    func testMoveTaskToTodayUpdatesScheduledDateAndPersists() throws {
        let calendar = Calendar.current
        let referenceDate = calendar.date(from: DateComponents(year: 2026, month: 2, day: 12, hour: 10))!
        let todayStart = DateHelpers.startOfDay(for: referenceDate)

        let inboxTask = Task(context: context)
        inboxTask.id = UUID()
        inboxTask.text = "Inbox"
        inboxTask.state = TaskState.notStarted.rawValue
        inboxTask.createdAt = referenceDate
        inboxTask.updatedAt = referenceDate
        inboxTask.completedAt = nil
        inboxTask.scheduledDate = nil
        inboxTask.sortOrder = 0

        let todayTaskA = Task(context: context)
        todayTaskA.id = UUID()
        todayTaskA.text = "Today A"
        todayTaskA.state = TaskState.notStarted.rawValue
        todayTaskA.createdAt = referenceDate.addingTimeInterval(1)
        todayTaskA.updatedAt = todayTaskA.createdAt
        todayTaskA.completedAt = nil
        todayTaskA.scheduledDate = todayStart
        todayTaskA.sortOrder = 0

        let todayTaskB = Task(context: context)
        todayTaskB.id = UUID()
        todayTaskB.text = "Today B"
        todayTaskB.state = TaskState.notStarted.rawValue
        todayTaskB.createdAt = referenceDate.addingTimeInterval(2)
        todayTaskB.updatedAt = todayTaskB.createdAt
        todayTaskB.completedAt = nil
        todayTaskB.scheduledDate = todayStart
        todayTaskB.sortOrder = 1

        try context.save()

        let todayViewModel = TaskViewModel(context: context, filter: .today, referenceDate: referenceDate)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        todayViewModel.moveTaskToToday(taskID: inboxTask.id!, insertAt: 1)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        let expectedOrder = [todayTaskA.id, inboxTask.id, todayTaskB.id]
        XCTAssertEqual(todayViewModel.tasks.map { $0.id }, expectedOrder)
        XCTAssertEqual(todayViewModel.tasks.map { $0.sortOrder }, [0, 1, 2])
        XCTAssertEqual(inboxTask.scheduledDate, todayStart)

        let inboxViewModel = TaskViewModel(context: context, filter: .inbox, referenceDate: referenceDate)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))
        XCTAssertEqual(inboxViewModel.tasks.count, 0)

        let refreshedToday = TaskViewModel(context: context, filter: .today, referenceDate: referenceDate)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))
        XCTAssertEqual(refreshedToday.tasks.map { $0.id }, expectedOrder)
    }

    func testMoveTaskToTomorrowUpdatesScheduledDateAndGroups() throws {
        let calendar = Calendar.current
        let referenceDate = calendar.date(from: DateComponents(year: 2026, month: 2, day: 12, hour: 10))!
        let todayStart = DateHelpers.startOfDay(for: referenceDate)
        let tomorrowStart = DateHelpers.startOfTomorrow(for: referenceDate)

        let todayTask = Task(context: context)
        todayTask.id = UUID()
        todayTask.text = "Today"
        todayTask.state = TaskState.notStarted.rawValue
        todayTask.createdAt = referenceDate
        todayTask.updatedAt = referenceDate
        todayTask.completedAt = nil
        todayTask.scheduledDate = todayStart
        todayTask.sortOrder = 0

        let tomorrowTask = Task(context: context)
        tomorrowTask.id = UUID()
        tomorrowTask.text = "Tomorrow"
        tomorrowTask.state = TaskState.notStarted.rawValue
        tomorrowTask.createdAt = referenceDate.addingTimeInterval(1)
        tomorrowTask.updatedAt = tomorrowTask.createdAt
        tomorrowTask.completedAt = nil
        tomorrowTask.scheduledDate = tomorrowStart
        tomorrowTask.sortOrder = 0

        try context.save()

        let upcomingViewModel = TaskViewModel(context: context, filter: .upcoming, referenceDate: referenceDate)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        upcomingViewModel.moveTaskToTomorrow(taskID: todayTask.id!, insertAt: 0)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        XCTAssertEqual(todayTask.scheduledDate, tomorrowStart)

        let sections = upcomingViewModel.groupedTasksByScheduledDate()
        XCTAssertEqual(sections.first?.title, "Tomorrow")
        let tomorrowIds = sections.first?.tasks.map { $0.id } ?? []
        XCTAssertEqual(tomorrowIds, [todayTask.id, tomorrowTask.id])

        let todayViewModel = TaskViewModel(context: context, filter: .today, referenceDate: referenceDate)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))
        XCTAssertEqual(todayViewModel.tasks.count, 0)
    }

    func testMoveTaskToInboxClearsScheduledDateAndPersists() throws {
        let calendar = Calendar.current
        let referenceDate = calendar.date(from: DateComponents(year: 2026, month: 2, day: 12, hour: 10))!
        let todayStart = DateHelpers.startOfDay(for: referenceDate)

        let inboxTask = Task(context: context)
        inboxTask.id = UUID()
        inboxTask.text = "Inbox Existing"
        inboxTask.state = TaskState.notStarted.rawValue
        inboxTask.createdAt = referenceDate
        inboxTask.updatedAt = referenceDate
        inboxTask.completedAt = nil
        inboxTask.scheduledDate = nil
        inboxTask.sortOrder = 1

        let todayTask = Task(context: context)
        todayTask.id = UUID()
        todayTask.text = "Today"
        todayTask.state = TaskState.notStarted.rawValue
        todayTask.createdAt = referenceDate.addingTimeInterval(1)
        todayTask.updatedAt = todayTask.createdAt
        todayTask.completedAt = nil
        todayTask.scheduledDate = todayStart
        todayTask.sortOrder = 0

        try context.save()

        let inboxViewModel = TaskViewModel(context: context, filter: .inbox, referenceDate: referenceDate)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        inboxViewModel.moveTaskToInbox(taskID: todayTask.id!, insertAt: 0)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        XCTAssertNil(todayTask.scheduledDate)
        XCTAssertEqual(inboxViewModel.tasks.map { $0.id }, [todayTask.id, inboxTask.id])
        XCTAssertEqual(inboxViewModel.tasks.map { $0.sortOrder }, [0, 1])

        let todayViewModel = TaskViewModel(context: context, filter: .today, referenceDate: referenceDate)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))
        XCTAssertEqual(todayViewModel.tasks.count, 0)

        let refreshedInbox = TaskViewModel(context: context, filter: .inbox, referenceDate: referenceDate)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))
        XCTAssertEqual(refreshedInbox.tasks.map { $0.id }, [todayTask.id, inboxTask.id])
    }

    func testSetScheduledDateMovesTaskToFutureGroup() throws {
        let calendar = Calendar.current
        let referenceDate = calendar.date(from: DateComponents(year: 2026, month: 2, day: 12, hour: 10))!
        let futureDate = calendar.date(from: DateComponents(year: 2026, month: 2, day: 20, hour: 9))!
        let futureStart = DateHelpers.startOfDay(for: futureDate)

        let inboxTask = Task(context: context)
        inboxTask.id = UUID()
        inboxTask.text = "Inbox"
        inboxTask.state = TaskState.notStarted.rawValue
        inboxTask.createdAt = referenceDate
        inboxTask.updatedAt = referenceDate
        inboxTask.completedAt = nil
        inboxTask.scheduledDate = nil
        inboxTask.sortOrder = 0

        try context.save()

        let inboxViewModel = TaskViewModel(context: context, filter: .inbox, referenceDate: referenceDate)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        inboxViewModel.setScheduledDate(taskID: inboxTask.id!, date: futureDate)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        XCTAssertEqual(inboxTask.scheduledDate, futureStart)

        let upcomingViewModel = TaskViewModel(context: context, filter: .upcoming, referenceDate: referenceDate)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))
        let sections = upcomingViewModel.groupedTasksByScheduledDate()
        XCTAssertEqual(sections.first?.date, futureStart)
        XCTAssertEqual(sections.first?.tasks.first?.id, inboxTask.id)
    }

    func testSetScheduledDateToTodayMovesTaskToToday() throws {
        let calendar = Calendar.current
        let referenceDate = calendar.date(from: DateComponents(year: 2026, month: 2, day: 12, hour: 10))!
        let todayStart = DateHelpers.startOfDay(for: referenceDate)

        let inboxTask = Task(context: context)
        inboxTask.id = UUID()
        inboxTask.text = "Inbox"
        inboxTask.state = TaskState.notStarted.rawValue
        inboxTask.createdAt = referenceDate
        inboxTask.updatedAt = referenceDate
        inboxTask.completedAt = nil
        inboxTask.scheduledDate = nil
        inboxTask.sortOrder = 0

        try context.save()

        let inboxViewModel = TaskViewModel(context: context, filter: .inbox, referenceDate: referenceDate)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        inboxViewModel.setScheduledDate(taskID: inboxTask.id!, date: referenceDate)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        XCTAssertEqual(inboxTask.scheduledDate, todayStart)

        let todayViewModel = TaskViewModel(context: context, filter: .today, referenceDate: referenceDate)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))
        XCTAssertEqual(todayViewModel.tasks.first?.id, inboxTask.id)
    }

    func testSetScheduledDateToTomorrowMovesTaskToUpcoming() throws {
        let calendar = Calendar.current
        let referenceDate = calendar.date(from: DateComponents(year: 2026, month: 2, day: 12, hour: 10))!
        let tomorrowStart = DateHelpers.startOfTomorrow(for: referenceDate)

        let inboxTask = Task(context: context)
        inboxTask.id = UUID()
        inboxTask.text = "Inbox"
        inboxTask.state = TaskState.notStarted.rawValue
        inboxTask.createdAt = referenceDate
        inboxTask.updatedAt = referenceDate
        inboxTask.completedAt = nil
        inboxTask.scheduledDate = nil
        inboxTask.sortOrder = 0

        try context.save()

        let inboxViewModel = TaskViewModel(context: context, filter: .inbox, referenceDate: referenceDate)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        inboxViewModel.setScheduledDate(taskID: inboxTask.id!, date: tomorrowStart)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        XCTAssertEqual(inboxTask.scheduledDate, tomorrowStart)

        let upcomingViewModel = TaskViewModel(context: context, filter: .upcoming, referenceDate: referenceDate)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))
        let sections = upcomingViewModel.groupedTasksByScheduledDate()
        XCTAssertEqual(sections.first?.title, "Tomorrow")
        XCTAssertEqual(sections.first?.tasks.first?.id, inboxTask.id)
    }

    func testUpcomingFilterIncludesTomorrowAndBeyond() throws {
        let calendar = Calendar.current
        let referenceDate = calendar.date(from: DateComponents(year: 2026, month: 2, day: 12, hour: 10))!
        let todayStart = DateHelpers.startOfDay(for: referenceDate)
        let tomorrowStart = DateHelpers.startOfTomorrow(for: referenceDate)
        let futureStart = calendar.date(byAdding: .day, value: 2, to: tomorrowStart)!

        let todayTask = Task(context: context)
        todayTask.id = UUID()
        todayTask.text = "Today"
        todayTask.state = TaskState.notStarted.rawValue
        todayTask.createdAt = referenceDate
        todayTask.updatedAt = referenceDate
        todayTask.completedAt = nil
        todayTask.scheduledDate = todayStart
        todayTask.sortOrder = 0

        let tomorrowTask = Task(context: context)
        tomorrowTask.id = UUID()
        tomorrowTask.text = "Tomorrow"
        tomorrowTask.state = TaskState.notStarted.rawValue
        tomorrowTask.createdAt = referenceDate.addingTimeInterval(1)
        tomorrowTask.updatedAt = tomorrowTask.createdAt
        tomorrowTask.completedAt = nil
        tomorrowTask.scheduledDate = tomorrowStart
        tomorrowTask.sortOrder = 1

        let futureTask = Task(context: context)
        futureTask.id = UUID()
        futureTask.text = "Future"
        futureTask.state = TaskState.notStarted.rawValue
        futureTask.createdAt = referenceDate.addingTimeInterval(2)
        futureTask.updatedAt = futureTask.createdAt
        futureTask.completedAt = nil
        futureTask.scheduledDate = futureStart
        futureTask.sortOrder = 2

        try context.save()

        let upcomingViewModel = TaskViewModel(context: context, filter: .upcoming, referenceDate: referenceDate)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        XCTAssertEqual(upcomingViewModel.tasks.count, 2)
        XCTAssertTrue(upcomingViewModel.tasks.allSatisfy { ($0.scheduledDate ?? .distantPast) >= tomorrowStart })
    }

    func testUpcomingGroupingBuildsSectionsByDate() throws {
        let calendar = Calendar.current
        let referenceDate = calendar.date(from: DateComponents(year: 2026, month: 2, day: 12, hour: 10))!
        let tomorrowStart = DateHelpers.startOfTomorrow(for: referenceDate)
        let futureStart = calendar.date(byAdding: .day, value: 2, to: tomorrowStart)!

        let taskB = Task(context: context)
        taskB.id = UUID()
        taskB.text = "Tomorrow B"
        taskB.state = TaskState.notStarted.rawValue
        taskB.createdAt = referenceDate
        taskB.updatedAt = referenceDate
        taskB.completedAt = nil
        taskB.scheduledDate = calendar.date(byAdding: .hour, value: 9, to: tomorrowStart)
        taskB.sortOrder = 1

        let taskA = Task(context: context)
        taskA.id = UUID()
        taskA.text = "Tomorrow A"
        taskA.state = TaskState.notStarted.rawValue
        taskA.createdAt = referenceDate.addingTimeInterval(1)
        taskA.updatedAt = taskA.createdAt
        taskA.completedAt = nil
        taskA.scheduledDate = calendar.date(byAdding: .hour, value: 1, to: tomorrowStart)
        taskA.sortOrder = 0

        let futureTask = Task(context: context)
        futureTask.id = UUID()
        futureTask.text = "Future"
        futureTask.state = TaskState.notStarted.rawValue
        futureTask.createdAt = referenceDate.addingTimeInterval(2)
        futureTask.updatedAt = futureTask.createdAt
        futureTask.completedAt = nil
        futureTask.scheduledDate = calendar.date(byAdding: .hour, value: 3, to: futureStart)
        futureTask.sortOrder = 0

        try context.save()

        let upcomingViewModel = TaskViewModel(context: context, filter: .upcoming, referenceDate: referenceDate)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        let sections = upcomingViewModel.groupedTasksByScheduledDate()
        XCTAssertEqual(sections.count, 2)
        XCTAssertEqual(sections[0].title, "Tomorrow")

        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        XCTAssertEqual(sections[1].title, formatter.string(from: futureStart))

        let tomorrowIds = sections[0].tasks.map { $0.id }
        XCTAssertEqual(tomorrowIds, [taskA.id, taskB.id])
    }

    func testUpcomingCreateTaskDefaultsToTomorrow() throws {
        let calendar = Calendar.current
        let referenceDate = calendar.date(from: DateComponents(year: 2026, month: 2, day: 12, hour: 10))!
        let tomorrowStart = DateHelpers.startOfTomorrow(for: referenceDate)

        let upcomingViewModel = TaskViewModel(context: context, filter: .upcoming, referenceDate: referenceDate)
        upcomingViewModel.createTask(text: "Upcoming Task")
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        XCTAssertEqual(upcomingViewModel.tasks.count, 1)
        XCTAssertEqual(upcomingViewModel.tasks.first?.scheduledDate, tomorrowStart)
    }

    func testTodayFilterIncludesOnlyTodayTasks() throws {
        let calendar = Calendar.current
        let referenceDate = calendar.date(from: DateComponents(year: 2026, month: 2, day: 12, hour: 10))!
        let todayStart = DateHelpers.startOfDay(for: referenceDate)
        let tomorrowStart = DateHelpers.startOfTomorrow(for: referenceDate)
        let yesterdayStart = calendar.date(byAdding: .day, value: -1, to: todayStart)!

        let yesterdayTask = Task(context: context)
        yesterdayTask.id = UUID()
        yesterdayTask.text = "Yesterday"
        yesterdayTask.state = TaskState.notStarted.rawValue
        yesterdayTask.createdAt = referenceDate
        yesterdayTask.updatedAt = referenceDate
        yesterdayTask.completedAt = nil
        yesterdayTask.scheduledDate = yesterdayStart
        yesterdayTask.sortOrder = 0

        let todayTask = Task(context: context)
        todayTask.id = UUID()
        todayTask.text = "Today"
        todayTask.state = TaskState.notStarted.rawValue
        todayTask.createdAt = referenceDate.addingTimeInterval(1)
        todayTask.updatedAt = todayTask.createdAt
        todayTask.completedAt = nil
        todayTask.scheduledDate = todayStart
        todayTask.sortOrder = 1

        let tomorrowTask = Task(context: context)
        tomorrowTask.id = UUID()
        tomorrowTask.text = "Tomorrow"
        tomorrowTask.state = TaskState.notStarted.rawValue
        tomorrowTask.createdAt = referenceDate.addingTimeInterval(2)
        tomorrowTask.updatedAt = tomorrowTask.createdAt
        tomorrowTask.completedAt = nil
        tomorrowTask.scheduledDate = tomorrowStart
        tomorrowTask.sortOrder = 2

        let inboxTask = Task(context: context)
        inboxTask.id = UUID()
        inboxTask.text = "Inbox"
        inboxTask.state = TaskState.notStarted.rawValue
        inboxTask.createdAt = referenceDate.addingTimeInterval(3)
        inboxTask.updatedAt = inboxTask.createdAt
        inboxTask.completedAt = nil
        inboxTask.scheduledDate = nil
        inboxTask.sortOrder = 3

        try context.save()

        let todayViewModel = TaskViewModel(context: context, filter: .today, referenceDate: referenceDate)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        XCTAssertEqual(todayViewModel.tasks.count, 1)
        XCTAssertEqual(todayViewModel.tasks.first?.text, "Today")
    }

    func testTodayFilterRespectsTimezoneBoundaries() throws {
        let originalTimeZone = TimeZone.ReferenceType.default
        defer { TimeZone.ReferenceType.default = originalTimeZone }

        TimeZone.ReferenceType.default = TimeZone(secondsFromGMT: 9 * 3600)!
        let calendar = Calendar.current
        let referenceDate = calendar.date(from: DateComponents(year: 2026, month: 2, day: 12, hour: 1))!
        let todayStart = DateHelpers.startOfDay(for: referenceDate)
        let tomorrowStart = DateHelpers.startOfTomorrow(for: referenceDate)

        let boundaryTask = Task(context: context)
        boundaryTask.id = UUID()
        boundaryTask.text = "Boundary"
        boundaryTask.state = TaskState.notStarted.rawValue
        boundaryTask.createdAt = referenceDate
        boundaryTask.updatedAt = referenceDate
        boundaryTask.completedAt = nil
        boundaryTask.scheduledDate = todayStart
        boundaryTask.sortOrder = 0

        let tomorrowTask = Task(context: context)
        tomorrowTask.id = UUID()
        tomorrowTask.text = "Tomorrow"
        tomorrowTask.state = TaskState.notStarted.rawValue
        tomorrowTask.createdAt = referenceDate.addingTimeInterval(1)
        tomorrowTask.updatedAt = tomorrowTask.createdAt
        tomorrowTask.completedAt = nil
        tomorrowTask.scheduledDate = tomorrowStart
        tomorrowTask.sortOrder = 1

        try context.save()

        let todayViewModel = TaskViewModel(context: context, filter: .today, referenceDate: referenceDate)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        XCTAssertEqual(todayViewModel.tasks.count, 1)
        XCTAssertEqual(todayViewModel.tasks.first?.text, "Boundary")
    }

    func testTodayCreateTaskDefaultsToTodayStart() throws {
        let calendar = Calendar.current
        let referenceDate = calendar.date(from: DateComponents(year: 2026, month: 2, day: 12, hour: 10))!
        let todayStart = DateHelpers.startOfDay(for: referenceDate)

        let todayViewModel = TaskViewModel(context: context, filter: .today, referenceDate: referenceDate)
        todayViewModel.createTask(text: "Today Task")
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        XCTAssertEqual(todayViewModel.tasks.count, 1)
        XCTAssertEqual(todayViewModel.tasks.first?.scheduledDate, todayStart)
    }

    func testDayChangeRefreshUpdatesTodayFilter() throws {
        let calendar = Calendar.current
        let dayOne = calendar.date(from: DateComponents(year: 2026, month: 2, day: 12, hour: 10))!
        let dayTwo = calendar.date(byAdding: .day, value: 1, to: dayOne)!
        let dayOneStart = DateHelpers.startOfDay(for: dayOne)
        let dayTwoStart = DateHelpers.startOfDay(for: dayTwo)

        let dayOneTask = Task(context: context)
        dayOneTask.id = UUID()
        dayOneTask.text = "Day One"
        dayOneTask.state = TaskState.notStarted.rawValue
        dayOneTask.createdAt = dayOne
        dayOneTask.updatedAt = dayOne
        dayOneTask.completedAt = nil
        dayOneTask.scheduledDate = dayOneStart
        dayOneTask.sortOrder = 0

        let dayTwoTask = Task(context: context)
        dayTwoTask.id = UUID()
        dayTwoTask.text = "Day Two"
        dayTwoTask.state = TaskState.notStarted.rawValue
        dayTwoTask.createdAt = dayOne.addingTimeInterval(1)
        dayTwoTask.updatedAt = dayTwoTask.createdAt
        dayTwoTask.completedAt = nil
        dayTwoTask.scheduledDate = dayTwoStart
        dayTwoTask.sortOrder = 1

        try context.save()

        let todayViewModel = TaskViewModel(context: context, filter: .today, referenceDate: dayOne)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))
        XCTAssertEqual(todayViewModel.tasks.first?.text, "Day One")

        todayViewModel.refreshForNewDay(referenceDate: dayTwo)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))
        XCTAssertEqual(todayViewModel.tasks.first?.text, "Day Two")
    }

    func testRefreshForNewDayDoesNotChangeScheduledDate() throws {
        let calendar = Calendar.current
        let dayOne = calendar.date(from: DateComponents(year: 2026, month: 2, day: 12, hour: 10))!
        let dayTwo = calendar.date(byAdding: .day, value: 1, to: dayOne)!
        let dayOneStart = DateHelpers.startOfDay(for: dayOne)

        let task = Task(context: context)
        task.id = UUID()
        task.text = "Stay"
        task.state = TaskState.notStarted.rawValue
        task.createdAt = dayOne
        task.updatedAt = dayOne
        task.completedAt = nil
        task.scheduledDate = dayOneStart
        task.sortOrder = 0

        try context.save()

        let todayViewModel = TaskViewModel(context: context, filter: .today, referenceDate: dayOne)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        todayViewModel.refreshForNewDay(referenceDate: dayTwo)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        XCTAssertEqual(task.scheduledDate, dayOneStart)
        XCTAssertTrue(todayViewModel.tasks.isEmpty)
    }

    func testUpcomingRefreshForNewDayUpdatesDefaultScheduledDate() throws {
        let calendar = Calendar.current
        let dayOne = calendar.date(from: DateComponents(year: 2026, month: 2, day: 12, hour: 10))!
        let dayTwo = calendar.date(byAdding: .day, value: 1, to: dayOne)!
        let expected = DateHelpers.startOfTomorrow(for: dayTwo)

        let upcomingViewModel = TaskViewModel(context: context, filter: .upcoming, referenceDate: dayOne)
        upcomingViewModel.refreshForNewDay(referenceDate: dayTwo)
        upcomingViewModel.createTask(text: "Upcoming")
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        XCTAssertEqual(upcomingViewModel.tasks.first?.scheduledDate, expected)
    }

    func testUpcomingRefreshDropsTasksThatBecomeToday() throws {
        let calendar = Calendar.current
        let dayOne = calendar.date(from: DateComponents(year: 2026, month: 2, day: 12, hour: 10))!
        let dayTwo = calendar.date(byAdding: .day, value: 1, to: dayOne)!
        let dayTwoStart = DateHelpers.startOfDay(for: dayTwo)

        let task = Task(context: context)
        task.id = UUID()
        task.text = "Tomorrow Task"
        task.state = TaskState.notStarted.rawValue
        task.createdAt = dayOne
        task.updatedAt = dayOne
        task.completedAt = nil
        task.scheduledDate = dayTwoStart
        task.sortOrder = 0

        try context.save()

        let upcomingViewModel = TaskViewModel(context: context, filter: .upcoming, referenceDate: dayOne)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))
        XCTAssertEqual(upcomingViewModel.tasks.count, 1)

        upcomingViewModel.refreshForNewDay(referenceDate: dayTwo)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))
        XCTAssertEqual(upcomingViewModel.tasks.count, 0)

        let todayViewModel = TaskViewModel(context: context, filter: .today, referenceDate: dayTwo)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))
        XCTAssertEqual(todayViewModel.tasks.count, 1)
        XCTAssertEqual(todayViewModel.tasks.first?.id, task.id)
    }

    func testTodayRefreshForNewDayUpdatesDefaultScheduledDate() throws {
        let calendar = Calendar.current
        let dayOne = calendar.date(from: DateComponents(year: 2026, month: 2, day: 12, hour: 10))!
        let dayTwo = calendar.date(byAdding: .day, value: 1, to: dayOne)!
        let expected = DateHelpers.startOfDay(for: dayTwo)

        let todayViewModel = TaskViewModel(context: context, filter: .today, referenceDate: dayOne)
        todayViewModel.refreshForNewDay(referenceDate: dayTwo)
        todayViewModel.createTask(text: "Today")
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        XCTAssertEqual(todayViewModel.tasks.first?.scheduledDate, expected)
    }

    func testUpdateTaskStateToCompletedPersistsTimestamps() throws {
        let task = Task(context: context)
        task.id = UUID()
        task.text = "State Task"
        task.state = TaskState.notStarted.rawValue
        task.createdAt = Date()
        task.updatedAt = task.createdAt
        task.completedAt = nil
        task.scheduledDate = nil
        task.sortOrder = 0
        try context.save()

        let viewModel = TaskViewModel(context: context)
        let now = Date()
        viewModel.updateTaskState(taskID: task.id!, to: .completed, now: now)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        let fetch: NSFetchRequest<Task> = Task.fetchRequest()
        fetch.predicate = NSPredicate(format: "id == %@", task.id! as CVarArg)
        let fetched = try context.fetch(fetch).first
        XCTAssertEqual(fetched?.stateValue, .completed)
        XCTAssertEqual(fetched?.completedAt, now)
        XCTAssertEqual(fetched?.updatedAt, now)
    }

    func testUpdateTaskStateToNotStartedClearsCompletedAt() throws {
        let task = Task(context: context)
        task.id = UUID()
        task.text = "State Task 2"
        task.state = TaskState.completed.rawValue
        task.createdAt = Date()
        task.updatedAt = task.createdAt
        task.completedAt = Date()
        task.scheduledDate = nil
        task.sortOrder = 0
        try context.save()

        let viewModel = TaskViewModel(context: context)
        let now = Date()
        viewModel.updateTaskState(taskID: task.id!, to: .notStarted, now: now)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        let fetch: NSFetchRequest<Task> = Task.fetchRequest()
        fetch.predicate = NSPredicate(format: "id == %@", task.id! as CVarArg)
        let fetched = try context.fetch(fetch).first
        XCTAssertEqual(fetched?.stateValue, .notStarted)
        XCTAssertNil(fetched?.completedAt)
        XCTAssertEqual(fetched?.updatedAt, now)
    }

    func testCycleTaskStateAdvancesThroughAllStates() throws {
        let task = Task(context: context)
        task.id = UUID()
        task.text = "Cycle Task"
        task.state = TaskState.notStarted.rawValue
        task.createdAt = Date()
        task.updatedAt = task.createdAt
        task.completedAt = nil
        task.scheduledDate = nil
        task.sortOrder = 0
        try context.save()

        let viewModel = TaskViewModel(context: context)
        let now1 = Date()
        viewModel.cycleTaskState(taskID: task.id!, now: now1)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))
        var fetched = try context.fetch(Task.fetchRequest()).first
        XCTAssertEqual(fetched?.stateValue, .active)
        XCTAssertNil(fetched?.completedAt)
        XCTAssertEqual(fetched?.updatedAt, now1)

        let now2 = now1.addingTimeInterval(1)
        viewModel.cycleTaskState(taskID: task.id!, now: now2)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))
        fetched = try context.fetch(Task.fetchRequest()).first
        XCTAssertEqual(fetched?.stateValue, .completed)
        XCTAssertEqual(fetched?.completedAt, now2)
        XCTAssertEqual(fetched?.updatedAt, now2)

        let now3 = now2.addingTimeInterval(1)
        viewModel.cycleTaskState(taskID: task.id!, now: now3)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))
        fetched = try context.fetch(Task.fetchRequest()).first
        XCTAssertEqual(fetched?.stateValue, .notStarted)
        XCTAssertNil(fetched?.completedAt)
        XCTAssertEqual(fetched?.updatedAt, now3)
    }

    func testTodayFilterIncludesCompletedTasks() throws {
        let calendar = Calendar.current
        let reference = calendar.date(from: DateComponents(year: 2026, month: 2, day: 12, hour: 9))!
        let todayStart = DateHelpers.startOfDay(for: reference)

        let completedTask = Task(context: context)
        completedTask.id = UUID()
        completedTask.text = "Completed Today"
        completedTask.state = TaskState.completed.rawValue
        completedTask.createdAt = reference
        completedTask.updatedAt = reference
        completedTask.completedAt = reference
        completedTask.scheduledDate = todayStart
        completedTask.sortOrder = 0

        try context.save()

        let todayViewModel = TaskViewModel(context: context, filter: .today, referenceDate: reference)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        XCTAssertEqual(todayViewModel.tasks.count, 1)
        XCTAssertEqual(todayViewModel.tasks.first?.stateValue, .completed)
    }

    func testTodayRefreshDropsYesterdayTasksWithoutRollover() throws {
        let calendar = Calendar.current
        let dayOne = calendar.date(from: DateComponents(year: 2026, month: 2, day: 12, hour: 9))!
        let dayTwo = calendar.date(byAdding: .day, value: 1, to: dayOne)!
        let dayOneStart = DateHelpers.startOfDay(for: dayOne)

        let task = Task(context: context)
        task.id = UUID()
        task.text = "Yesterday Task"
        task.state = TaskState.completed.rawValue
        task.createdAt = dayOne
        task.updatedAt = dayOne
        task.completedAt = dayOne
        task.scheduledDate = dayOneStart
        task.sortOrder = 0

        try context.save()

        let todayViewModel = TaskViewModel(context: context, filter: .today, referenceDate: dayOne)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))
        XCTAssertEqual(todayViewModel.tasks.count, 1)

        todayViewModel.refreshForNewDay(referenceDate: dayTwo)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))
        XCTAssertEqual(todayViewModel.tasks.count, 0)
    }

    func testSortingUsesManualSortOrderAcrossStates() throws {
        let activeLow = Task(context: context)
        activeLow.id = UUID()
        activeLow.text = "Active Low"
        activeLow.state = TaskState.active.rawValue
        activeLow.createdAt = Date()
        activeLow.updatedAt = activeLow.createdAt
        activeLow.completedAt = nil
        activeLow.scheduledDate = nil
        activeLow.sortOrder = 0

        let activeHigh = Task(context: context)
        activeHigh.id = UUID()
        activeHigh.text = "Active High"
        activeHigh.state = TaskState.active.rawValue
        activeHigh.createdAt = Date().addingTimeInterval(1)
        activeHigh.updatedAt = activeHigh.createdAt
        activeHigh.completedAt = nil
        activeHigh.scheduledDate = nil
        activeHigh.sortOrder = 1

        let notStarted = Task(context: context)
        notStarted.id = UUID()
        notStarted.text = "Not Started"
        notStarted.state = TaskState.notStarted.rawValue
        notStarted.createdAt = Date().addingTimeInterval(2)
        notStarted.updatedAt = notStarted.createdAt
        notStarted.completedAt = nil
        notStarted.scheduledDate = nil
        notStarted.sortOrder = 0

        let completed = Task(context: context)
        completed.id = UUID()
        completed.text = "Completed"
        completed.state = TaskState.completed.rawValue
        completed.createdAt = Date().addingTimeInterval(3)
        completed.updatedAt = completed.createdAt
        completed.completedAt = completed.createdAt
        completed.scheduledDate = nil
        completed.sortOrder = 0

        try context.save()

        let viewModel = TaskViewModel(context: context, filter: .inbox)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        let ordered = viewModel.tasks.map { $0.id }
        XCTAssertEqual(ordered, [activeLow.id, notStarted.id, completed.id, activeHigh.id])
    }

    func testMoveTasksKeepsStateGrouping() throws {
        let active = Task(context: context)
        active.id = UUID()
        active.text = "Active"
        active.state = TaskState.active.rawValue
        active.createdAt = Date()
        active.updatedAt = active.createdAt
        active.completedAt = nil
        active.scheduledDate = nil
        active.sortOrder = 0

        let notStartedA = Task(context: context)
        notStartedA.id = UUID()
        notStartedA.text = "Not Started A"
        notStartedA.state = TaskState.notStarted.rawValue
        notStartedA.createdAt = Date().addingTimeInterval(1)
        notStartedA.updatedAt = notStartedA.createdAt
        notStartedA.completedAt = nil
        notStartedA.scheduledDate = nil
        notStartedA.sortOrder = 1

        let notStartedB = Task(context: context)
        notStartedB.id = UUID()
        notStartedB.text = "Not Started B"
        notStartedB.state = TaskState.notStarted.rawValue
        notStartedB.createdAt = Date().addingTimeInterval(2)
        notStartedB.updatedAt = notStartedB.createdAt
        notStartedB.completedAt = nil
        notStartedB.scheduledDate = nil
        notStartedB.sortOrder = 2

        let completed = Task(context: context)
        completed.id = UUID()
        completed.text = "Completed"
        completed.state = TaskState.completed.rawValue
        completed.createdAt = Date().addingTimeInterval(3)
        completed.updatedAt = completed.createdAt
        completed.completedAt = completed.createdAt
        completed.scheduledDate = nil
        completed.sortOrder = 3

        try context.save()

        let viewModel = TaskViewModel(context: context, filter: .inbox)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        viewModel.moveTasks(fromOffsets: IndexSet(integer: 1), toOffset: 3)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        let ordered = viewModel.tasks.map { $0.id }
        XCTAssertEqual(ordered, [active.id, notStartedB.id, notStartedA.id, completed.id])
    }

    func testCompletedCountReflectsTodayCompletedTasks() throws {
        let calendar = Calendar.current
        let reference = calendar.date(from: DateComponents(year: 2026, month: 2, day: 12, hour: 9))!
        let todayStart = DateHelpers.startOfDay(for: reference)

        let completedTask = Task(context: context)
        completedTask.id = UUID()
        completedTask.text = "Done"
        completedTask.state = TaskState.completed.rawValue
        completedTask.createdAt = reference
        completedTask.updatedAt = reference
        completedTask.completedAt = reference
        completedTask.scheduledDate = todayStart
        completedTask.sortOrder = 0

        let notStartedTask = Task(context: context)
        notStartedTask.id = UUID()
        notStartedTask.text = "Todo"
        notStartedTask.state = TaskState.notStarted.rawValue
        notStartedTask.createdAt = reference
        notStartedTask.updatedAt = reference
        notStartedTask.completedAt = nil
        notStartedTask.scheduledDate = todayStart
        notStartedTask.sortOrder = 1

        try context.save()

        let viewModel = TaskViewModel(context: context, filter: .today, referenceDate: reference)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))
        XCTAssertEqual(viewModel.completedCount, 1)

        viewModel.updateTaskState(taskID: completedTask.id!, to: .notStarted)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))
        XCTAssertEqual(viewModel.completedCount, 0)
    }

    func testStateChangePersistsInInboxFilter() throws {
        let task = Task(context: context)
        task.id = UUID()
        task.text = "Inbox Task"
        task.state = TaskState.notStarted.rawValue
        task.createdAt = Date()
        task.updatedAt = task.createdAt
        task.completedAt = nil
        task.scheduledDate = nil
        task.sortOrder = 0
        try context.save()

        let inboxViewModel = TaskViewModel(context: context, filter: .inbox)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        inboxViewModel.updateTaskState(taskID: task.id!, to: .completed)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        XCTAssertEqual(inboxViewModel.tasks.count, 1)
        XCTAssertEqual(inboxViewModel.tasks.first?.stateValue, .completed)
    }

    func testStateChangePersistsInUpcomingFilter() throws {
        let calendar = Calendar.current
        let reference = calendar.date(from: DateComponents(year: 2026, month: 2, day: 12, hour: 9))!
        let tomorrowStart = DateHelpers.startOfTomorrow(for: reference)

        let task = Task(context: context)
        task.id = UUID()
        task.text = "Upcoming Task"
        task.state = TaskState.notStarted.rawValue
        task.createdAt = reference
        task.updatedAt = reference
        task.completedAt = nil
        task.scheduledDate = tomorrowStart
        task.sortOrder = 0
        try context.save()

        let upcomingViewModel = TaskViewModel(context: context, filter: .upcoming, referenceDate: reference)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        upcomingViewModel.updateTaskState(taskID: task.id!, to: .completed)
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        XCTAssertEqual(upcomingViewModel.tasks.count, 1)
        XCTAssertEqual(upcomingViewModel.tasks.first?.stateValue, .completed)
    }
}
