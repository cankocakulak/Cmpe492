# Story 1.3: Create Task Model and MVVM Structure

Status: ready-for-dev

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a developer,
I want to implement the Task model with MVVM architecture pattern,
so that business logic is separated from the UI and the codebase is testable and maintainable.

## Acceptance Criteria

**Given** the Task entity is defined in Core Data  
**When** implementing the MVVM structure  
**Then** a Task class extension provides:  
- Computed properties for easy access to Core Data attributes  
- Helper methods for state transitions  
- Proper Hashable and Identifiable conformance for SwiftUI  
**And** a TaskViewModel (ObservableObject) is created with:  
- @Published property for tasks array  
- Methods for CRUD operations  
- Reference to PersistenceController  
- Proper initialization  
**And** folder structure follows: Models/, Views/, ViewModels/  
**And** code compiles without errors

## Tasks / Subtasks

- [ ] Create MVVM folder structure in the app target: `Models/`, `Views/`, `ViewModels/` (AC: folder structure)
- [ ] Move `ContentView.swift` into `Views/` (Xcode group + filesystem) without behavior changes (AC: folder structure)
- [ ] Add `Models/Task+Extensions.swift` with `TaskState` enum and computed properties (AC: Task extension)
- [ ] Implement Task state transition helpers (set `state`, `updatedAt`, `completedAt` correctly) (AC: Task extension)
- [ ] Implement `ViewModels/TaskViewModel.swift` as `ObservableObject` with `@Published var tasks: [Task]` and CRUD methods (AC: TaskViewModel)
- [ ] Wire `TaskViewModel` to `PersistenceController` and main `NSManagedObjectContext` (AC: TaskViewModel)
- [ ] Add unit tests for Task extension + TaskViewModel CRUD using in-memory Core Data (AC: code compiles, behavior verified)

## Dev Notes

### Developer Context

- This story creates the MVVM scaffold and Task model helpers only.
- Depends on the Task Core Data schema from Story 1.2; do not change the data model.
- Keep the app buildable and maintain the iOS 15.0 deployment target.
- No UI feature changes beyond moving `ContentView.swift` into `Views/` (behavior unchanged).

### Technical Requirements

- Define `TaskState: String` with exact raw values: `notStarted`, `active`, `completed`.
- Add Task extension computed properties: `wrappedText`, `stateValue` (fallback to `.notStarted`), `isActive`, `isCompleted`.
- Implement state transition helpers that update timestamps consistently:
  - `markActive()`: set `state = .active`, update `updatedAt`, keep `completedAt = nil`.
  - `markCompleted()`: set `state = .completed`, set `completedAt = now`, update `updatedAt`.
  - `markNotStarted()`: set `state = .notStarted`, clear `completedAt`, update `updatedAt`.
- Ensure Task conforms to `Identifiable` and `Hashable` for SwiftUI lists.
- TaskViewModel must expose `@Published var tasks: [Task]` sorted by `sortOrder` then `createdAt`.
- CRUD methods must set required fields (`id`, `text`, `state`, `createdAt`, `updatedAt`, `sortOrder`) and call `context.save()`.

### Architecture Compliance

- Keep Core Data logic out of SwiftUI Views; use `TaskViewModel` for all CRUD.
- Do not edit Xcode-generated `Task+CoreDataClass.swift` / `Task+CoreDataProperties.swift`; use an extension file in `Models/`.
- Use `PersistenceController.shared.container.viewContext` for UI operations (main thread).
- Fetch ordering must respect `sortOrder` as the primary key for list order.
- No third-party libraries; remain SwiftUI + Core Data only.

### Library / Framework Requirements

- Swift: use the Swift toolchain bundled with Xcode; current stable Swift release is 6.2.3.
- Xcode: use the latest stable Xcode (15.4 release notes list the iOS 17.5 SDK); keep app deployment target at iOS 15.0.
- Core Data + CloudKit: the model is marked “Used with CloudKit”; keep `NSPersistentContainer` for local-only MVP and only adopt `NSPersistentCloudKitContainer` when sync is implemented.

### Project Structure Notes

File locations to use (create folders on disk and Xcode groups to match):
- `Cmpe492/Cmpe492/Models/Task+Extensions.swift`
- `Cmpe492/Cmpe492/ViewModels/TaskViewModel.swift`
- `Cmpe492/Cmpe492/Views/ContentView.swift` (move existing file here)

Structure alignment notes:
- This begins the architecture.md structure (Models/, Views/, ViewModels/).
- Do not add Phase 2 folders yet unless needed for compilation.

### Testing Requirements

- Add `Cmpe492Tests/TaskModelTests.swift` for TaskState transitions and computed properties.
- Add `Cmpe492Tests/TaskViewModelTests.swift` for CRUD using `PersistenceController(inMemory: true)`.
- Ensure tests run without touching the on-disk store.

### Previous Story Intelligence (1.2)

- Deployment target must remain iOS 15.0 (was manually corrected in Story 1.1).
- Core Data schema already defines `Task`; do not reintroduce the template `Item` entity.
- `Persistence.swift` preview data is already updated to use Task; keep it compiling.
- Avoid committing user-specific Xcode files (e.g., `UserInterfaceState.xcuserstate`).

### Git Intelligence Summary

- Recent commits use conventional messages like `feat(story-1.2): ...` and `docs(story-1.2): ...`.
- Story tracking updates are committed alongside story docs in `_bmad-output/implementation-artifacts/`.
- Keep commits focused and avoid adding DerivedData or user-specific Xcode state files.

### Latest Technical Information

- Swift: Swift.org lists the current stable Swift release as 6.2.3; use the Swift toolchain bundled with Xcode for iOS builds.
- Xcode: Xcode 15.4 release notes list the iOS 17.5 SDK; this project still targets iOS 15.0 minimum.
- Core Data + CloudKit: Apple’s guidance uses `NSPersistentCloudKitContainer` only when enabling sync; otherwise keep `NSPersistentContainer` for local-only MVP.

### Project Context Reference

- Project: Cmpe492 (iOS SwiftUI + Core Data, MVVM).
- Epic 1 goal: instant task capture and reliable persistence.
- Previous story: 1.2 (Task Core Data schema) is done.
- Next story: 1.4 (Basic Today view with task list).

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story-1.3-Create-Task-Model-and-MVVM-Structure]
- [Source: _bmad-output/planning-artifacts/architecture.md#MVVM-Architecture-Pattern]
- [Source: _bmad-output/planning-artifacts/architecture.md#Project-Structure-Boundaries]
- [Source: _bmad-output/implementation-artifacts/1-2-design-core-data-task-entity-schema.md#Dev-Notes]
- [Source: _bmad-output/planning-artifacts/prd.md#Data-Management-&-Persistence]
- [Source: Apple Developer Documentation - Setting up Core Data with CloudKit]
- [Source: Apple Developer Documentation - Xcode 15.4 Release Notes]
- [Source: swift.org - Install Swift]

## Dev Agent Record

### Agent Model Used

Codex (GPT-5)

### Debug Log References

N/A

### Completion Notes List

- Ultimate context engine analysis completed - comprehensive developer guide created.
- Status set to ready-for-dev.

### File List

- `Cmpe492/Cmpe492/Views/ContentView.swift` (move from root)
- `Cmpe492/Cmpe492/Models/Task+Extensions.swift` (new)
- `Cmpe492/Cmpe492/ViewModels/TaskViewModel.swift` (new)
- `Cmpe492Tests/TaskModelTests.swift` (new)
- `Cmpe492Tests/TaskViewModelTests.swift` (new)
