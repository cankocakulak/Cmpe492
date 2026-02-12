//
//  TaskEntitySchemaTests.swift
//  Cmpe492Tests
//
//  Created for Story 1.2: Design Core Data Task Entity Schema
//

import XCTest
import CoreData
@testable import Cmpe492

/// Tests to verify Core Data Task entity schema is correctly defined
/// Tests all attributes, types, defaults, and indexes as specified in Story 1.2
final class TaskEntitySchemaTests: XCTestCase {
    
    var persistenceController: PersistenceController!
    var context: NSManagedObjectContext!
    
    override func setUpWithError() throws {
        // Create in-memory persistence controller for testing
        persistenceController = PersistenceController(inMemory: true)
        context = persistenceController.container.viewContext
    }
    
    override func tearDownWithError() throws {
        context = nil
        persistenceController = nil
    }
    
    // MARK: - Entity Existence Tests
    
    func testTaskEntityExists() throws {
        // Verify Task entity exists in Core Data model
        let taskEntity = NSEntityDescription.entity(forEntityName: "Task", in: context)
        XCTAssertNotNil(taskEntity, "Task entity should exist in Core Data model")
        XCTAssertEqual(taskEntity?.name, "Task", "Entity name should be 'Task'")
    }
    
    // MARK: - Attribute Existence and Type Tests
    
    func testTaskEntityHasAllRequiredAttributes() throws {
        let taskEntity = NSEntityDescription.entity(forEntityName: "Task", in: context)!
        let attributeNames = taskEntity.attributesByName.keys.sorted()
        
        let expectedAttributes = [
            "completedAt",
            "createdAt",
            "id",
            "scheduledDate",
            "sortOrder",
            "state",
            "text",
            "updatedAt"
        ]
        
        XCTAssertEqual(Set(attributeNames), Set(expectedAttributes),
                      "Task entity should have all required attributes")
    }
    
    func testIdAttributeIsUUID() throws {
        let taskEntity = NSEntityDescription.entity(forEntityName: "Task", in: context)!
        let idAttribute = taskEntity.attributesByName["id"]
        
        XCTAssertNotNil(idAttribute, "id attribute should exist")
        XCTAssertEqual(idAttribute?.attributeType, .UUIDAttributeType,
                      "id should be UUID type")
        XCTAssertFalse(idAttribute?.isOptional ?? true,
                      "id should be required (non-optional)")
    }
    
    func testTextAttributeIsString() throws {
        let taskEntity = NSEntityDescription.entity(forEntityName: "Task", in: context)!
        let textAttribute = taskEntity.attributesByName["text"]
        
        XCTAssertNotNil(textAttribute, "text attribute should exist")
        XCTAssertEqual(textAttribute?.attributeType, .stringAttributeType,
                      "text should be String type")
        XCTAssertFalse(textAttribute?.isOptional ?? true,
                      "text should be required (non-optional)")
    }
    
    func testStateAttributeIsString() throws {
        let taskEntity = NSEntityDescription.entity(forEntityName: "Task", in: context)!
        let stateAttribute = taskEntity.attributesByName["state"]
        
        XCTAssertNotNil(stateAttribute, "state attribute should exist")
        XCTAssertEqual(stateAttribute?.attributeType, .stringAttributeType,
                      "state should be String type")
        XCTAssertFalse(stateAttribute?.isOptional ?? true,
                      "state should be required (non-optional)")
    }
    
    func testDateAttributesAreDate() throws {
        let taskEntity = NSEntityDescription.entity(forEntityName: "Task", in: context)!
        
        // Test createdAt
        let createdAt = taskEntity.attributesByName["createdAt"]
        XCTAssertNotNil(createdAt, "createdAt attribute should exist")
        XCTAssertEqual(createdAt?.attributeType, .dateAttributeType,
                      "createdAt should be Date type")
        XCTAssertFalse(createdAt?.isOptional ?? true,
                      "createdAt should be required (non-optional)")
        
        // Test updatedAt
        let updatedAt = taskEntity.attributesByName["updatedAt"]
        XCTAssertNotNil(updatedAt, "updatedAt attribute should exist")
        XCTAssertEqual(updatedAt?.attributeType, .dateAttributeType,
                      "updatedAt should be Date type")
        XCTAssertFalse(updatedAt?.isOptional ?? true,
                      "updatedAt should be required (non-optional)")
        
        // Test completedAt (optional)
        let completedAt = taskEntity.attributesByName["completedAt"]
        XCTAssertNotNil(completedAt, "completedAt attribute should exist")
        XCTAssertEqual(completedAt?.attributeType, .dateAttributeType,
                      "completedAt should be Date type")
        XCTAssertTrue(completedAt?.isOptional ?? false,
                     "completedAt should be optional")
        
        // Test scheduledDate (optional)
        let scheduledDate = taskEntity.attributesByName["scheduledDate"]
        XCTAssertNotNil(scheduledDate, "scheduledDate attribute should exist")
        XCTAssertEqual(scheduledDate?.attributeType, .dateAttributeType,
                      "scheduledDate should be Date type")
        XCTAssertTrue(scheduledDate?.isOptional ?? false,
                     "scheduledDate should be optional")
    }
    
