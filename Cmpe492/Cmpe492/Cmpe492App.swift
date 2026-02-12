//
//  Cmpe492App.swift
//  Cmpe492
//
//  Created by Murat Can Kocakulak on 12.02.2026.
//

import SwiftUI
import CoreData

@main
struct Cmpe492App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
