import SwiftUI
import UniformTypeIdentifiers

struct TaskListView: View {
    let kind: TaskListKind
    let tasks: [Task]
    let dayStart: Date

    @Binding var draggingTask: Task?

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
                            draggingTask = task
                            let identifier = task.id?.uuidString ?? UUID().uuidString
                            return NSItemProvider(object: identifier as NSString)
                        }
                        .onDrop(of: [UTType.text], delegate: TaskDropDelegate(
                            target: task,
                            tasks: tasks,
                            draggingTask: $draggingTask,
                            store: store
                        ))
                }
            }
            .listStyle(.plain)
            .background(Color.clear)
        }
    }
}

private struct TaskDropDelegate: DropDelegate {
    let target: Task
    let tasks: [Task]
    @Binding var draggingTask: Task?
    let store: TaskStore

    func dropEntered(info: DropInfo) {
        guard let draggingTask else { return }
        guard draggingTask != target else { return }
        guard draggingTask.state == target.state else { return }
        guard let fromIndex = tasks.firstIndex(of: draggingTask),
              let toIndex = tasks.firstIndex(of: target) else { return }

        store.reorder(tasks: tasks, from: fromIndex, to: toIndex)
    }

    func performDrop(info: DropInfo) -> Bool {
        draggingTask = nil
        return true
    }
}
