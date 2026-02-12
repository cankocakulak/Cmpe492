//
//  TaskListDropDelegate.swift
//  Cmpe492
//
//  Created for Story 3.2 - list-level drop handling
//

import SwiftUI
import UniformTypeIdentifiers

struct TaskListDropDelegate: DropDelegate {
    let tasks: [Task]
    @Binding var draggingTaskID: UUID?
    @Binding var dropTargetID: UUID?
    let viewModel: TaskViewModel
    let shouldAnimate: Bool
    let onExternalDropAtEnd: (UUID) -> Void
    let onDropCompleted: () -> Void

    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }

    func performDrop(info: DropInfo) -> Bool {
        guard let draggingID = draggingTaskID else { return false }

        if let fromIndex = tasks.firstIndex(where: { $0.id == draggingID }) {
            let move = {
                viewModel.moveTasks(fromOffsets: IndexSet(integer: fromIndex), toOffset: tasks.count, persist: false)
            }
            if shouldAnimate {
                withAnimation(.spring(response: 0.2, dampingFraction: 0.85)) {
                    move()
                }
            } else {
                move()
            }
            viewModel.persistCurrentOrder()
        } else {
            onExternalDropAtEnd(draggingID)
        }

        dropTargetID = nil
        draggingTaskID = nil
        onDropCompleted()
        return true
    }
}
