# Story 3.8: Enforce No Automatic Rollover Logic

Status: done

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a developer,
I want to ensure tasks never automatically move to the next day,
so that users maintain full agency over their task lifecycle.

## Acceptance Criteria

1. Given tasks exist in Today view at the end of the day (11:59 PM)
2. When the date boundary transitions to midnight (12:00 AM)
3. Then the tasks from yesterday remain with their original scheduledDate
4. And the tasks appear in the view for yesterday's date (past tasks)
5. And the Today view filters to show only tasks with today's new date
6. And yesterday's incomplete tasks are NOT automatically moved to today
7. And yesterday's incomplete tasks remain accessible (could show in "Past" view in Phase 2)
8. And the user must manually drag tasks to today if they want to carry them forward
9. And this behavior is consistent across app restarts and force quits
10. And no background process or system logic automatically updates scheduledDate

## Tasks / Subtasks

- [x] Task 1: Audit day-change logic to ensure scheduledDate is never auto-advanced.
- [x] Task 2: Add tests verifying no scheduledDate changes on midnight refresh.
- [x] Task 3: Document manual carry-forward requirement and ensure no background process updates dates.

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
- Audit TaskViewModel.refreshForNewDay and ensure it never mutates scheduledDate.
- Add guardrails in Utilities/DateHelpers or ViewModels as needed.
### Testing Requirements
- Unit tests: refreshForNewDay does not mutate scheduledDate for any task.
- Manual QA: midnight boundary does not auto-move tasks.
### Previous Story Intelligence
- Leverage 3.9 day-change refresh logic; ensure it does not mutate scheduledDate.
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

- Confirm refreshForNewDay only updates filters and never mutates scheduledDate.
- Add guardrail comment documenting manual carry-forward requirement.
- Add unit test ensuring scheduledDate remains unchanged across refresh.

### Completion Notes List
- Confirmed day-change refresh only updates predicates and never auto-advances dates.
- Documented manual carry-forward requirement in refreshForNewDay.
- Added unit test to verify scheduledDate is unchanged across midnight refresh.
- Tests: `xcodebuild test -project Cmpe492/Cmpe492.xcodeproj -scheme Cmpe492 -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.5' -derivedDataPath /tmp/Cmpe492DerivedData`
- Code review pass: refreshed File List to match repo changes, verified tests, and marked story done.
### File List
- Cmpe492/Cmpe492/ViewModels/TaskViewModel.swift
- Cmpe492Tests/TaskViewModelTests.swift
- _bmad-output/implementation-artifacts/3-8-enforce-no-automatic-rollover-logic.md
- _bmad-output/implementation-artifacts/sprint-status.yaml
- Cmpe492/Cmpe492.xcodeproj/project.pbxproj
- Cmpe492/Cmpe492/Components/DatePickerSheet.swift
- Cmpe492/Cmpe492/Components/DragPreview.swift
- Cmpe492/Cmpe492/Components/TaskRow.swift
- Cmpe492/Cmpe492/Components/UndoToast.swift
- Cmpe492/Cmpe492/Utilities/DayChangeObserver.swift
- Cmpe492/Cmpe492/Utilities/DragCoordinator.swift
- Cmpe492/Cmpe492/Utilities/PerformanceMetrics.swift
- Cmpe492/Cmpe492/Utilities/TabBarDropDelegate.swift
- Cmpe492/Cmpe492/Utilities/TaskListDropDelegate.swift
- Cmpe492/Cmpe492/Utilities/TaskReorderDropDelegate.swift
- Cmpe492/Cmpe492/Utilities/UndoCoordinator.swift
- Cmpe492/Cmpe492/Views/ContentView.swift
- Cmpe492/Cmpe492/Views/InboxView.swift
- Cmpe492/Cmpe492/Views/TodayView.swift
- Cmpe492/Cmpe492/Views/UpcomingView.swift
- Cmpe492Tests/UndoCoordinatorTests.swift
### Change Log
- 2026-02-12: Documented no-rollover behavior and added tests guarding scheduledDate stability.
- 2026-02-12: Code review pass; refreshed File List and marked story done.
## Completion Status

Status set to done.
- Sprint status updated for this story key.
