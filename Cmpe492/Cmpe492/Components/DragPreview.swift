//
//  DragPreview.swift
//  Cmpe492
//
//  Created for Story 3.5 - drag preview styling
//

import SwiftUI
import CoreData
import UIKit

struct DragPreview: View {
    let task: Task

    var body: some View {
        let state = task.stateValue
        let textColor: Color = state == .active ? .blue : (state == .completed ? .secondary : .primary)
        let textOpacity: Double = state == .completed ? 0.5 : 1.0
        Text(task.wrappedText)
            .font(.body)
            .fontWeight(state == .completed ? .regular : .semibold)
            .foregroundStyle(textColor)
            .lineLimit(nil)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(width: max(UIScreen.main.bounds.width - 40, 280), alignment: .leading)
            .frame(minHeight: 44, alignment: .leading)
            .background(Color(.systemBackground))
            .opacity(textOpacity)
            .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 8)
    }
}

#Preview {
    let task = Task(context: PersistenceController.preview.container.viewContext)
    task.id = UUID()
    task.text = "Dragging preview"
    task.state = TaskState.notStarted.rawValue
    task.createdAt = Date()
    task.updatedAt = Date()
    task.sortOrder = 0
    return DragPreview(task: task)
        .previewLayout(.sizeThatFits)
}
