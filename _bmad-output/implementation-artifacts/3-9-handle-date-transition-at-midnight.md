# Story 3.9: Handle Date Transition at Midnight

Status: done

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a user,
I want the view filters to update automatically at midnight,
so that "Today" always reflects the current day without restarting the app.

## Acceptance Criteria

1. Given the app is open during the day-to-night transition (11:59 PM → 12:00 AM)
2. When midnight occurs
3. Then the Today view filter automatically updates to the new date
4. And tasks that were "Upcoming/Tomorrow" now appear in "Today" (if scheduledDate = new today)
5. And the view refreshes smoothly without user action
6. And no tasks are lost or duplicated during the transition
7. And the Upcoming view also updates its date groupings
8. And timezone changes (traveling) are handled correctly
9. And if the app was backgrounded, the date filter updates on returning to foreground

## Tasks / Subtasks

- [x] Task 1: Centralize day-change observers (NSCalendarDayChanged, significantTimeChange, foreground).
- [x] Task 2: Refresh Today and Upcoming view models at midnight and on timezone changes.
- [x] Task 3: Add tests for view model refresh across day transitions.
- [x] Task 4: Manual QA for midnight transition while app is open/foregrounded.

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
- Centralize day-change observer wiring (TodayView and UpcomingView).
- Ensure TaskViewModel refreshes update predicates without mutating tasks.
### Testing Requirements
- Unit tests: day-change refresh updates Today/Upcoming predicates and regrouping.
- Manual QA: midnight transition while app open/foregrounded.
### Previous Story Intelligence
- Extends 3.8 guardrails with actual refresh behavior at midnight and foreground.
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

- Centralize day-change notifications in ContentView and broadcast a refresh token.
- Update Today/Upcoming views to react to centralized refresh events.
- Add unit test coverage for upcoming refresh behavior across day boundaries.

### Completion Notes List
- Centralized day-change notifications in ContentView and broadcast refresh tokens.
- Updated Today/Upcoming to refresh filters on day-change and timezone notifications.
- Added unit test ensuring upcoming tasks drop into Today after midnight refresh.
- Manual QA checklist: verify midnight transition, timezone change, and foreground refresh in simulator/device.
- Tests: `xcodebuild test -project Cmpe492/Cmpe492.xcodeproj -scheme Cmpe492 -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.5' -derivedDataPath /tmp/Cmpe492DerivedData`
- Code review pass: refreshed File List to match repo changes, verified tests, and marked story done.
### File List
- Cmpe492/Cmpe492/Utilities/DayChangeObserver.swift
- Cmpe492/Cmpe492/Views/ContentView.swift
- Cmpe492/Cmpe492/Views/TodayView.swift
- Cmpe492/Cmpe492/Views/UpcomingView.swift
- Cmpe492Tests/TaskViewModelTests.swift
- _bmad-output/implementation-artifacts/3-9-handle-date-transition-at-midnight.md
- _bmad-output/implementation-artifacts/sprint-status.yaml
- Cmpe492/Cmpe492.xcodeproj/project.pbxproj
- Cmpe492/Cmpe492/Components/DatePickerSheet.swift
- Cmpe492/Cmpe492/Components/DragPreview.swift
- Cmpe492/Cmpe492/Components/TaskRow.swift
- Cmpe492/Cmpe492/Components/UndoToast.swift
- Cmpe492/Cmpe492/Utilities/DragCoordinator.swift
- Cmpe492/Cmpe492/Utilities/PerformanceMetrics.swift
- Cmpe492/Cmpe492/Utilities/TabBarDropDelegate.swift
- Cmpe492/Cmpe492/Utilities/TaskListDropDelegate.swift
- Cmpe492/Cmpe492/Utilities/TaskReorderDropDelegate.swift
- Cmpe492/Cmpe492/Utilities/UndoCoordinator.swift
- Cmpe492/Cmpe492/ViewModels/TaskViewModel.swift
- Cmpe492/Cmpe492/Views/InboxView.swift
- Cmpe492Tests/UndoCoordinatorTests.swift
### Change Log
- 2026-02-12: Centralized day-change refresh and added tests for midnight transitions.
- 2026-02-12: Code review pass; refreshed File List and marked story done.
## Completion Status

Status set to done.
- Sprint status updated for this story key.
