//
//  Task+Extensions.swift
//  Cmpe492
//
//  Created for Story 1.3 - Task model helpers and state transitions
//

import Foundation
import CoreData

enum TaskState: String, CaseIterable {
    case notStarted
    case active
    case completed
}

extension Task {
    nonisolated public override func awakeFromInsert() {
        super.awakeFromInsert()
        let now = Date()
        let zeroUUID = UUID(uuidString: "00000000-0000-0000-0000-000000000000")
        let placeholderDate = Date(timeIntervalSinceReferenceDate: 0)

        if id == nil || id == zeroUUID {
            id = UUID()
        }
        if createdAt == nil || createdAt == placeholderDate {
            createdAt = now
        }
        if updatedAt == nil || updatedAt == placeholderDate {
            updatedAt = now
        }
        if state == nil {
            state = TaskState.notStarted.rawValue
        }
        if text == nil || text == "" {
            text = "New Task"
        }
    }

    var wrappedText: String {
        text ?? ""
    }

    var stateValue: TaskState {
        TaskState(rawValue: state ?? "") ?? .notStarted
    }

    var isActive: Bool {
        stateValue == .active
    }

    var isCompleted: Bool {
        stateValue == .completed
    }

    func markActive(now: Date = Date()) {
        state = TaskState.active.rawValue
        completedAt = nil
        updatedAt = now
    }

    func markCompleted(now: Date = Date()) {
        state = TaskState.completed.rawValue
        completedAt = now
        updatedAt = now
    }

    func markNotStarted(now: Date = Date()) {
        state = TaskState.notStarted.rawValue
        completedAt = nil
        updatedAt = now
    }
}

