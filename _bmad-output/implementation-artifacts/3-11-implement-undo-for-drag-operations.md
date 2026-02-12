# Story 3.11: Implement Undo for Drag Operations

Status: done

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a user,
I want an undo option after moving a task,
so that I can quickly correct mistakes without manually moving it back.

## Acceptance Criteria

1. Given I successfully move a task via drag or quick action
2. When the task lands in its new location
3. Then a toast notification appears at the bottom: "Moved to [View Name]" with "Undo" button
4. And the toast is visible for 3 seconds
5. And the toast doesn't block the input field or primary interactions
6. When I tap "Undo" within 3 seconds
7. Then the task returns to its original view and position
8. And the scheduledDate reverts to the previous value
9. And the sortOrder reverts to the previous value
10. And the undo action completes with smooth animation
11. And all changes persist immediately
12. When 3 seconds elapse without tapping Undo
13. Then the toast dismisses automatically
14. And the move becomes permanent (but still manually reversible)

## Tasks / Subtasks

- [x] Task 1: Implement undo toast (3s) with 'Undo' action and non-blocking layout.
- [x] Task 2: Track last move details (source view, index, scheduledDate, sortOrder).
- [x] Task 3: Revert move on undo and persist changes immediately.
- [x] Task 4: Add tests for undo within window and expiry behavior.

## Dev Notes

### Developer Context
- Task lists use TaskViewModel with Core Data filtering and sortOrder ordering.
- TaskRow is the reusable row component and currently handles tap; extend it for drag/swipe as needed.
- ContentView hosts the TabView; cross-tab drag requires shared state at this level.
- DateHelpers provides start-of-day and tomorrow calculations for scheduledDate updates.
### Technical Requirements
- Use native SwiftUI drag/drop and gestures; avoid third-party libraries.
- Provide haptic feedback via UIImpactFeedbackGenerator and respect system haptics settings.
- Maintain 60fps during drag; minimize re-renders and heavy fetches during gestures.
- Persist updates immediately to Core Data with optimistic UI updates.
- Use 200-300ms animations (spring for reordering, easeInOut for transitions).
- Respect Reduce Motion and accessibility settings for animations and drag feedback.
### Architecture Compliance
- Keep MVVM boundaries: drag logic in view models/coordination layer, not inline view body logic.
- Core Data remains the single source of truth; update sortOrder and scheduledDate in one transaction.
- Use DateHelpers for all date arithmetic; no manual time interval math.
- Follow design tokens and system colors per UX spec; avoid custom styling.
### Library and Framework Requirements
- SwiftUI (List, Section, .onDrag/.onDrop, gestures, animations).
- Core Data (NSManagedObjectContext, NSFetchedResultsController).
- UIKit for haptics (UIImpactFeedbackGenerator) where needed.
### Project Structure Notes
- Add UndoToast component under Components.
- Add drag move tracking in a shared coordinator or TaskViewModel.
### Testing Requirements
- Unit tests: undo within 3 seconds reverts scheduledDate and sortOrder.
- Manual QA: undo toast timing and non-blocking layout.
### Previous Story Intelligence
- Undo applies to moves from 3.2-3.7; capture move metadata from those flows for reversal.
### Git Intelligence Summary
- Recent commits indicate Epic 2 completion and ongoing iteration (e.g., 'epic2', 'continue').
- Follow existing MVVM + Core Data patterns and avoid refactors not required for drag features.
### Latest Tech Information
- Apple's "What's New in Swift" documents Swift 6.2 features; review for concurrency/tooling changes before implementing drag-heavy code.
- Apple Xcode release notes list Xcode 26.x as current; use the latest stable Xcode available and review SwiftUI drag/drop changes.
- Keep iOS 15+ deployment target; guard any APIs introduced after iOS 15 with availability checks.
### Project Context Reference
- No project-context.md found in repository; use architecture, PRD, and UX spec as authoritative context.

