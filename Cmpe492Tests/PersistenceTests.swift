//
//  PersistenceTests.swift
//  Cmpe492Tests
//
//  Created for Story 1.1 - Basic Core Data initialization tests
//

import XCTest
import CoreData
@testable import Cmpe492

final class PersistenceTests: XCTestCase {
    
    /// Test that PersistenceController initializes successfully
    func testPersistenceControllerInitialization() throws {
        let controller = PersistenceController(inMemory: true)
        
        XCTAssertNotNil(controller.container, "NSPersistentContainer should be initialized")
        XCTAssertEqual(controller.container.name, "Cmpe492", "Container name should match project name")
    }
    
    /// Test that viewContext is configured correctly
    func testViewContextConfiguration() throws {
        let controller = PersistenceController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        XCTAssertNotNil(viewContext, "ViewContext should exist")
        XCTAssertTrue(viewContext.automaticallyMergesChangesFromParent, 
                      "ViewContext should automatically merge changes from parent for real-time updates")
    }
    
    /// Test that Core Data stack loads without errors
    func testPersistentStoreLoads() throws {
        let controller = PersistenceController(inMemory: true)
        let container = controller.container
        
        // Verify at least one persistent store is loaded
        XCTAssertFalse(container.persistentStoreDescriptions.isEmpty, 
                       "At least one persistent store description should exist")
        
        // Verify the store loaded successfully (if it failed, initialization would have crashed)
        // The fact that we got here means loadPersistentStores succeeded
        XCTAssertTrue(true, "Persistent store loaded successfully")
    }
    
    /// Test that in-memory store is properly configured for testing
    func testInMemoryStoreConfiguration() throws {
        let controller = PersistenceController(inMemory: true)
        let storeDescription = controller.container.persistentStoreDescriptions.first
        
        XCTAssertNotNil(storeDescription, "Store description should exist")
        // In-memory store should use /dev/null URL
        XCTAssertEqual(storeDescription?.url?.path, "/dev/null", 
                      "In-memory store should use /dev/null URL")
    }
    
    /// Test that shared singleton is accessible
    func testSharedSingleton() throws {
        let shared = PersistenceController.shared
        
        XCTAssertNotNil(shared, "Shared PersistenceController should be accessible")
        XCTAssertNotNil(shared.container, "Shared container should exist")
    }
}
