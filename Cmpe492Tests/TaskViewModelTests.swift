//
//  TaskViewModelTests.swift
//  Cmpe492Tests
//
//  Created for Story 1.3 - TaskViewModel CRUD tests
//

import XCTest
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
            throw NSError(domain: NSCocoaErrorDomain, code: NSManagedObjectSaveError, userInfo: nil)
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
}
