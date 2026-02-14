import SwiftUI

struct TaskRow: View {
    @ObservedObject var task: Task
    let kind: TaskListKind
    let dayStart: Date

    @EnvironmentObject private var store: TaskStore
    @State private var showScheduleSheet = false

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .firstTextBaseline, spacing: 12) {
                stateIndicator

                Text(task.safeText)
                    .font(.body)
                    .foregroundColor(task.state == .completed ? .secondary : .primary)
                    .strikethrough(task.state == .completed, color: .secondary)

                Spacer()
            }

            if kind == .upcoming, let scheduled = task.scheduledDate {
                Text(dateLabel(for: scheduled))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(task.state == .active ? Color.accentColor.opacity(0.08) : Color(UIColor.secondarySystemBackground))
        )
        .contentShape(Rectangle())
        .onTapGesture {
            store.cycleState(for: task, dayStart: dayStart)
        }
        .swipeActions(edge: .leading, allowsFullSwipe: false) {
            if kind != .today {
                Button {
                    store.move(task, to: .today, dayStart: dayStart)
                } label: {
                    Label("Today", systemImage: "sun.max")
                }
                .tint(.accentColor)
            }

            Button {
                store.reschedule(task, to: dayStart.addingDays(1), dayStart: dayStart, label: "Tomorrow")
            } label: {
                Label("Tomorrow", systemImage: "sunrise")
            }
            .tint(.blue)

            if kind != .inbox {
                Button {
                    store.move(task, to: .inbox, dayStart: dayStart)
                } label: {
                    Label("Inbox", systemImage: "tray")
                }
                .tint(.gray)
            }

            Button {
                showScheduleSheet = true
            } label: {
                Label("Schedule", systemImage: "calendar")
            }
            .tint(.purple)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                store.delete(task)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .sheet(isPresented: $showScheduleSheet) {
            ScheduleSheet(task: task, dayStart: dayStart, isPresented: $showScheduleSheet)
        }
    }

    private var stateIndicator: some View {
        ZStack {
            Circle()
                .strokeBorder(colorForState(), lineWidth: 2)
                .frame(width: 18, height: 18)

            if task.state == .completed {
                Image(systemName: "checkmark")
                    .font(.caption2.weight(.bold))
                    .foregroundColor(colorForState())
            } else if task.state == .active {
                Circle()
                    .fill(colorForState())
                    .frame(width: 8, height: 8)
            }
        }
        .accessibilityLabel(task.state.displayName)
    }

    private func colorForState() -> Color {
        switch task.state {
        case .notStarted:
            return .secondary
        case .active:
            return .accentColor
        case .completed:
            return .secondary
        }
    }

    private func dateLabel(for date: Date) -> String {
        Self.dateFormatter.string(from: date)
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}
