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
    var onMoveInbox: (() -> Void)?
    var hideMoveToday: Bool = false
    var hideMoveUpcoming: Bool = false
    var onReorderDragChanged: ((DragGesture.Value) -> Void)? = nil
    var onReorderDragEnded: (() -> Void)? = nil
    var onDelete: (() -> Void)?
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        let state = task.stateValue
        let textColor: Color = state == .active ? .blue : (state == .completed ? .secondary : .primary)
        let backgroundColor: Color = state == .active ? Color.blue.opacity(0.1) : .clear
        let baseOpacity: Double = state == .completed ? 0.5 : 1.0
        let dragOpacity: Double = 1.0

        taskText(
            text: task.wrappedText,
            state: state,
            textColor: textColor,
            backgroundColor: backgroundColor,
            baseOpacity: baseOpacity,
            dragOpacity: dragOpacity,
            trailingPadding: (onReorderDragChanged == nil && onReorderDragEnded == nil) ? 20 : 76
        )
            .contentShape(Rectangle())
            .onTapGesture {
                onTap()
            }
            .overlay(alignment: .trailing) {
                if onReorderDragChanged != nil || onReorderDragEnded != nil {
                    Image(systemName: "line.3.horizontal")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(Color.secondary)
                        .frame(width: 56, height: 52)
                        .contentShape(Rectangle())
                        .padding(.trailing, 4)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    onReorderDragChanged?(value)
                                }
                                .onEnded { _ in
                                    onReorderDragEnded?()
                                }
                        )
                        .accessibilityLabel("Reorder task")
                }
            }
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                if let onDelete {
                    Button(role: .destructive) {
                        onDelete()
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
            .swipeActions(edge: .leading, allowsFullSwipe: false) {
                if let onMoveToday, !hideMoveToday {
                    Button {
                        onMoveToday()
                    } label: {
                        Label("Today", systemImage: "sun.max")
                    }
                    .tint(.blue)
                }

                if let onMoveTomorrow, !hideMoveUpcoming {
                    Button {
                        onMoveTomorrow()
                    } label: {
                        Label("Upcoming", systemImage: "calendar")
                    }
                    .tint(.green)
                }

                if let onMoveInbox {
                    Button {
                        onMoveInbox()
                    } label: {
                        Label("Inbox", systemImage: "tray")
                    }
                    .tint(.gray)
                }
            }
    }

    @ViewBuilder
    private func taskText(
        text: String,
        state: TaskState,
        textColor: Color,
        backgroundColor: Color,
        baseOpacity: Double,
        dragOpacity: Double,
        trailingPadding: CGFloat
    ) -> some View {
        let baseText = Text(text)
            .font(.body)
            .fontWeight(state == .completed ? .regular : .semibold)
            .foregroundStyle(textColor)
            .lineLimit(nil)
            .padding(.leading, 20)
            .padding(.trailing, trailingPadding)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
            .opacity(baseOpacity * dragOpacity)
            .background(backgroundColor)
            .animation(reduceMotion ? nil : .easeOut(duration: 0.4), value: isDragging)
            .animation(reduceMotion ? nil : .easeInOut(duration: 0.2), value: state)

        if #available(iOS 16.0, *) {
            baseText.strikethrough(state == .completed, pattern: .solid, color: .secondary)
        } else {
            baseText.overlay(alignment: .center) {
                if state == .completed {
                    Rectangle()
                        .fill(Color.secondary)
                        .frame(height: 1)
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
