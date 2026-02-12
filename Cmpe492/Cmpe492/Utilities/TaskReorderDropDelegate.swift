//
//  TaskReorderDropDelegate.swift
//  Cmpe492
//
//  Created for Story 3.1 - drag to reorder tasks
//

import SwiftUI
import UniformTypeIdentifiers

struct TaskReorderDropDelegate: DropDelegate {
    let targetTask: Task
    let tasks: [Task]
    @Binding var draggingTaskID: UUID?
    @Binding var dropTargetID: UUID?
    let viewModel: TaskViewModel
    let onDropCompleted: () -> Void
    let shouldAnimate: Bool
    let onExternalDrop: ((UUID, Int) -> Void)?

    func dropEntered(info: DropInfo) {
        if dropTargetID != targetTask.id {
            dropTargetID = targetTask.id
        }
        guard
            let draggingID = draggingTaskID,
            let fromIndex = tasks.firstIndex(where: { $0.id == draggingID }),
            let toIndex = tasks.firstIndex(where: { $0.id == targetTask.id }),
            fromIndex != toIndex
        else { return }

        let move = {
            viewModel.moveTasks(
                fromOffsets: IndexSet(integer: fromIndex),
                toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex,
                persist: false
            )
        }

        if shouldAnimate {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.85)) {
                move()
            }
        } else {
            move()
        }
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }

    func dropExited(info: DropInfo) {
        if dropTargetID == targetTask.id {
            dropTargetID = nil
        }
    }

    func performDrop(info: DropInfo) -> Bool {
        let isInternal = draggingTaskID.flatMap { id in tasks.firstIndex(where: { $0.id == id }) } != nil

        if let draggingID = draggingTaskID,
           tasks.firstIndex(where: { $0.id == draggingID }) == nil,
           let toIndex = tasks.firstIndex(where: { $0.id == targetTask.id }) {
            onExternalDrop?(draggingID, toIndex)
        } else if isInternal {
            viewModel.persistCurrentOrder()
        }

        dropTargetID = nil
        draggingTaskID = nil
        onDropCompleted()
        return true
    }
}
