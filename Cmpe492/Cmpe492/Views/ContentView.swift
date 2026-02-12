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

    var title: String {
        switch self {
        case .inbox:
            return "Inbox"
        case .today:
            return "Today"
        case .upcoming:
            return "Upcoming"
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
                }
                .environmentObject(dragCoordinator)
                .environmentObject(dayChangeObserver)
                .environmentObject(undoCoordinator)
                .contentShape(Rectangle())
                .simultaneousGesture(
                    DragGesture(minimumDistance: 20, coordinateSpace: .local)
                        .onEnded { value in
                            handleSwipe(value, width: proxy.size.width)
                        }
                )
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

                TabBarDropOverlay(
                    width: proxy.size.width,
                    height: Self.tabBarDropHeight,
                    dragCoordinator: dragCoordinator,
                    reduceMotion: reduceMotion,
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

    private func handleSwipe(_ value: DragGesture.Value, width: CGFloat) {
        guard !dragCoordinator.isDragging else { return }
        let startX = value.startLocation.x
        let startY = value.startLocation.y
        let edgeZone: CGFloat = 24
        let headerZone: CGFloat = 120
        let isEdgeSwipe = startX <= edgeZone || startX >= width - edgeZone
        let isHeaderSwipe = startY <= headerZone
        guard isEdgeSwipe || isHeaderSwipe else { return }

        let horizontal = value.translation.width
        let vertical = value.translation.height
        guard abs(horizontal) > abs(vertical), abs(horizontal) > swipeThreshold else { return }

        if horizontal > 0 {
            // Swipe right: move forward (Inbox -> Today -> Upcoming)
            switch selection {
            case .inbox:
                if reduceMotion {
                    selection = .today
                } else {
                    withAnimation(.easeOut(duration: Self.swipeAnimationDuration)) { selection = .today }
                }
            case .today:
                if reduceMotion {
                    selection = .upcoming
                } else {
                    withAnimation(.easeOut(duration: Self.swipeAnimationDuration)) { selection = .upcoming }
                }
            case .upcoming:
                break
            }
        } else {
            // Swipe left: move backward (Upcoming -> Today -> Inbox)
            switch selection {
            case .upcoming:
                if reduceMotion {
                    selection = .today
                } else {
                    withAnimation(.easeOut(duration: Self.swipeAnimationDuration)) { selection = .today }
                }
            case .today:
                if reduceMotion {
                    selection = .inbox
                } else {
                    withAnimation(.easeOut(duration: Self.swipeAnimationDuration)) { selection = .inbox }
                }
            case .inbox:
                break
            }
        }
    }
}

private struct TabBarDropOverlay: View {
    let width: CGFloat
    let height: CGFloat
    @ObservedObject var dragCoordinator: DragCoordinator
    let reduceMotion: Bool
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
                .frame(width: max(0, width / 3 - 12), height: max(0, height - 8))
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
        .onDrop(of: [UTType.text], delegate: TabBarDropDelegate(
            width: width,
            dragCoordinator: dragCoordinator,
            onSwitchTab: onSwitchTab,
            hoverDelay: ContentView.tabSwitchHoverDelay,
            targetTabs: dragCoordinator.targetTabs
        ))
    }

    private var highlightTab: MainTab? {
        guard let hovered = dragCoordinator.hoveringTab else { return nil }
        return dragCoordinator.targetTabs.contains(hovered) ? hovered : nil
    }

    private var highlightOffset: CGFloat {
        guard let highlightTab else { return 0 }
        let tabWidth = width / 3
        switch highlightTab {
        case .inbox:
            return -tabWidth
        case .today:
            return 0
        case .upcoming:
            return tabWidth
        }
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
