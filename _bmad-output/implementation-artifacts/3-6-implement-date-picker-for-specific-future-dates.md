# Story 3.6: Implement Date Picker for Specific Future Dates

Status: done

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a user,
I want to assign a specific future date to a task beyond tomorrow,
so that I can schedule tasks for exact dates without dragging through many days.

## Acceptance Criteria

1. Given I am viewing a task in any view
2. When I tap and hold on a task (long press) for 1 second without dragging
3. Then a context menu appears with options:
4. When I select "Choose Date..."
5. Then an iOS native date picker appears
6. And the date picker defaults to tomorrow's date
7. And the date picker allows selecting any future date
8. When I select a date and tap "Done"
9. Then the task's scheduledDate is updated to the selected date
10. And the task moves to the appropriate view (Today if today, Upcoming if future)
11. And the task appears under the correct date group in Upcoming
12. And changes persist immediately
13. When I select "Cancel" on the context menu or date picker
14. Then no changes occur and the menu dismisses

## Tasks / Subtasks

- [x] Task 1: Add long-press (1s) context menu with Today/Tomorrow/Choose Date/Inbox/Cancel.
- [x] Task 2: Present native date picker for 'Choose Date...' defaulting to tomorrow.
- [x] Task 3: Update scheduledDate and move task to correct view/group on selection.
- [x] Task 4: Add tests for date selection, cancel behavior, and view placement.

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
- Update TaskRow to support long-press context menu.
- Add a shared date picker sheet (likely in ContentView or view-level).
- Extend TaskViewModel with 'moveToDate' helper.
### Testing Requirements
- Unit tests: choose date updates scheduledDate and moves to correct view.
- Manual QA: long-press context menu, date picker, cancel behavior.
### Previous Story Intelligence
- Uses drag long-press recognition; coordinate with 3.1 long-press drag to avoid gesture conflicts.
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

- Add a shared date picker sheet component and long-press schedule menu on task rows.
- Implement TaskViewModel scheduled date setter with group-aware sortOrder assignment.
- Wire context menu actions for Today/Tomorrow/Choose Date/Inbox with persistence.
- Add unit tests for scheduled date updates and upcoming group placement.

### Completion Notes List
- Added long-press schedule menu with Today/Tomorrow/Choose Date/Inbox actions and cancel.
- Implemented native date picker sheet defaulting to tomorrow with future-date selection.
- Added TaskViewModel scheduled-date helper to move tasks into correct groups.
- Tests: `xcodebuild test -project Cmpe492/Cmpe492.xcodeproj -scheme Cmpe492 -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.5' -derivedDataPath /tmp/Cmpe492DerivedData`
- Code review pass: refreshed File List to match repo changes, verified tests, and marked story done.
### File List
- Cmpe492/Cmpe492/Components/DatePickerSheet.swift
- Cmpe492/Cmpe492/ViewModels/TaskViewModel.swift
- Cmpe492/Cmpe492/Views/InboxView.swift
- Cmpe492/Cmpe492/Views/TodayView.swift
- Cmpe492/Cmpe492/Views/UpcomingView.swift
- Cmpe492Tests/TaskViewModelTests.swift
- _bmad-output/implementation-artifacts/3-6-implement-date-picker-for-specific-future-dates.md
- _bmad-output/implementation-artifacts/sprint-status.yaml
- Cmpe492/Cmpe492.xcodeproj/project.pbxproj
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
- Cmpe492Tests/UndoCoordinatorTests.swift
### Change Log
- 2026-02-12: Added long-press schedule menu, date picker sheet, and scheduled-date updates with tests.
- 2026-02-12: Code review pass; refreshed File List and marked story done.
## Completion Status

Status set to done.
- Sprint status updated for this story key.
