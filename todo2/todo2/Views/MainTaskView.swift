import SwiftUI
import CoreData

struct MainTaskView: View {
    @EnvironmentObject private var store: TaskStore
    @EnvironmentObject private var dayObserver: DayBoundaryObserver

    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Task.createdAt, ascending: true)
        ],
        animation: .default
    )
    private var tasks: FetchedResults<Task>

    @State private var selectedKind: TaskListKind = .today
    @State private var inputText = ""
    @State private var draggingTask: Task?
    @FocusState private var inputFocused: Bool

    var body: some View {
        let dayStart = dayObserver.todayStart
        let allTasks = Array(tasks)
        let inboxTasks = TaskFilter.tasks(for: .inbox, from: allTasks, dayStart: dayStart)
        let todayTasks = TaskFilter.tasks(for: .today, from: allTasks, dayStart: dayStart)
        let upcomingTasks = TaskFilter.tasks(for: .upcoming, from: allTasks, dayStart: dayStart)

        VStack(spacing: 12) {
            SegmentedHeader(
                selection: $selectedKind,
                draggingTask: $draggingTask,
                dayStart: dayStart
            )
            .padding(.top, 12)

            TaskInputBar(
                text: $inputText,
                isFocused: _inputFocused,
                placeholder: "Add a task"
            ) {
                store.createTask(
                    text: inputText,
                    scheduledDate: selectedKind.defaultScheduledDate(dayStart: dayStart),
                    dayStart: dayStart
                )
                inputText = ""
                inputFocused = true
            }
            .padding(.horizontal, 16)

            if selectedKind == .today {
                TodaySummary(tasks: todayTasks)
                    .padding(.horizontal, 16)
            }

            TabView(selection: $selectedKind) {
                TaskListView(
                    kind: .inbox,
                    tasks: inboxTasks,
                    dayStart: dayStart,
                    draggingTask: $draggingTask
                )
                .tag(TaskListKind.inbox)

                TaskListView(
                    kind: .today,
                    tasks: todayTasks,
                    dayStart: dayStart,
                    draggingTask: $draggingTask
                )
                .tag(TaskListKind.today)

                TaskListView(
                    kind: .upcoming,
                    tasks: upcomingTasks,
                    dayStart: dayStart,
                    draggingTask: $draggingTask
                )
                .tag(TaskListKind.upcoming)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .overlay(alignment: .bottom) {
            UndoBanner()
                .padding(.horizontal, 16)
                .padding(.bottom, 10)
        }
        .alert("Error", isPresented: Binding(get: {
            store.errorMessage != nil
        }, set: { _ in
            store.clearError()
        })) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(store.errorMessage ?? "")
        }
        .onAppear {
            if inputText.isEmpty {
                inputFocused = true
            }
        }
    }
}

private struct TodaySummary: View {
    let tasks: [Task]

    var body: some View {
        let completedCount = tasks.filter { $0.state == .completed }.count
        let activeCount = tasks.filter { $0.state == .active }.count
        let pendingCount = tasks.filter { $0.state == .notStarted }.count

        HStack {
            Text("Completed: \(completedCount)")
            Spacer()
            Text("Active: \(activeCount)")
            Spacer()
            Text("Pending: \(pendingCount)")
        }
        .font(.caption)
        .foregroundColor(.secondary)
    }
}
