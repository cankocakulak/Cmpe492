import SwiftUI
import UniformTypeIdentifiers

struct SegmentedHeader: View {
    @Binding var selection: TaskListKind
    @Binding var draggingTask: Task?
    let dayStart: Date

    @EnvironmentObject private var store: TaskStore

    var body: some View {
        HStack(spacing: 8) {
            ForEach(TaskListKind.allCases) { kind in
                SegmentButton(
                    kind: kind,
                    isSelected: selection == kind,
                    dayStart: dayStart,
                    selection: $selection,
                    draggingTask: $draggingTask
                )
            }
        }
        .padding(.horizontal, 16)
    }
}

private struct SegmentButton: View {
    let kind: TaskListKind
    let isSelected: Bool
    let dayStart: Date

    @Binding var selection: TaskListKind
    @Binding var draggingTask: Task?

    @EnvironmentObject private var store: TaskStore
    @State private var isTargeted = false

    var body: some View {
        Button(action: {
            selection = kind
        }) {
            Text(kind.title)
                .font(.subheadline.weight(.semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(isSelected ? Color.primary.opacity(0.08) : Color.clear)
                )
        }
        .foregroundColor(isSelected ? .primary : .secondary)
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(isTargeted ? Color.accentColor : Color.clear, lineWidth: 2)
        )
        .onDrop(of: [UTType.text], isTargeted: $isTargeted) { _ in
            guard let task = draggingTask else { return false }
            store.move(task, to: kind, dayStart: dayStart)
            draggingTask = nil
            return true
        }
    }
}