## References
- _bmad-output/planning-artifacts/epics.md#Epic 3: Drag-Based Time Manipulation
- _bmad-output/planning-artifacts/architecture.md#Drag & Drop System
- _bmad-output/planning-artifacts/architecture.md#Implementation Patterns & Consistency Rules
- _bmad-output/planning-artifacts/ux-design-specification.md#Spatial Time Manipulation ("Sliding Through Time")
- _bmad-output/planning-artifacts/ux-design-specification.md#Animation Patterns
- _bmad-output/planning-artifacts/prd.md#Functional Requirements
- Cmpe492/Cmpe492/Components/TaskRow.swift
- Cmpe492/Cmpe492/ViewModels/TaskViewModel.swift
- Cmpe492/Cmpe492/Views/ContentView.swift
- Cmpe492/Cmpe492/Views/TodayView.swift
- Cmpe492/Cmpe492/Views/InboxView.swift
- Cmpe492/Cmpe492/Views/UpcomingView.swift
- Cmpe492/Cmpe492/Utilities/DateHelpers.swift

## Dev Agent Record

### Agent Model Used

GPT-5 (Codex)

### Debug Log References

- 2026-02-12: `xcodebuild test -project /Users/mcan/Boun/Cmpe492/Cmpe492/Cmpe492.xcodeproj -scheme Cmpe492 -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.5' -derivedDataPath /tmp/Cmpe492DerivedData`

### Implementation Plan

- Follow Tasks/Subtasks for implementation sequence.

### Completion Notes List
- Ultimate context engine analysis completed - comprehensive developer guide created
- Added `UndoToast` overlay and `UndoCoordinator` to present a 3s undo action without blocking interactions.
- Captured drag origins (task ID, index, scheduledDate, sortOrder) and wired undo registration across drag and quick actions.
- Implemented `restoreTask` to revert scheduledDate and sortOrder in one transaction with immediate persistence.
- Tests added for undo timing/expiry and restore behavior; full suite passes.
- Tests: `xcodebuild test -project /Users/mcan/Boun/Cmpe492/Cmpe492/Cmpe492.xcodeproj -scheme Cmpe492 -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.5' -derivedDataPath /tmp/Cmpe492DerivedData`
- Code review pass: refreshed File List to match repo changes, verified tests, and marked story done.
### File List
- _bmad-output/implementation-artifacts/3-11-implement-undo-for-drag-operations.md
- _bmad-output/implementation-artifacts/sprint-status.yaml
- Cmpe492/Cmpe492/Components/UndoToast.swift
- Cmpe492/Cmpe492/Utilities/UndoCoordinator.swift
- Cmpe492/Cmpe492/Utilities/DragCoordinator.swift
- Cmpe492/Cmpe492/ViewModels/TaskViewModel.swift
- Cmpe492/Cmpe492/Views/ContentView.swift
- Cmpe492/Cmpe492/Views/InboxView.swift
- Cmpe492/Cmpe492/Views/TodayView.swift
- Cmpe492/Cmpe492/Views/UpcomingView.swift
- Cmpe492Tests/TaskViewModelTests.swift
- Cmpe492Tests/UndoCoordinatorTests.swift
- Cmpe492/Cmpe492.xcodeproj/project.pbxproj
- Cmpe492/Cmpe492/Components/DatePickerSheet.swift
- Cmpe492/Cmpe492/Components/DragPreview.swift
- Cmpe492/Cmpe492/Components/TaskRow.swift
- Cmpe492/Cmpe492/Utilities/DayChangeObserver.swift
- Cmpe492/Cmpe492/Utilities/PerformanceMetrics.swift
- Cmpe492/Cmpe492/Utilities/TabBarDropDelegate.swift
- Cmpe492/Cmpe492/Utilities/TaskListDropDelegate.swift
- Cmpe492/Cmpe492/Utilities/TaskReorderDropDelegate.swift
## Completion Status

Status set to done.
Sprint status updated for this story key.

### Change Log
- 2026-02-12: Added undo toast, move tracking, and restore logic with tests for undo timing and persistence.
- 2026-02-12: Code review pass; refreshed File List and marked story done.
