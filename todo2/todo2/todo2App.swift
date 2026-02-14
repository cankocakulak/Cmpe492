//
//  todo2App.swift
//  todo2
//
//  Created by Murat Can Kocakulak on 14.02.2026.
//

import SwiftUI
import CoreData

@main
struct todo2App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
