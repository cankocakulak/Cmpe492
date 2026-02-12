//
//  TaskModelTests.swift
//  Cmpe492Tests
//
//  Created for Story 1.3 - Task model helpers tests
//

import XCTest
import CoreData
@testable import Cmpe492

final class TaskModelTests: XCTestCase {
    private var controller: PersistenceController!
    private var context: NSManagedObjectContext!

    override func setUp() {
        super.setUp()
        controller = PersistenceController(inMemory: true)
        context = controller.container.viewContext
    }

    func testWrappedTextFallback() throws {
        let task = Task(context: context)
        task.text = nil
        XCTAssertEqual(task.wrappedText, "")
    }

    func testDefaultsSetOnInsert() throws {
        let task = Task(context: context)
        XCTAssertNotNil(task.id)
        XCTAssertNotNil(task.createdAt)
        XCTAssertNotNil(task.updatedAt)
        XCTAssertEqual(task.stateValue, .notStarted)
        XCTAssertEqual(task.text, "New Task")
    }

    func testStateValueFallback() throws {
        let task = Task(context: context)
        task.state = "unknown"
        XCTAssertEqual(task.stateValue, .notStarted)
    }

    func testMarkActiveUpdatesStateAndTimestamps() throws {
        let task = Task(context: context)
        let now = Date()
        task.markActive(now: now)
        XCTAssertEqual(task.stateValue, .active)
        XCTAssertNil(task.completedAt)
        XCTAssertEqual(task.updatedAt, now)
    }

    func testMarkCompletedUpdatesStateAndCompletedAt() throws {
        let task = Task(context: context)
        let now = Date()
        task.markCompleted(now: now)
        XCTAssertEqual(task.stateValue, .completed)
        XCTAssertEqual(task.completedAt, now)
        XCTAssertEqual(task.updatedAt, now)
    }

    func testMarkNotStartedClearsCompletedAt() throws {
        let task = Task(context: context)
        task.completedAt = Date()
        let now = Date()
        task.markNotStarted(now: now)
        XCTAssertEqual(task.stateValue, .notStarted)
        XCTAssertNil(task.completedAt)
        XCTAssertEqual(task.updatedAt, now)
    }
}
