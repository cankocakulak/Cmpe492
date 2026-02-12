# Story 4.4: Keep Completed Tasks Visible in Today View

Status: done

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a user,
I want completed tasks to remain visible in Today view,
so that I can see what I accomplished and feel "today wasn't wasted" validation.

## Acceptance Criteria

1. Given I complete a task in Today view
2. When the task state changes to "completed"
3. Then the task remains in the Today view list
4. And the task moves to the bottom of the list (below not started and active tasks)
5. And the task displays with completed styling (gray, strikethrough, 0.5 opacity)
6. And the task is still present after switching views and returning
7. And the task is still present after closing and reopening the app
8. And the task contributes to the daily completion count (Epic 6)
9. And completed tasks do NOT hide or archive automatically
10. And completed tasks remain visible until the day ends (midnight transition)
11. And users can still interact with completed tasks (tap to uncomplete)

## Tasks / Subtasks

- [x] Task 1: Ensure TodayView fetch/filter includes completed tasks (no state-based exclusion).
- [x] Task 2: Implement state-based sorting so completed tasks render at the bottom (see Story 4.6).
- [x] Task 3: Verify day-change refresh removes yesterday’s tasks without auto-rolling or re-scheduling.
- [x] Task 4: Add tests/QA to ensure completed tasks remain visible across app restarts and view switches.

## Dev Notes

### Developer Context
- TodayView uses `TaskViewModel(filter: .today)` with a `scheduledDate` predicate only; completed tasks are currently included by default.
- `DayChangeObserver` triggers `refreshForNewDay()` in TodayView, which updates the date predicate without modifying task dates.
- Visual styling for completed tasks is handled in Story 4.3; sorting is handled in Story 4.6.
### Technical Requirements
- Do not hide or archive completed tasks in Today view.
- Keep completed tasks interactive (tap to uncomplete).
- Ensure midnight transition removes yesterday’s tasks via date predicate refresh, not by mutating scheduledDate.
- Maintain no automatic rollover (Epic 3 requirement).
### Architecture Compliance
- Use `TaskViewModel.refreshForNewDay()` to update predicates; do not mutate scheduled dates.
- Preserve MVVM boundaries: filtering in ViewModel, presentation in TodayView.
- Keep Core Data as the source of truth for state and scheduling.
### Library and Framework Requirements
- SwiftUI (List rendering and updates)
- Core Data (predicate-based filtering)
### Project Structure Notes
- `Cmpe492/Cmpe492/Views/TodayView.swift` for list behavior and ordering.
- `Cmpe492/Cmpe492/ViewModels/TaskViewModel.swift` for predicates/sorting.
- `Cmpe492/Cmpe492/Utilities/DayChangeObserver.swift` for midnight refresh behavior.
### Testing Requirements
- Unit test: Today filter includes completed tasks and excludes non-today scheduledDate.
- Manual QA: complete a task, switch tabs, return, and verify visibility.
- Manual QA: simulate day change and verify tasks from yesterday drop off without auto-rollover.
### Previous Story Intelligence
- Story 4.3 defines completed styling (gray + strikethrough + 0.5 opacity) for Today view.
- Story 4.2 ensures tap-to-uncomplete remains available; do not disable interaction for completed tasks.

### Git Intelligence Summary
- Recent commits added day-change refresh hooks in TodayView; leverage `refreshForNewDay()` rather than introducing new day-change logic.
- Drag/drop and undo infrastructure is already integrated in TodayView; avoid regressions in list layout/ordering.

### Latest Tech Information
- Swift.org lists Swift 6.3 toolchains (Jan 29, 2026). Use the Swift toolchain bundled with your chosen Xcode, and verify language changes before adopting new syntax/features.
- Xcode Cloud release notes list Xcode 26.2 as available; App Store Connect release notes (Feb 3, 2026) accept uploads built with Xcode 26.3 RC and the iOS 26.2 SDK.
- Apple’s upcoming requirements indicate that, starting Apr 28, 2026, App Store uploads must use Xcode 26+ and the iOS 26 SDK.
- iOS & iPadOS 26.1 release notes are available for SDK-level changes; keep deployment target at iOS 15+ and guard newer APIs with availability checks.

### Project Context Reference
- No `project-context.md` found in repository; use architecture, PRD, and UX spec as authoritative context.

## References
- _bmad-output/planning-artifacts/epics.md#Story 4.4: Keep Completed Tasks Visible in Today View
- _bmad-output/planning-artifacts/architecture.md#Time & Date Handling
- _bmad-output/planning-artifacts/prd.md#Task State & Progress Tracking
- _bmad-output/planning-artifacts/ux-design-specification.md#Completed Task Visibility
- Cmpe492/Cmpe492/Views/TodayView.swift
- Cmpe492/Cmpe492/ViewModels/TaskViewModel.swift
- Cmpe492/Cmpe492/Utilities/DayChangeObserver.swift

## Dev Agent Record

### Agent Model Used

GPT-5 (Codex)

### Debug Log References

- `xcodebuild test -project Cmpe492/Cmpe492.xcodeproj -scheme Cmpe492 -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.5' -derivedDataPath /tmp/Cmpe492DerivedData` (2026-02-12)
- Test results: `/tmp/Cmpe492DerivedData/Logs/Test/Test-Cmpe492-2026.02.12_21-26-29-+0300.xcresult`

### Implementation Plan

- Confirm Today filter includes completed tasks and does not hide/archive.
- Implement state-based ordering (completed at bottom) alongside Story 4.6.
- Verify day-change refresh keeps no auto-rollover behavior.
- Add tests/QA for persistence and view-switch visibility.

### Completion Notes List

- Ultimate context engine analysis completed - comprehensive developer guide created
- Added tests confirming completed tasks remain visible in Today and that day-change refresh drops yesterday’s tasks without rollover.
- Tests: `xcodebuild test -project Cmpe492/Cmpe492.xcodeproj -scheme Cmpe492 -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.5' -derivedDataPath /tmp/Cmpe492DerivedData`

- Code review pass: verified Epic 4 acceptance criteria and marked story done.

### File List

- _bmad-output/implementation-artifacts/4-4-keep-completed-tasks-visible-in-today-view.md
- Cmpe492Tests/TaskViewModelTests.swift
- _bmad-output/implementation-artifacts/sprint-status.yaml

### Change Log

- 2026-02-12: Added Today-view tests for completed task visibility and day-change refresh behavior.

- 2026-02-12: Code review pass; marked story done.

## Completion Status

Status set to done.
- Sprint status updated for this story key.
