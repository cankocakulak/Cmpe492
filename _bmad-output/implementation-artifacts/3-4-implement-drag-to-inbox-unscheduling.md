# Story 3.4: Implement Drag to Inbox (Unscheduling)

Status: done

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a user,
I want to drag a task from Today or Upcoming back to Inbox,
so that I can remove scheduling and return it to the timeless holding space.

## Acceptance Criteria

1. Given I am viewing Today or Upcoming with tasks
2. When I drag a task toward the "Inbox" tab
3. Then the Inbox tab highlights as a valid drop zone
4. When I hover over Inbox tab for 500ms
5. Then the view switches to Inbox
6. When I release the task in Inbox
7. Then the task's scheduledDate is set to nil
8. And the task disappears from the original view (Today/Upcoming)
9. And the task appears in Inbox at the drop position
10. And sortOrder is recalculated
11. And changes persist immediately
12. And the task remains in Inbox until manually scheduled again

## Tasks / Subtasks

- [x] Task 1: Support drag to Inbox from Today/Upcoming with tab hover and auto-switch.
- [x] Task 2: On drop, set scheduledDate to nil and insert at drop position in Inbox.
- [x] Subtask 2.1: Recalculate sortOrder and persist updates immediately.
- [x] Task 3: Ensure task is removed from source view and appears in Inbox with animation.
- [x] Task 4: Add tests for unscheduling and cross-view move persistence.

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
- Update TodayView and UpcomingView to allow drag to Inbox.
- Modify InboxView drop handling and sortOrder insertion.
- Use TaskViewModel to clear scheduledDate (nil).
### Testing Requirements
- Unit tests: moving Today/Upcoming task to Inbox clears scheduledDate and persists.
- Manual QA: drag to Inbox with hover; verify removal from source view.
### Previous Story Intelligence
- Builds on 3.2/3.3 cross-tab drag; reuse drag coordinator and drop handling.
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

- Extend shared tab hover logic to allow Inbox as a drag target from Today/Upcoming.
- Add TaskViewModel helper to unschedule tasks into Inbox with sortOrder updates.
- Update Inbox drop handling for cross-view inserts with animations and Reduce Motion handling.
- Add unit test for unscheduling persistence and Inbox ordering.

### Completion Notes List
- Enabled Inbox tab as drag target from Today/Upcoming with shared hover/auto-switch.
- Implemented move-to-inbox logic (scheduledDate nil) with sortOrder recalculation and persistence.
- Added Inbox drop handling for cross-view inserts and animations.
- Tests: `xcodebuild test -project Cmpe492/Cmpe492.xcodeproj -scheme Cmpe492 -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.5' -derivedDataPath /tmp/Cmpe492DerivedData`
- Code review pass: refreshed File List to match repo changes, verified tests, and marked story done.
- Code review fix: cleared pending tab switch work item after hover-triggered switch to avoid stuck hover state.
### File List
- Cmpe492/Cmpe492/Utilities/DragCoordinator.swift
- Cmpe492/Cmpe492/Utilities/TabBarDropDelegate.swift
- Cmpe492/Cmpe492/ViewModels/TaskViewModel.swift
- Cmpe492/Cmpe492/Views/ContentView.swift
- Cmpe492/Cmpe492/Views/InboxView.swift
- Cmpe492Tests/TaskViewModelTests.swift
- _bmad-output/implementation-artifacts/3-4-implement-drag-to-inbox-unscheduling.md
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
- Cmpe492/Cmpe492/Views/TodayView.swift
- Cmpe492/Cmpe492/Views/UpcomingView.swift
- Cmpe492Tests/UndoCoordinatorTests.swift
### Change Log
- 2026-02-12: Added drag-to-inbox unscheduling with persistence and tests.
- 2026-02-12: Code review pass; refreshed File List and marked story done.
- 2026-02-12: Code review fix; clear pending hover switch work item after firing.
## Completion Status

Status set to done.
- Sprint status updated for this story key.
