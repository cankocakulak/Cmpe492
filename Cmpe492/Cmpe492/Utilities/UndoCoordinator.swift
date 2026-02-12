//
//  UndoCoordinator.swift
//  Cmpe492
//
//  Created for Story 3.11 - undo tracking for drag/quick actions
//

import Foundation
import Combine

@MainActor
final class UndoCoordinator: ObservableObject {
    struct MoveSnapshot: Equatable {
        let taskID: UUID
        let fromView: MainTab
        let fromIndex: Int
        let fromScheduledDate: Date?
        let fromSortOrder: Int32
    }

    struct ToastState: Equatable {
        let message: String
    }

    @Published private(set) var toast: ToastState?
    private(set) var lastMove: MoveSnapshot?
    private var undoAction: (() -> Void)?
    private var dismissWorkItem: DispatchWorkItem?
    private let dismissDelay: TimeInterval

    init(dismissDelay: TimeInterval = 3.0) {
        self.dismissDelay = dismissDelay
    }

    func registerMove(_ move: MoveSnapshot, toView: MainTab, undoAction: @escaping () -> Void) {
        dismissWorkItem?.cancel()
        dismissWorkItem = nil
        lastMove = move
        self.undoAction = undoAction
        toast = ToastState(message: "Moved to \(toView.title)")
        scheduleDismiss()
    }

    func undo() {
        guard toast != nil else { return }
        dismissWorkItem?.cancel()
        dismissWorkItem = nil
        undoAction?()
        clear()
    }

    private func scheduleDismiss() {
        let workItem = DispatchWorkItem { [weak self] in
            self?.clear()
        }
        dismissWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + dismissDelay, execute: workItem)
    }

    private func clear() {
        toast = nil
        lastMove = nil
        undoAction = nil
    }
}
