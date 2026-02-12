//
//  UpcomingView.swift
//  Cmpe492
//
//  Created for Story 2.3 - Upcoming view for future tasks
//

import SwiftUI
import CoreData
import UniformTypeIdentifiers
import UIKit

struct UpcomingView: View {
    @StateObject private var viewModel: TaskViewModel
    @State private var inputText: String = ""
    private let focusTrigger: AnyHashable?
    @EnvironmentObject private var dragCoordinator: DragCoordinator
    @EnvironmentObject private var undoCoordinator: UndoCoordinator
    @EnvironmentObject private var dayChangeObserver: DayChangeObserver
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var showScheduleMenu: Bool = false
    @State private var showDatePicker: Bool = false
    @State private var scheduleTaskID: UUID?
    @State private var selectedDate: Date = Date()

    @MainActor
    init(viewModel: TaskViewModel? = nil, focusTrigger: AnyHashable? = nil) {
        self.focusTrigger = focusTrigger
        if let viewModel = viewModel {
            _viewModel = StateObject(wrappedValue: viewModel)
        } else {
            _viewModel = StateObject(wrappedValue: TaskViewModel(filter: .upcoming))
        }
    }

    var body: some View {
        let sections = viewModel.groupedTasksByScheduledDate()
        let tomorrowStart = viewModel.tomorrowStartDate
        let tomorrowTaskCount = sections.first(where: { DateHelpers.startOfDay(for: $0.date) == tomorrowStart })?.tasks.count ?? 0

        NavigationView {
            VStack(spacing: 0) {
                PersistentInputField(text: $inputText, focusTrigger: focusTrigger) {
                    let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !trimmed.isEmpty else { return }
                    viewModel.createTask(text: trimmed)
                    inputText = ""
                }

                List {
                    ForEach(sections) { section in
                        Section {
                            ForEach(Array(section.tasks.enumerated()), id: \.element.id) { index, task in
                                TaskRow(
                                    task: task,
                                    onTap: {
                                        guard let taskID = task.id else { return }
                                        viewModel.cycleTaskState(taskID: taskID)
                                        impact(.light)
                                    },
                                    isDragging: dragCoordinator.draggingTaskID == task.id,
                                    onMoveToday: { quickSchedule(task, date: Date(), fromIndex: index, targetView: .today) },
                                    onMoveTomorrow: { quickSchedule(task, date: viewModel.tomorrowStartDate, fromIndex: index, targetView: .upcoming) },
                                    onDelete: { performQuickAction { viewModel.deleteTask(task) } }
                                )
                                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                    .listRowSeparatorTint(Color(.separator))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(
                                                Color.blue.opacity(isDraggingFromToday ? 0.2 : 0),
                                                lineWidth: 1
                                            )
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                    )
                                    .overlay(alignment: .top) {
                                        if dragCoordinator.dropTargetID == task.id {
                                            Rectangle()
                                                .fill(Color.blue)
                                                .frame(height: 2)
                                                .padding(.horizontal, 16)
                                        }
                                    }
                                    .onLongPressGesture(minimumDuration: 1.0) {
                                        guard dragCoordinator.draggingTaskID == nil else { return }
                                        scheduleTaskID = task.id
                                        selectedDate = viewModel.tomorrowStartDate
                                        showScheduleMenu = true
                                    }
                                    .onDrag {
                                        dragCoordinator.beginDrag(
                                            taskID: task.id,
                                            source: .upcoming,
                                            originIndex: index,
                                            scheduledDate: task.scheduledDate,
                                            sortOrder: task.sortOrder
                                        )
                                        impact(.medium)
                                        return NSItemProvider(object: (task.id?.uuidString ?? "") as NSString)
                                    } preview: {
                                        DragPreview(task: task)
                                    }
                                    .onDrop(of: [UTType.text], delegate: TaskReorderDropDelegate(
                                        targetTask: task,
                                        tasks: viewModel.tasks,
                                        draggingTaskID: $dragCoordinator.draggingTaskID,
                                        dropTargetID: $dragCoordinator.dropTargetID,
                                        viewModel: viewModel,
                                        onDropCompleted: {
                                            registerUndoFromDrag(targetView: .upcoming)
                                            impact(.light)
                                            dragCoordinator.endDrag()
                                        },
                                        shouldAnimate: !reduceMotion,
                                        onExternalDrop: { draggingID, _ in
                                            guard isDraggingFromToday else { return }
                                            let isTomorrowSection = DateHelpers.startOfDay(for: section.date) == tomorrowStart
                                            let insertIndex: Int
                                            if isTomorrowSection {
                                                insertIndex = section.tasks.firstIndex(where: { $0.id == task.id }) ?? section.tasks.count
                                            } else {
                                                insertIndex = tomorrowTaskCount
                                            }
                                            handleExternalDrop(draggingID: draggingID, insertAt: insertIndex)
                                        }
                                    ))
                            }
                        } header: {
                            Text(section.title)
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                    }
                }
                .listStyle(.plain)
                .onDrop(of: [UTType.text], delegate: TaskListDropDelegate(
                    tasks: viewModel.tasks,
                    draggingTaskID: $dragCoordinator.draggingTaskID,
                    dropTargetID: $dragCoordinator.dropTargetID,
                    viewModel: viewModel,
                    shouldAnimate: !reduceMotion,
                    onExternalDropAtEnd: { draggingID in
                        guard isDraggingFromToday else { return }
                        handleExternalDrop(draggingID: draggingID, insertAt: tomorrowTaskCount)
                    },
                    onDropCompleted: {
                        registerUndoFromDrag(targetView: .upcoming)
                        impact(.light)
                        dragCoordinator.endDrag()
                    }
                ))
                .animation(reduceMotion ? nil : .easeInOut(duration: 0.2), value: viewModel.tasks)
                .overlay {
                    if viewModel.tasks.isEmpty {
                        emptyStateView(
                            message: L10n.emptyUpcoming
                        )
                    }
                }
            }
            .navigationTitle("Upcoming")
            .background(Color(.systemBackground))
            .onChange(of: viewModel.restoreInputText) { restored in
                guard let restored else { return }
                inputText = restored
                viewModel.clearRestoreInput()
            }
            .onChange(of: dayChangeObserver.refreshToken) { _ in
                viewModel.refreshForNewDay()
            }
            .confirmationDialog("Schedule Task", isPresented: $showScheduleMenu) {
                Button("Today") { scheduleTask(for: Date()) }
                Button("Tomorrow") { scheduleTask(for: viewModel.tomorrowStartDate) }
                Button("Choose Date...") {
                    selectedDate = viewModel.tomorrowStartDate
                    showDatePicker = true
                }
                Button("Inbox") { scheduleTask(for: nil) }
                Button("Cancel", role: .cancel) { }
            }
            .sheet(isPresented: $showDatePicker) {
                DatePickerSheet(
                    selectedDate: $selectedDate,
                    minimumDate: viewModel.tomorrowStartDate,
                    onDone: {
                        scheduleTask(for: selectedDate)
                        showDatePicker = false
                    },
                    onCancel: {
                        showDatePicker = false
                    }
                )
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }

    private func emptyStateView(message: String) -> some View {
        Text(message)
            .font(.caption)
            .foregroundStyle(Color.secondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .allowsHitTesting(false)
    }

    private func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }

    private func performQuickAction(_ action: @escaping () -> Void) {
        if reduceMotion {
            action()
        } else {
            withAnimation(.easeInOut(duration: 0.25)) {
                action()
            }
        }
        impact(.light)
    }

    private func scheduleTask(for date: Date?) {
        guard let taskID = scheduleTaskID,
              let task = viewModel.tasks.first(where: { $0.id == taskID }) else { return }
        let fromIndex = viewModel.groupedTasksByScheduledDate()
            .first(where: { DateHelpers.startOfDay(for: $0.date) == DateHelpers.startOfDay(for: task.scheduledDate ?? Date()) })?
            .tasks.firstIndex(where: { $0.id == taskID }) ?? 0
        let snapshot = UndoCoordinator.MoveSnapshot(
            taskID: taskID,
            fromView: .upcoming,
            fromIndex: fromIndex,
            fromScheduledDate: task.scheduledDate,
            fromSortOrder: task.sortOrder
        )
        let targetView = targetView(for: date)

        performQuickAction {
            viewModel.setScheduledDate(taskID: taskID, date: date)
        }
        undoCoordinator.registerMove(snapshot, toView: targetView) {
            viewModel.restoreTask(taskID: taskID, toScheduledDate: snapshot.fromScheduledDate, insertAt: snapshot.fromIndex)
        }

        scheduleTaskID = nil
    }

    private func quickSchedule(_ task: Task, date: Date?, fromIndex: Int, targetView: MainTab) {
        guard let taskID = task.id else { return }
        let snapshot = UndoCoordinator.MoveSnapshot(
            taskID: taskID,
            fromView: .upcoming,
            fromIndex: fromIndex,
            fromScheduledDate: task.scheduledDate,
            fromSortOrder: task.sortOrder
        )

        performQuickAction {
            viewModel.setScheduledDate(taskID: taskID, date: date)
        }
        undoCoordinator.registerMove(snapshot, toView: targetView) {
            viewModel.restoreTask(taskID: taskID, toScheduledDate: snapshot.fromScheduledDate, insertAt: snapshot.fromIndex)
        }
    }

    private func registerUndoFromDrag(targetView: MainTab) {
        guard let taskID = dragCoordinator.dragOriginTaskID,
              let fromView = dragCoordinator.draggingSource,
              let fromIndex = dragCoordinator.dragOriginIndex else { return }
        let snapshot = UndoCoordinator.MoveSnapshot(
            taskID: taskID,
            fromView: fromView,
            fromIndex: fromIndex,
            fromScheduledDate: dragCoordinator.dragOriginScheduledDate,
            fromSortOrder: dragCoordinator.dragOriginSortOrder ?? 0
        )
        undoCoordinator.registerMove(snapshot, toView: targetView) {
            viewModel.restoreTask(taskID: taskID, toScheduledDate: snapshot.fromScheduledDate, insertAt: snapshot.fromIndex)
        }
    }

    private func targetView(for date: Date?) -> MainTab {
        guard let date else { return .inbox }
        let start = DateHelpers.startOfDay(for: date)
        let todayStart = DateHelpers.startOfDay(for: Date())
        return start == todayStart ? .today : .upcoming
    }

    private var isDraggingFromToday: Bool {
        dragCoordinator.draggingSource == .today && dragCoordinator.draggingTaskID != nil
    }

    private func handleExternalDrop(draggingID: UUID, insertAt index: Int) {
        let performMove = {
            viewModel.moveTaskToTomorrow(taskID: draggingID, insertAt: index)
        }

        if reduceMotion {
            performMove()
        } else {
            withAnimation(.easeInOut(duration: 0.25)) {
                performMove()
            }
        }
    }
}

#Preview {
    UpcomingView(viewModel: TaskViewModel(context: PersistenceController.preview.container.viewContext, filter: .upcoming))
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(DragCoordinator())
        .environmentObject(DayChangeObserver())
        .environmentObject(UndoCoordinator())
}
