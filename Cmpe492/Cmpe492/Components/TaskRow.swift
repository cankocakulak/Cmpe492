//
//  TaskRow.swift
//  Cmpe492
//
//  Created for Story 1.7 - task list row styling
//

import SwiftUI
import CoreData

struct TaskRow: View {
    let task: Task
    var onTap: () -> Void = {}

    var body: some View {
        Text(task.wrappedText)
            .font(.body)
            .foregroundStyle(Color.primary)
            .lineLimit(nil)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(minHeight: 44, alignment: .leading)
            .contentShape(Rectangle())
            .onTapGesture {
                onTap()
            }
    }
}

#Preview {
    let task = Task(context: PersistenceController.preview.container.viewContext)
    task.id = UUID()
    task.text = "Sample Task"
    task.state = TaskState.notStarted.rawValue
    task.createdAt = Date()
    task.updatedAt = Date()
    task.sortOrder = 0
    return TaskRow(task: task)
        .previewLayout(.sizeThatFits)
}
