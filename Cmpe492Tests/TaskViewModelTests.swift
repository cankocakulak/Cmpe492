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
}