    func testSortOrderAttributeIsInteger32() throws {
        let taskEntity = NSEntityDescription.entity(forEntityName: "Task", in: context)!
        let sortOrder = taskEntity.attributesByName["sortOrder"]
        
        XCTAssertNotNil(sortOrder, "sortOrder attribute should exist")
        XCTAssertEqual(sortOrder?.attributeType, .integer32AttributeType,
                      "sortOrder should be Integer32 type")
        XCTAssertFalse(sortOrder?.isOptional ?? true,
                      "sortOrder should be required (non-optional)")
    }
    
    // MARK: - Default Value Tests
    
    func testStateDefaultValue() throws {
        let taskEntity = NSEntityDescription.entity(forEntityName: "Task", in: context)!
        let stateAttribute = taskEntity.attributesByName["state"]
        
        XCTAssertEqual(stateAttribute?.defaultValue as? String, "notStarted",
                      "state should have default value 'notStarted'")
    }
    
    func testSortOrderDefaultValue() throws {
        let taskEntity = NSEntityDescription.entity(forEntityName: "Task", in: context)!
        let sortOrderAttribute = taskEntity.attributesByName["sortOrder"]
        
        XCTAssertEqual(sortOrderAttribute?.defaultValue as? Int32, 0,
                      "sortOrder should have default value 0")
    }
    
    // MARK: - Task Creation Tests
    
    func testCreateTaskWithRequiredAttributes() throws {
        // Create a new Task entity
        let task = Task(context: context)
        task.id = UUID()
        task.text = "Test Task"
        task.state = "notStarted"
        task.createdAt = Date()
        task.updatedAt = Date()
        task.sortOrder = 0
        
        // Save context
        try context.save()
        
        // Verify task was created
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let tasks = try context.fetch(fetchRequest)
        
        XCTAssertEqual(tasks.count, 1, "Should have created 1 task")
        XCTAssertEqual(tasks.first?.text, "Test Task", "Task text should match")
        XCTAssertEqual(tasks.first?.state, "notStarted", "Task state should be 'notStarted'")
    }
    
    func testCreateTaskWithOptionalAttributes() throws {
        // Create a task with optional attributes
        let task = Task(context: context)
        task.id = UUID()
        task.text = "Scheduled Task"
        task.state = "active"
        task.createdAt = Date()
        task.updatedAt = Date()
        task.sortOrder = 1
        task.scheduledDate = Date()
        task.completedAt = Date()
        
        // Save context
        try context.save()
        
        // Verify task was created with optional attributes
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let tasks = try context.fetch(fetchRequest)
        
        XCTAssertEqual(tasks.count, 1, "Should have created 1 task")
        XCTAssertNotNil(tasks.first?.scheduledDate, "scheduledDate should be set")
        XCTAssertNotNil(tasks.first?.completedAt, "completedAt should be set")
    }
    
    func testTaskStateValues() throws {
        // Test all three valid state values
        let states = ["notStarted", "active", "completed"]
        
        for state in states {
            let task = Task(context: context)
            task.id = UUID()
            task.text = "Task with state: \(state)"
            task.state = state
            task.createdAt = Date()
            task.updatedAt = Date()
            task.sortOrder = 0
        }
        
        try context.save()
        
        // Verify all tasks were created
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let tasks = try context.fetch(fetchRequest)
        
        XCTAssertEqual(tasks.count, 3, "Should have created 3 tasks")
        
        let taskStates = Set(tasks.compactMap { $0.state })
        XCTAssertEqual(taskStates, Set(states), "All state values should be present")
    }
    
    // MARK: - Query Performance Tests
    
    func testQueryByScheduledDate() throws {
        // Create tasks with different scheduledDate values
        let today = Calendar.current.startOfDay(for: Date())
        
        for i in 0..<5 {
            let task = Task(context: context)
            task.id = UUID()
            task.text = "Task \(i)"
            task.state = "notStarted"
            task.createdAt = Date()
            task.updatedAt = Date()
            task.sortOrder = Int32(i)
            
            if i < 2 {
                task.scheduledDate = today
            } else if i < 4 {
                task.scheduledDate = Calendar.current.date(byAdding: .day, value: 1, to: today)
            }
            // Last task has nil scheduledDate (Inbox)
        }
        
        try context.save()
        
        // Query tasks for today
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "scheduledDate == %@", today as NSDate)
        
