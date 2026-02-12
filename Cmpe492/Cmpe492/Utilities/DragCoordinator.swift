//
//  DragCoordinator.swift
//  Cmpe492
//
//  Created for Story 3.2 - shared drag state across tabs
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class DragCoordinator: ObservableObject {
    @Published var draggingTaskID: UUID?
    @Published var draggingSource: MainTab?
    @Published var hoveringTab: MainTab?
    @Published var dropTargetID: UUID?
    private(set) var dragOriginTaskID: UUID?
    private(set) var dragOriginIndex: Int?
    private(set) var dragOriginScheduledDate: Date?
    private(set) var dragOriginSortOrder: Int32?

    private var pendingSwitchWorkItem: DispatchWorkItem?

    var isDragging: Bool { draggingTaskID != nil }

    var isDraggingFromInbox: Bool {
        draggingTaskID != nil && draggingSource == .inbox
    }

    var targetTabs: [MainTab] {
        guard draggingTaskID != nil else { return [] }
        switch draggingSource {
        case .inbox:
            return [.today]
        case .today:
            return [.inbox, .upcoming]
        case .upcoming:
            return [.inbox]
        case .none:
            return []
        }
    }

    var hasTabTargets: Bool {
        !targetTabs.isEmpty
    }

    func beginDrag(taskID: UUID?, source: MainTab, originIndex: Int, scheduledDate: Date?, sortOrder: Int32) {
        if draggingTaskID == nil {
            PerformanceMetrics.start("dragSession")
        }
        draggingTaskID = taskID
        dragOriginTaskID = taskID
        draggingSource = source
        dragOriginIndex = originIndex
        dragOriginScheduledDate = scheduledDate
        dragOriginSortOrder = sortOrder
        dropTargetID = nil
        hoveringTab = nil
    }

    func updateHover(tab: MainTab?) {
        if hoveringTab != tab {
            hoveringTab = tab
        }
    }

    func scheduleTabSwitch(to tab: MainTab, delay: TimeInterval, action: @escaping () -> Void) {
        guard hoveringTab == tab else { return }
        guard pendingSwitchWorkItem == nil else { return }
        let workItem = DispatchWorkItem { [weak self] in
            guard let self else { return }
            guard self.hoveringTab == tab else { return }
            action()
            self.pendingSwitchWorkItem = nil
        }
        pendingSwitchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: workItem)
    }

    func cancelPendingSwitch() {
        pendingSwitchWorkItem?.cancel()
        pendingSwitchWorkItem = nil
    }

    func endDrag() {
        cancelPendingSwitch()
        draggingTaskID = nil
        draggingSource = nil
        hoveringTab = nil
        dropTargetID = nil
        dragOriginTaskID = nil
        dragOriginIndex = nil
        dragOriginScheduledDate = nil
        dragOriginSortOrder = nil
        PerformanceMetrics.end("dragSession")
    }
}
