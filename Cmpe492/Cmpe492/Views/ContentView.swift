//
//  ContentView.swift
//  Cmpe492
//
//  Restored for Story 1.1 baseline project structure compliance.
//

import SwiftUI
import CoreData
import UniformTypeIdentifiers
import UIKit

enum MainTab: Hashable {
    case inbox
    case today
    case upcoming
    case analytics

    static let ordered: [MainTab] = [.inbox, .today, .upcoming, .analytics]

    var title: String {
        switch self {
        case .inbox:
            return "Inbox"
        case .today:
            return "Today"
        case .upcoming:
            return "Upcoming"
        case .analytics:
            return "Analytics"
        }
    }

    var systemImage: String {
        switch self {
        case .inbox:
            return "tray"
        case .today:
            return "sun.max"
        case .upcoming:
            return "calendar"
        case .analytics:
            return "chart.bar"
        }
    }
}

struct ContentView: View {
    static let defaultTab: MainTab = .today
    static let swipeAnimationDuration: TimeInterval = 0.3
    private static let tabBarDropHeight: CGFloat = 56
    fileprivate static let tabSwitchHoverDelay: TimeInterval = 0.5
    @State private var selection: MainTab
    @State private var focusTrigger = UUID()
    @StateObject private var dragCoordinator = DragCoordinator()
    @StateObject private var dayChangeObserver = DayChangeObserver()
    @StateObject private var undoCoordinator = UndoCoordinator()
    private let swipeThreshold: CGFloat = 60
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    init(initialTab: MainTab = ContentView.defaultTab) {
        _selection = State(initialValue: initialTab)
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .bottom) {
                TabView(selection: $selection) {
                    InboxView(focusTrigger: focusTrigger)
                        .tabItem {
                            Label(MainTab.inbox.title, systemImage: MainTab.inbox.systemImage)
                        }
                        .tag(MainTab.inbox)

                    TodayView(focusTrigger: focusTrigger)
                        .tabItem {
                            Label(MainTab.today.title, systemImage: MainTab.today.systemImage)
                        }
                        .tag(MainTab.today)

                    UpcomingView(focusTrigger: focusTrigger)
                        .tabItem {
                            Label(MainTab.upcoming.title, systemImage: MainTab.upcoming.systemImage)
                        }
                        .tag(MainTab.upcoming)

                    AnalyticsView()
                        .tabItem {
                            Label(MainTab.analytics.title, systemImage: MainTab.analytics.systemImage)
                        }
                        .tag(MainTab.analytics)
                }
                .environmentObject(dragCoordinator)
                .environmentObject(dayChangeObserver)
                .environmentObject(undoCoordinator)
                .contentShape(Rectangle())
                .onChange(of: selection) { _ in
                    focusTrigger = UUID()
                }
                .onReceive(NotificationCenter.default.publisher(for: .NSCalendarDayChanged)) { _ in
                    dayChangeObserver.bump()
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.significantTimeChangeNotification)) { _ in
                    dayChangeObserver.bump()
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                    dayChangeObserver.bump()
                }
                .onReceive(NotificationCenter.default.publisher(for: .NSSystemTimeZoneDidChange)) { _ in
                    dayChangeObserver.bump()
                }

                EdgeSwipeOverlay(
                    width: 24,
                    alignment: .leading,
                    onSwipe: { value in
                        handleSwipe(value)
                    }
                )

                EdgeSwipeOverlay(
                    width: 24,
                    alignment: .trailing,
                    onSwipe: { value in
                        handleSwipe(value)
                    }
                )

