import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject private var store: TaskStore
    @StateObject private var dayObserver = DayBoundaryObserver()

    init(store: TaskStore) {
        _store = StateObject(wrappedValue: store)
    }

    var body: some View {
        TabView {
            MainTaskView()
                .tabItem {
                    Label("Tasks", systemImage: "checklist")
                }

            AnalyticsView()
                .tabItem {
                    Label("Analytics", systemImage: "chart.bar")
                }
        }
        .environmentObject(store)
        .environmentObject(dayObserver)
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    ContentView(store: TaskStore(context: context))
        .environment(\.managedObjectContext, context)
}
