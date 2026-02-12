# Story 3.7: Implement Quick Actions (Move to Today/Tomorrow)

Status: done

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a user,
I want quick one-tap actions to move tasks to Today or Tomorrow,
so that I can rapidly reschedule without drag interactions.

## Acceptance Criteria

1. Given a task exists in any view
2. When I swipe left on the task row
3. Then action buttons appear on the right side:
4. When I tap the "Today" button
5. Then the task's scheduledDate is set to today's date
6. And the task moves to Today view
7. And the task disappears from current view with slide-out animation
8. And changes persist immediately
9. When I tap the "Tomorrow" button
10. Then the task's scheduledDate is set to tomorrow's date
11. And the task moves to Upcoming view under "Tomorrow"
12. And the task disappears from current view
13. And changes persist immediately
14. When I swipe right to close actions or tap elsewhere
15. Then the action buttons slide away and task returns to normal

## Tasks / Subtasks

- [x] Task 1: Add swipe actions to TaskRow for Today (blue), Tomorrow (green), Delete (red).
- [x] Task 2: Wire Today/Tomorrow actions to scheduledDate updates and view moves.
- [x] Task 3: Ensure actions close cleanly and animations match list behavior.
- [x] Task 4: Add tests for quick actions and scheduledDate updates.

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
- Update TaskRow to add swipe actions.
- Wire quick actions through TaskViewModel move helpers.
- Coordinate delete action with existing deleteTask implementation.
### Testing Requirements
- Unit tests: swipe actions update scheduledDate for Today/Tomorrow.
- Manual QA: swipe actions appear and dismiss correctly; delete uses existing flow.
### Previous Story Intelligence
- Swipe actions should coexist with drag gestures; ensure gesture priority is explicit.
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

- Add trailing swipe actions to TaskRow for Today/Tomorrow/Delete with correct tints.
- Wire swipe actions in each view to scheduledDate updates and delete behavior.
- Ensure animations respect Reduce Motion and close cleanly with list updates.
- Add unit tests for Today/Tomorrow scheduledDate updates.

### Completion Notes List
- Added swipe actions for Today/Tomorrow/Delete with color tints and no full-swipe auto-trigger.
- Wired quick actions in Inbox/Today/Upcoming to scheduledDate updates and deletions with animations.
- Added unit tests for Today/Tomorrow scheduledDate updates.
- Tests: `xcodebuild test -project Cmpe492/Cmpe492.xcodeproj -scheme Cmpe492 -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.5' -derivedDataPath /tmp/Cmpe492DerivedData`
- Code review pass: refreshed File List to match repo changes, verified tests, and marked story done.
### File List
- Cmpe492/Cmpe492/Components/TaskRow.swift
- Cmpe492/Cmpe492/Views/InboxView.swift
- Cmpe492/Cmpe492/Views/TodayView.swift
- Cmpe492/Cmpe492/Views/UpcomingView.swift
- Cmpe492Tests/TaskViewModelTests.swift
- _bmad-output/implementation-artifacts/3-7-implement-quick-actions-move-to-today-tomorrow.md
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
- Cmpe492/Cmpe492/Utilities/TaskReorderDropDelegate.swift
- Cmpe492/Cmpe492/Utilities/UndoCoordinator.swift
- Cmpe492/Cmpe492/ViewModels/TaskViewModel.swift
- Cmpe492/Cmpe492/Views/ContentView.swift
- Cmpe492Tests/UndoCoordinatorTests.swift
### Change Log
- 2026-02-12: Added swipe quick actions and tests for scheduledDate updates.
- 2026-02-12: Code review pass; refreshed File List and marked story done.
## Completion Status

Status set to done.
- Sprint status updated for this story key.
