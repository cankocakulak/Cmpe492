# Story 3.2: Implement Drag Between Views (Inbox to Today)

Status: done

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a user,
I want to drag a task from Inbox to Today to schedule it for today,
so that I can spatially move tasks through time without date pickers.

## Acceptance Criteria

1. Given I am viewing the Inbox with tasks present
2. When I long-press on a task and begin dragging
3. Then the task lifts and becomes draggable
4. When I drag toward the bottom of the screen near the tab bar
5. Then the "Today" tab highlights with blue background (0.2 opacity)
6. And visual indication shows the tab is a valid drop zone
7. When I continue dragging over the "Today" tab for 500ms
8. Then the view automatically switches to Today view
9. And the dragged task preview continues to follow my finger
10. And the Today view shows drop zones for task placement
11. When I release the task in Today view
12. Then the task is inserted at the drop position
13. And the task's scheduledDate is updated to today's date
14. And the task disappears from Inbox
15. And the task appears in Today with smooth slide-in animation
16. And sortOrder is recalculated for the new position
17. And the change persists immediately to Core Data

## Tasks / Subtasks

- [x] Task 1: Add shared drag coordinator to carry drag state across tabs.
- [x] Task 2: Highlight Today tab as valid drop zone and auto-switch after 500ms hover.
- [x] Task 3: Handle drop into Today: update scheduledDate to today and insert at drop position.
- [x] Subtask 3.1: Ensure task disappears from Inbox and appears in Today with animation.
- [x] Task 4: Add tests for scheduledDate updates and cross-view move persistence.

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
- Update Cmpe492/Cmpe492/Views/ContentView.swift to host shared drag coordinator.
- Modify InboxView and TodayView to handle cross-view drop.
- Extend TaskViewModel to update scheduledDate to today on drop.
- Add any new drag coordination types under Utilities or ViewModels.
### Testing Requirements
- Unit tests: moving Inbox task to Today updates scheduledDate to today.
- Manual QA: hover over Today tab switches after 500ms and drop inserts at position.
### Previous Story Intelligence
- Builds on 3.1 drag-reorder infrastructure; reuse DragCoordinator, drag preview, and sortOrder update helpers.
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

- Add shared drag coordinator and tab bar hover handling to carry drag state across tabs.
- Extend drop delegates to support external drops and list-level insertions; add TaskViewModel helper to move tasks to Today.
- Update Inbox/Today/Upcoming views for shared drag state, drop zones, and Reduce Motion-aware animations.
- Add unit test for cross-view move persistence and scheduledDate updates.

### Completion Notes List
- Added shared drag coordinator and tab bar drop overlay with 500ms hover auto-switch to Today.
- Implemented cross-view drop handling to move tasks from Inbox into Today with sortOrder recalculation and animations.
- Added list-level drop handling for end-of-list inserts and updated views for shared drag state/haptics.
- Tests: `xcodebuild test -project Cmpe492/Cmpe492.xcodeproj -scheme Cmpe492 -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.5' -derivedDataPath /tmp/Cmpe492DerivedData`
- Code review pass: refreshed File List to match repo changes, verified tests, and marked story done.
- Code review fix: cleared pending tab switch work item after hover-triggered switch to avoid stuck hover state.
### File List
- Cmpe492/Cmpe492.xcodeproj/project.pbxproj
- Cmpe492/Cmpe492/Utilities/DragCoordinator.swift
- Cmpe492/Cmpe492/Utilities/TabBarDropDelegate.swift
- Cmpe492/Cmpe492/Utilities/TaskListDropDelegate.swift
- Cmpe492/Cmpe492/Utilities/TaskReorderDropDelegate.swift
- Cmpe492/Cmpe492/ViewModels/TaskViewModel.swift
- Cmpe492/Cmpe492/Views/ContentView.swift
- Cmpe492/Cmpe492/Views/InboxView.swift
- Cmpe492/Cmpe492/Views/TodayView.swift
- Cmpe492/Cmpe492/Views/UpcomingView.swift
- Cmpe492Tests/TaskViewModelTests.swift
- _bmad-output/implementation-artifacts/3-2-implement-drag-between-views-inbox-to-today.md
- _bmad-output/implementation-artifacts/sprint-status.yaml
- Cmpe492/Cmpe492/Components/DatePickerSheet.swift
- Cmpe492/Cmpe492/Components/DragPreview.swift
- Cmpe492/Cmpe492/Components/TaskRow.swift
- Cmpe492/Cmpe492/Components/UndoToast.swift
- Cmpe492/Cmpe492/Utilities/DayChangeObserver.swift
- Cmpe492/Cmpe492/Utilities/PerformanceMetrics.swift
- Cmpe492/Cmpe492/Utilities/UndoCoordinator.swift
- Cmpe492Tests/UndoCoordinatorTests.swift
### Change Log
- 2026-02-12: Implemented shared drag coordination, tab hover auto-switch, and Inbox-to-Today drop handling with tests.
- 2026-02-12: Code review pass; refreshed File List and marked story done.
- 2026-02-12: Code review fix; clear pending hover switch work item after firing.
## Completion Status

Status set to done.
- Sprint status updated for this story key.
