import SwiftUI

struct TaskListView: View {
    let kind: TaskListKind
    let tasks: [Task]
    let dayStart: Date

    @Binding var draggingTask: Task?
    let isReordering: Bool

    @EnvironmentObject private var store: TaskStore

    var body: some View {
        if tasks.isEmpty {
            EmptyStateView(message: kind.emptyMessage)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            List {
                ForEach(tasks) { task in
                    TaskRow(task: task, kind: kind, dayStart: dayStart)
                        .opacity(draggingTask == task ? 0.4 : 1)
                        .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .onDrag {
                            guard !isReordering else { return NSItemProvider() }
                            draggingTask = task
                            let identifier = task.id?.uuidString ?? UUID().uuidString
                            return NSItemProvider(object: identifier as NSString)
                        }
                }
                .onMove { indices, newOffset in
                    store.reorder(tasks: tasks, fromOffsets: indices, toOffset: newOffset)
                }
            }
            .listStyle(.plain)
            .background(Color.clear)
            .environment(\.editMode, .constant(isReordering ? .active : .inactive))
        }
    }
}
