//
//  ContentView.swift
//  Cmpe492
//
//  Restored for Story 1.1 baseline project structure compliance.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        TodayView()
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
