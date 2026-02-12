//
//  DragPreview.swift
//  Cmpe492
//
//  Created for Story 3.5 - drag preview styling
//

import SwiftUI
import CoreData

struct DragPreview: View {
    let task: Task

    var body: some View {
        Text(task.wrappedText)
            .font(.body)
            .foregroundStyle(Color.primary)
            .lineLimit(nil)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(minHeight: 44, alignment: .leading)
            .background(Color(.systemBackground))
            .opacity(0.7)
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
