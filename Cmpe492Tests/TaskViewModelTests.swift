//
//  TaskViewModelTests.swift
//  Cmpe492Tests
//
//  Created for Story 1.3 - TaskViewModel CRUD tests
//

import XCTest
import CoreData
@testable import Cmpe492

final class TaskViewModelTests: XCTestCase {
    private var controller: PersistenceController!
    private var context: NSManagedObjectContext!

    override func setUp() {
        super.setUp()
        controller = PersistenceController(inMemory: true)
        context = controller.container.viewContext
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
}
