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
    var isDragging: Bool = false
    var onMoveToday: (() -> Void)?
    var onMoveTomorrow: (() -> Void)?
    var onDelete: (() -> Void)?
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        Text(task.wrappedText)
            .font(.body)
            .foregroundStyle(Color.primary)
            .lineLimit(nil)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(minHeight: 44, alignment: .leading)
            .opacity(isDragging ? 0.3 : 1.0)
            .animation(reduceMotion ? nil : .easeOut(duration: 0.4), value: isDragging)
            .contentShape(Rectangle())
            .onTapGesture {
                onTap()
            }
            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                if let onMoveToday {
                    Button {
                        onMoveToday()
                    } label: {
                        Label("Today", systemImage: "sun.max")
                    }
                    .tint(.blue)
                }

                if let onMoveTomorrow {
                    Button {
                        onMoveTomorrow()
                    } label: {
                        Label("Tomorrow", systemImage: "calendar")
                    }
                    .tint(.green)
                }

                if let onDelete {
                    Button(role: .destructive) {
                        onDelete()
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
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
