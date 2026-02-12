//
//  ContentView.swift
//  Cmpe492
//
//  Restored for Story 1.1 baseline project structure compliance.
//

import SwiftUI
import CoreData

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
    @State private var selection: MainTab
    @State private var focusTrigger = UUID()
    private let swipeThreshold: CGFloat = 60

    init(initialTab: MainTab = ContentView.defaultTab) {
        _selection = State(initialValue: initialTab)
    }

    var body: some View {
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
        .contentShape(Rectangle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 20, coordinateSpace: .local)
                .onEnded { value in
                    handleSwipe(value)
                }
        )
        .onChange(of: selection) { _ in
            focusTrigger = UUID()
        }
    }

    private func handleSwipe(_ value: DragGesture.Value) {
        let horizontal = value.translation.width
        let vertical = value.translation.height
        guard abs(horizontal) > abs(vertical), abs(horizontal) > swipeThreshold else { return }

        if horizontal > 0 {
            // Swipe right: move forward (Inbox -> Today -> Upcoming)
            switch selection {
            case .inbox:
                withAnimation(.easeOut(duration: Self.swipeAnimationDuration)) { selection = .today }
            case .today:
                withAnimation(.easeOut(duration: Self.swipeAnimationDuration)) { selection = .upcoming }
            case .upcoming:
                break
            }
        } else {
            // Swipe left: move backward (Upcoming -> Today -> Inbox)
            switch selection {
            case .upcoming:
                withAnimation(.easeOut(duration: Self.swipeAnimationDuration)) { selection = .today }
            case .today:
                withAnimation(.easeOut(duration: Self.swipeAnimationDuration)) { selection = .inbox }
            case .inbox:
                break
            }
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