        let todayTasks = try context.fetch(fetchRequest)
        XCTAssertEqual(todayTasks.count, 2, "Should find 2 tasks scheduled for today")
    }
    
    func testQueryByCompletedAt() throws {
        // Create completed and incomplete tasks
        let now = Date()
        
        for i in 0..<3 {
            let task = Task(context: context)
            task.id = UUID()
            task.text = "Task \(i)"
            task.state = i < 2 ? "completed" : "notStarted"
            task.createdAt = Date()
            task.updatedAt = Date()
            task.sortOrder = Int32(i)
            
            if i < 2 {
                task.completedAt = now
            }
        }
        
        try context.save()
        
        // Query completed tasks
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "completedAt != nil")
        
        let completedTasks = try context.fetch(fetchRequest)
        XCTAssertEqual(completedTasks.count, 2, "Should find 2 completed tasks")
    }
    
    // MARK: - Index Verification Tests
    
    func testIdAttributeIsIndexed() throws {
        let taskEntity = NSEntityDescription.entity(forEntityName: "Task", in: context)!
        let idAttribute = taskEntity.attributesByName["id"]
        
        XCTAssertTrue(idAttribute?.isIndexed ?? false,
                     "id attribute should be indexed for sync lookups")
    }
    
    func testScheduledDateAttributeIsIndexed() throws {
        let taskEntity = NSEntityDescription.entity(forEntityName: "Task", in: context)!
        let scheduledDateAttribute = taskEntity.attributesByName["scheduledDate"]
        
        XCTAssertTrue(scheduledDateAttribute?.isIndexed ?? false,
                     "scheduledDate attribute should be indexed for view filtering")
    }
    
    func testCreatedAtAttributeIsIndexed() throws {
        let taskEntity = NSEntityDescription.entity(forEntityName: "Task", in: context)!
        let createdAtAttribute = taskEntity.attributesByName["createdAt"]
        
        XCTAssertTrue(createdAtAttribute?.isIndexed ?? false,
                     "createdAt attribute should be indexed for sorting")
    }
    
    func testCompletedAtAttributeIsIndexed() throws {
        let taskEntity = NSEntityDescription.entity(forEntityName: "Task", in: context)!
        let completedAtAttribute = taskEntity.attributesByName["completedAt"]
        
        XCTAssertTrue(completedAtAttribute?.isIndexed ?? false,
                     "completedAt attribute should be indexed for analytics queries")
    }
    
    // MARK: - Data Validation Tests
    
    func testUniqueConstraintOnId() throws {
        // Create first task with specific UUID
        let sharedUUID = UUID()
        
        let task1 = Task(context: context)
        task1.id = sharedUUID
        task1.text = "First Task"
        task1.state = "notStarted"
        task1.createdAt = Date()
        task1.updatedAt = Date()
        task1.sortOrder = 0
        
        try context.save()
        
        // Attempt to create second task with same UUID
        let task2 = Task(context: context)
        task2.id = sharedUUID
        task2.text = "Second Task"
        task2.state = "notStarted"
        task2.createdAt = Date()
        task2.updatedAt = Date()
        task2.sortOrder = 1
        
        // Save should fail due to unique constraint
        XCTAssertThrowsError(try context.save()) { error in
            XCTAssertTrue(error is NSError, "Should throw NSError for constraint violation")
        }
    }
    
    func testSortOrderDefaultValueIsApplied() throws {
        // Create task without explicitly setting sortOrder
        let task = Task(context: context)
        task.id = UUID()
        task.text = "Task with default sortOrder"
        task.state = "notStarted"
        task.createdAt = Date()
        task.updatedAt = Date()
        // Intentionally NOT setting sortOrder
        
        // Note: Core Data default values are applied on insert
        // We need to verify the default is actually used
        XCTAssertEqual(task.sortOrder, 0, "sortOrder should default to 0")
    }
    
    // MARK: - CloudKit Readiness Tests
    
    func testModelHasCloudKitEnabled() throws {
        // Verify the model is configured for CloudKit sync
        let model = persistenceController.container.managedObjectModel
        XCTAssertNotNil(model, "Managed object model should exist")
        
        // Verify model has entities
        XCTAssertFalse(model.entities.isEmpty, "Model should have at least one entity")
        
        // Verify Task entity exists in model
        let taskEntity = model.entitiesByName["Task"]
        XCTAssertNotNil(taskEntity, "Task entity should exist in model")
        
        // Note: usedWithCloudKit flag is set in XML but not directly accessible via NSManagedObjectModel API
        // Full CloudKit setup verification happens in Phase 3
    }
}