                TabBarDropOverlay(
                    width: proxy.size.width,
                    height: Self.tabBarDropHeight,
                    dragCoordinator: dragCoordinator,
                    reduceMotion: reduceMotion,
                    tabOrder: MainTab.ordered,
                    onSwitchTab: { tab in
                        guard selection != tab else { return }
                        if reduceMotion {
                            selection = tab
                        } else {
                            withAnimation(.easeInOut(duration: Self.swipeAnimationDuration)) {
                                selection = tab
                            }
                        }
                    }
                )
                .frame(height: Self.tabBarDropHeight)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 12)
                .padding(.bottom, 6)
                .opacity(dragCoordinator.hasTabTargets ? 1 : 0)
                .allowsHitTesting(dragCoordinator.hasTabTargets)
                .accessibilityHidden(true)

                if let toast = undoCoordinator.toast {
                    UndoToast(message: toast.message) {
                        undoCoordinator.undo()
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, Self.tabBarDropHeight + 12)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .animation(reduceMotion ? nil : .easeInOut(duration: 0.2), value: undoCoordinator.toast != nil)
        }
    }

    private func handleSwipe(_ value: DragGesture.Value) {
        guard !dragCoordinator.isDragging else { return }
        let horizontal = value.translation.width
        let vertical = value.translation.height
        guard abs(horizontal) > abs(vertical), abs(horizontal) > swipeThreshold else { return }

        let order = MainTab.ordered
        guard let currentIndex = order.firstIndex(of: selection) else { return }

        if horizontal > 0 {
            let nextIndex = min(currentIndex + 1, order.count - 1)
            guard nextIndex != currentIndex else { return }
            let nextTab = order[nextIndex]
            if reduceMotion {
                selection = nextTab
            } else {
                withAnimation(.easeOut(duration: Self.swipeAnimationDuration)) { selection = nextTab }
            }
        } else {
            let previousIndex = max(currentIndex - 1, 0)
            guard previousIndex != currentIndex else { return }
            let previousTab = order[previousIndex]
            if reduceMotion {
                selection = previousTab
            } else {
                withAnimation(.easeOut(duration: Self.swipeAnimationDuration)) { selection = previousTab }
            }
        }
    }
}

private struct EdgeSwipeOverlay: View {
    let width: CGFloat
    let alignment: Alignment
    let onSwipe: (DragGesture.Value) -> Void

    var body: some View {
        Color.clear
            .contentShape(Rectangle())
            .frame(width: width)
            .frame(maxHeight: .infinity)
            .frame(maxWidth: .infinity, alignment: alignment)
            .gesture(
                DragGesture(minimumDistance: 20, coordinateSpace: .local)
                    .onEnded { value in
                        onSwipe(value)
                    }
            )
    }
}

private struct TabBarDropOverlay: View {
    let width: CGFloat
    let height: CGFloat
    @ObservedObject var dragCoordinator: DragCoordinator
    let reduceMotion: Bool
    let tabOrder: [MainTab]
    let onSwitchTab: (MainTab) -> Void

    private var highlightActive: Bool {
        highlightTab != nil
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.blue.opacity(highlightActive ? 0.2 : 0))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blue.opacity(highlightActive ? 0.4 : 0), lineWidth: 1)
                )
                .frame(width: max(0, width / CGFloat(max(tabOrder.count, 1)) - 12), height: max(0, height - 8))
                .offset(x: highlightOffset)
                .animation(reduceMotion ? nil : .easeInOut(duration: 0.2), value: highlightActive)

            if highlightActive {
                Text("Drop to \(highlightTab?.title ?? "")")
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.blue)
                    .transition(.opacity)
            }
        }
        .frame(width: width, height: height)
        .onDrop(of: [TaskDragPayload.type], delegate: TabBarDropDelegate(
            width: width,
            dragCoordinator: dragCoordinator,
            onSwitchTab: onSwitchTab,
            hoverDelay: ContentView.tabSwitchHoverDelay,
            targetTabs: dragCoordinator.targetTabs,
            tabOrder: tabOrder
        ))
    }

    private var highlightTab: MainTab? {
        guard let hovered = dragCoordinator.hoveringTab else { return nil }
        return dragCoordinator.targetTabs.contains(hovered) ? hovered : nil
    }

    private var highlightOffset: CGFloat {
        guard let highlightTab else { return 0 }
        let tabCount = max(tabOrder.count, 1)
        let tabWidth = width / CGFloat(tabCount)
        let mid = CGFloat(tabCount - 1) / 2.0
        let index = tabOrder.firstIndex(of: highlightTab) ?? 0
        return (CGFloat(index) - mid) * tabWidth
    }
}

#Preview("Default (Today)") {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

#Preview("Inbox") {
    ContentView(initialTab: .inbox)
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

#Preview("Upcoming") {
    ContentView(initialTab: .upcoming)
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
