# Story 3.3: Implement Drag Between Views (Today to Upcoming)

Status: done

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a user,
I want to drag a task from Today to Upcoming to reschedule it for the future,
so that I can consciously defer tasks without automatic rollover.

## Acceptance Criteria

1. Given I am viewing Today with tasks present
2. When I drag a task toward the "Upcoming" tab
3. Then the "Upcoming" tab highlights as a valid drop zone
4. When I hover over the Upcoming tab for 500ms
5. Then the view switches to Upcoming automatically
6. And the dragged task continues following my finger
7. When I release the task in Upcoming view
8. Then the task's scheduledDate is updated to tomorrow's date (default)
9. And the task disappears from Today view
10. And the task appears in Upcoming under "Tomorrow" date group
11. And sortOrder is calculated for the new position
12. And all changes persist immediately
13. And the task will not appear in Today anymore unless manually moved back

## Tasks / Subtasks

- [x] Task 1: Support drag from Today to Upcoming with cross-tab hover and auto-switch.
- [x] Task 2: On drop, set scheduledDate to tomorrow start and insert under Tomorrow group.
- [x] Subtask 2.1: Ensure sortOrder is recalculated for the target group.
- [x] Task 3: Confirm task is removed from Today immediately and persists in Core Data.
- [x] Task 4: Add tests for scheduledDate updates and Upcoming grouping placement.

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
- Update TodayView and UpcomingView to support cross-view drop.
- Use DateHelpers for tomorrow scheduling.
- Ensure Upcoming grouping logic handles new inserts correctly.
### Testing Requirements
- Unit tests: moving Today task to Upcoming sets scheduledDate to tomorrow and groups under Tomorrow.
- Manual QA: cross-tab drag to Upcoming with hover and drop behavior.
### Previous Story Intelligence
- Builds on 3.2 cross-tab drag; reuse tab hover/auto-switch logic and drag state propagation.
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

- Extend shared tab hover logic to target Upcoming when dragging from Today.
- Implement TaskViewModel helper to move tasks to tomorrow and recalc group sortOrder.
- Update Upcoming view drop handling to insert into Tomorrow group with animations.
- Add unit tests for tomorrow scheduling and grouping placement.

### Completion Notes List
- Added drag-to-upcoming tab hover/auto-switch support via shared drag coordinator.
- Implemented move-to-tomorrow logic with group-specific sortOrder updates and Core Data persistence.
- Updated Upcoming drop handling to place tasks under Tomorrow with Reduce Motion-aware animations.
- Tests: `xcodebuild test -project Cmpe492/Cmpe492.xcodeproj -scheme Cmpe492 -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.5' -derivedDataPath /tmp/Cmpe492DerivedData`
- Code review pass: refreshed File List to match repo changes, verified tests, and marked story done.
- Code review fix: cleared pending tab switch work item after hover-triggered switch to avoid stuck hover state.
### File List
- Cmpe492/Cmpe492/Utilities/DragCoordinator.swift
- Cmpe492/Cmpe492/Utilities/TabBarDropDelegate.swift
- Cmpe492/Cmpe492/ViewModels/TaskViewModel.swift
- Cmpe492/Cmpe492/Views/ContentView.swift
- Cmpe492/Cmpe492/Views/UpcomingView.swift
- Cmpe492Tests/TaskViewModelTests.swift
- _bmad-output/implementation-artifacts/3-3-implement-drag-between-views-today-to-upcoming.md
- _bmad-output/implementation-artifacts/sprint-status.yaml
- Cmpe492/Cmpe492.xcodeproj/project.pbxproj
- Cmpe492/Cmpe492/Components/DatePickerSheet.swift
- Cmpe492/Cmpe492/Components/DragPreview.swift
- Cmpe492/Cmpe492/Components/TaskRow.swift
- Cmpe492/Cmpe492/Components/UndoToast.swift
- Cmpe492/Cmpe492/Utilities/DayChangeObserver.swift
- Cmpe492/Cmpe492/Utilities/PerformanceMetrics.swift
- Cmpe492/Cmpe492/Utilities/TaskListDropDelegate.swift
- Cmpe492/Cmpe492/Utilities/TaskReorderDropDelegate.swift
- Cmpe492/Cmpe492/Utilities/UndoCoordinator.swift
- Cmpe492/Cmpe492/Views/InboxView.swift
- Cmpe492/Cmpe492/Views/TodayView.swift
- Cmpe492Tests/UndoCoordinatorTests.swift
### Change Log
- 2026-02-12: Added Today-to-Upcoming drag handling, tomorrow scheduling, and tests.
- 2026-02-12: Code review pass; refreshed File List and marked story done.
- 2026-02-12: Code review fix; clear pending hover switch work item after firing.
## Completion Status

Status set to done.
- Sprint status updated for this story key.
