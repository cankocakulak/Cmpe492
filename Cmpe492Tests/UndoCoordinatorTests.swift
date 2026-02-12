//
//  UndoCoordinatorTests.swift
//  Cmpe492Tests
//
//  Created for Story 3.11 - undo toast behavior
//

import XCTest
@testable import Cmpe492

@MainActor
final class UndoCoordinatorTests: XCTestCase {
    func testUndoWithinWindowExecutesAction() {
        let coordinator = UndoCoordinator(dismissDelay: 0.2)
        let move = UndoCoordinator.MoveSnapshot(
            taskID: UUID(),
            fromView: .inbox,
            fromIndex: 0,
            fromScheduledDate: nil,
            fromSortOrder: 0
        )
        var didUndo = false

        coordinator.registerMove(move, toView: .today) {
            didUndo = true
        }

        coordinator.undo()

        XCTAssertTrue(didUndo)
        XCTAssertNil(coordinator.toast)
    }

    func testUndoExpiresAfterDelay() {
        let coordinator = UndoCoordinator(dismissDelay: 0.05)
        let move = UndoCoordinator.MoveSnapshot(
            taskID: UUID(),
            fromView: .today,
            fromIndex: 2,
            fromScheduledDate: Date(),
            fromSortOrder: 2
        )
        var didUndo = false

        coordinator.registerMove(move, toView: .upcoming) {
            didUndo = true
        }

        let exp = expectation(description: "wait for undo timeout")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)

        XCTAssertNil(coordinator.toast)

        coordinator.undo()
        XCTAssertFalse(didUndo)
    }
}
