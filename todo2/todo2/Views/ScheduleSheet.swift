import SwiftUI

struct ScheduleSheet: View {
    @ObservedObject var task: Task
    let dayStart: Date
    @Binding var isPresented: Bool

    @EnvironmentObject private var store: TaskStore
    @State private var selectedDate: Date

    init(task: Task, dayStart: Date, isPresented: Binding<Bool>) {
        self.task = task
        self.dayStart = dayStart
        self._isPresented = isPresented
        let initialDate = task.scheduledDate ?? dayStart
        _selectedDate = State(initialValue: initialDate)
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                DatePicker("Schedule", selection: $selectedDate, displayedComponents: [.date])
                    .datePickerStyle(.graphical)
                    .labelsHidden()

                Button("Schedule") {
                    store.reschedule(task, to: selectedDate, dayStart: dayStart, label: "Schedule")
                    isPresented = false
                }
                .buttonStyle(.borderedProminent)

                Spacer()
            }
            .padding()
            .navigationTitle("Schedule Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
        }
    }
}
