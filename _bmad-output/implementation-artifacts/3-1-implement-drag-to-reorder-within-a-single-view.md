# Story 3.1: Implement Drag-to-Reorder Within a Single View

Status: done

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a user,
I want to drag tasks up and down to reorder them within the same view,
so that I can adjust priority without extra menus.

## Acceptance Criteria

1. Given I am viewing any view with multiple tasks
2. When I long-press (300ms) on a task
3. Then the task lifts slightly with a subtle shadow
4. And haptic feedback occurs (medium impact)
5. And the task becomes semi-transparent (0.7 opacity)
6. And the task follows my finger as I drag vertically
7. And drag tracking maintains 60fps performance
8. When I drag the task over another task
9. Then the other tasks shift to make space for the dragged task
10. And the shift animation is smooth (spring animation, 200ms)
11. When I release the task in a new position
12. Then the task drops into place with smooth animation
13. And haptic feedback occurs (light impact)
14. And the sortOrder values are updated for all affected tasks
15. And the new order persists in Core Data immediately
16. And the new order is maintained after app restart

## Tasks / Subtasks

- [x] Task 1: Add drag state + long-press gesture to start reordering within a single list.
- [x] Subtask 1.1: Provide lift, shadow, and 0.7 opacity preview with haptic feedback on drag start.
- [x] Task 2: Implement drop handling to reorder rows and persist sortOrder updates.
- [x] Subtask 2.1: Recalculate sortOrder for affected tasks and save immediately.
- [x] Task 3: Add spring animations for row shifting and drop placement (200ms).
- [x] Task 4: Add unit tests for sortOrder persistence and reorder stability.

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
- Modify Cmpe492/Cmpe492/Components/TaskRow.swift for drag affordances.
- Update InboxView/TodayView/UpcomingView to enable in-list drag reorder.
- Extend TaskViewModel with reorder/sortOrder update utilities.
- Consider a new DragState/DragCoordinator in Cmpe492/Cmpe492/Utilities or ViewModels.
### Testing Requirements
- Unit tests: reorder updates sortOrder and persists across fetch refresh.
- Manual QA: long press drag reorder within Inbox/Today/Upcoming; verify haptics and animation.
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

- 

### Implementation Plan

- Add reorder helpers in TaskViewModel and a shared drop delegate for drag reordering.
- Update Inbox/Today/Upcoming views to wire drag/drop with haptics and row lift styling.
- Add unit test for moveTasks persistence and run full test suite.

### Completion Notes List
- Ultimate context engine analysis completed - comprehensive developer guide created
- Added drag-to-reorder support with haptics and lifted row styling across all three views.
- Implemented TaskViewModel.moveTasks to persist sortOrder updates.
- Tests: `xcodebuild test -project Cmpe492/Cmpe492.xcodeproj -scheme Cmpe492 -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.5' -derivedDataPath /tmp/Cmpe492DerivedData`
- Code review pass: refreshed File List to match repo changes, verified tests, and marked story done.
### File List
- _bmad-output/implementation-artifacts/3-1-implement-drag-to-reorder-within-a-single-view.md
- Cmpe492/Cmpe492/Components/TaskRow.swift
- Cmpe492/Cmpe492/Utilities/TaskReorderDropDelegate.swift
- Cmpe492/Cmpe492/ViewModels/TaskViewModel.swift
- Cmpe492/Cmpe492/Views/InboxView.swift
- Cmpe492/Cmpe492/Views/TodayView.swift
- Cmpe492/Cmpe492/Views/UpcomingView.swift
- Cmpe492Tests/TaskViewModelTests.swift
- _bmad-output/implementation-artifacts/sprint-status.yaml
- Cmpe492/Cmpe492.xcodeproj/project.pbxproj
- Cmpe492/Cmpe492/Components/DatePickerSheet.swift
- Cmpe492/Cmpe492/Components/DragPreview.swift
- Cmpe492/Cmpe492/Components/UndoToast.swift
- Cmpe492/Cmpe492/Utilities/DayChangeObserver.swift
- Cmpe492/Cmpe492/Utilities/DragCoordinator.swift
- Cmpe492/Cmpe492/Utilities/PerformanceMetrics.swift
- Cmpe492/Cmpe492/Utilities/TabBarDropDelegate.swift
- Cmpe492/Cmpe492/Utilities/TaskListDropDelegate.swift
- Cmpe492/Cmpe492/Utilities/UndoCoordinator.swift
- Cmpe492/Cmpe492/Views/ContentView.swift
- Cmpe492Tests/UndoCoordinatorTests.swift
### Change Log
- 2026-02-12: Added drag-to-reorder support across views with persisted sortOrder updates and tests.
- 2026-02-12: Code review pass; refreshed File List and marked story done.
## Completion Status

Status set to done.
- Sprint status updated for this story key.
