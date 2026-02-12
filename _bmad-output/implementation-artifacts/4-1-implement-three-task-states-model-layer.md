# Story 4.1: Implement Three Task States (Model Layer)

Status: done

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a developer,
I want to implement the three task states in the data model,
so that tasks can track their progress through the workflow.

## Acceptance Criteria

1. Given the Task entity exists in Core Data
2. When updating the Task model
3. Then the `state` attribute supports three string values: "notStarted", "active", "completed"
4. And "notStarted" is the default for new tasks
5. And helper methods exist for state transitions:
   - `markAsActive()` sets state to "active" and updates `updatedAt`
   - `markAsCompleted()` sets state to "completed", sets `completedAt` to now, updates `updatedAt`
   - `markAsNotStarted()` sets state to "notStarted", clears `completedAt`, updates `updatedAt`
6. And state changes persist immediately to Core Data
7. And computed properties exist for checking state: `isNotStarted`, `isActive`, `isCompleted`

## Tasks / Subtasks

- [x] Task 1: Verify Core Data schema includes `state`, `completedAt`, and `updatedAt` with correct types and defaults.
  - [x] Subtask 1.1: Ensure new tasks default to `state = notStarted` (schema default + `awakeFromInsert`/creation path).
- [x] Task 2: Implement or confirm `TaskState` enum and transition helpers in `Task+Extensions`.
  - [x] Subtask 2.1: Add `isNotStarted` computed property to mirror `isActive`/`isCompleted`.
- [x] Task 3: Add a ViewModel method to persist state transitions with immediate `context.save()` and error handling.
- [x] Task 4: Add unit tests for state transitions and persistence (`completedAt` set/cleared, `updatedAt` updated).

## Dev Notes

### Developer Context
- Core Data Task entity already includes `state`, `completedAt`, and `updatedAt` (confirm in `Cmpe492.xcdatamodeld`).
- `Cmpe492/Cmpe492/Models/Task+Extensions.swift` currently defines `TaskState` and transition helpers; align with acceptance criteria and add missing `isNotStarted`.
- `TaskViewModel` handles persistence via `NSFetchedResultsController` and existing save/error handling patterns.
### Technical Requirements
- Keep string values exactly: `notStarted`, `active`, `completed`.
- State changes must update UI within 50ms (NFR3) using optimistic updates.
- Persist immediately to Core Data; log and surface errors using existing `TaskViewModel` error handling.
- Do not add third-party dependencies.
### Architecture Compliance
- Core Data is the single source of truth; mutate the managed object and save.
- Keep MVVM boundaries: model helpers in `Task+Extensions`, persistence in `TaskViewModel` (or a dedicated service if added later).
- Use existing Date utilities and logging patterns; no global state or ad-hoc singletons.
### Library and Framework Requirements
- Core Data (`NSManagedObjectContext`, `NSFetchedResultsController`)
- Foundation (`Date`)
- os_log / Logger for persistence errors
### Project Structure Notes
- Update `Cmpe492/Cmpe492/Models/Task+Extensions.swift` for state helpers and computed properties.
- Use `Cmpe492/Cmpe492/ViewModels/TaskViewModel.swift` to expose state-change persistence APIs.
- Review `Cmpe492/Cmpe492.xcdatamodeld` for attribute definitions and defaults.
### Testing Requirements
- Unit tests (suggested: `Cmpe492Tests/TaskViewModelTests.swift` or `TaskModelTests.swift`) to verify:
  - Default state = `notStarted` for new tasks.
  - `markActive`, `markCompleted`, `markNotStarted` update `state`, `updatedAt`, `completedAt` correctly.
  - State changes persist after refresh/fetch.
### Latest Tech Information
- Swift.org lists Swift 6.3 toolchains (Jan 29, 2026). Use the Swift toolchain bundled with your chosen Xcode, and verify language changes before adopting new syntax/features.
- Xcode Cloud release notes list Xcode 26.2 as available; App Store Connect release notes (Feb 3, 2026) accept uploads built with Xcode 26.3 RC and the iOS 26.2 SDK.
- Apple’s upcoming requirements indicate that, starting Apr 28, 2026, App Store uploads must use Xcode 26+ and the iOS 26 SDK.
- iOS & iPadOS 26.1 release notes are available for SDK-level changes; keep deployment target at iOS 15+ and guard newer APIs with availability checks.

### Project Context Reference
- No `project-context.md` found in repository; use architecture, PRD, and UX spec as authoritative context.

## References
- _bmad-output/planning-artifacts/epics.md#Epic 4: Task State Management & Completion
- _bmad-output/planning-artifacts/epics.md#Story 4.1: Implement Three Task States (Model Layer)
- _bmad-output/planning-artifacts/architecture.md#Task State & Progress Tracking
- _bmad-output/planning-artifacts/architecture.md#Core Data Schema Design
- _bmad-output/planning-artifacts/prd.md#Task State & Progress Tracking
- _bmad-output/planning-artifacts/ux-design-specification.md#State Changes
- Cmpe492/Cmpe492/Models/Task+Extensions.swift
- Cmpe492/Cmpe492/ViewModels/TaskViewModel.swift
- Cmpe492/Cmpe492.xcdatamodeld

## Dev Agent Record

### Agent Model Used

GPT-5 (Codex)

### Debug Log References

- `xcodebuild test -project Cmpe492/Cmpe492.xcodeproj -scheme Cmpe492 -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.5' -derivedDataPath /tmp/Cmpe492DerivedData` (2026-02-12)
- Test results: `/tmp/Cmpe492DerivedData/Logs/Test/Test-Cmpe492-2026.02.12_21-19-26-+0300.xcresult`

### Implementation Plan

- Verified Core Data schema defaults for `state`, `completedAt`, and `updatedAt` in `Cmpe492.xcdatamodeld`.
- Added `isNotStarted` and `markAs*` helpers in `Task+Extensions`.
- Added `updateTaskState(taskID:to:now:)` in `TaskViewModel` with immediate save + error handling.
- Added unit tests for state transitions and persistence.

### Completion Notes List

- Ultimate context engine analysis completed - comprehensive developer guide created
- Added `isNotStarted` and `markAs*` helpers in `Task+Extensions` to align with story ACs.
- Added `updateTaskState(taskID:to:now:)` in `TaskViewModel` with immediate save + error handling.
- Added tests for `isNotStarted` and persisted state transitions.
- Tests: `xcodebuild test -project Cmpe492/Cmpe492.xcodeproj -scheme Cmpe492 -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.5' -derivedDataPath /tmp/Cmpe492DerivedData`

- Code review pass: verified Epic 4 acceptance criteria and marked story done.

### File List

- _bmad-output/implementation-artifacts/4-1-implement-three-task-states-model-layer.md
- Cmpe492/Cmpe492/Models/Task+Extensions.swift
- Cmpe492/Cmpe492/ViewModels/TaskViewModel.swift
- Cmpe492/Cmpe492.xcdatamodeld
- Cmpe492Tests/TaskModelTests.swift
- Cmpe492Tests/TaskViewModelTests.swift
- _bmad-output/implementation-artifacts/sprint-status.yaml

### Change Log

- 2026-02-12: Added state helpers, ViewModel state persistence API, and unit tests for task state transitions.

- 2026-02-12: Code review pass; marked story done.

## Completion Status

Status set to done.
- Sprint status updated for this story key.
