//
//  Persistence.swift
//  Cmpe492
//
//  Created by Murat Can Kocakulak on 12.02.2026.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        // NOTE: This preview code uses placeholder 'Item' entity from Xcode template
        // Will be replaced with actual Task entity in Story 1.2
        for _ in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
            // Preview data save failure - acceptable to crash during development
            let nsError = error as NSError
            fatalError("Preview data creation failed: \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Cmpe492")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Core Data initialization failure is critical - app cannot function without persistence
                // Common causes: insufficient storage, permissions issues, or data model migration errors
                // Note: fatalError is appropriate here as the app requires Core Data to operate
                fatalError("Core Data initialization failed: \(error.localizedDescription) - \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
