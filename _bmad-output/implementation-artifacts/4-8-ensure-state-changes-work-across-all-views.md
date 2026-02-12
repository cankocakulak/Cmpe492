# Story 4.8: Ensure State Changes Work Across All Views

Status: done

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a user,
I want to mark tasks active or complete from any view (Inbox, Today, Upcoming),
so that I have consistent functionality regardless of where the task is.

## Acceptance Criteria

1. Given tasks exist in Inbox view
2. When I tap a task to cycle states
3. Then the state changes work identically to Today view
4. And completed tasks in Inbox remain visible (don't hide)
5. Given tasks exist in Upcoming view
6. When I tap a task to cycle states
7. Then the state changes work identically to other views
8. And I can mark future tasks as completed (pre-completion)
9. And I can mark future tasks as active (starting early)
10. And all state changes persist correctly regardless of view
11. And visual styling is consistent across all views
12. And completion timestamps are recorded regardless of view

## Tasks / Subtasks

- [x] Task 1: Wire tap-to-cycle in Inbox and Upcoming views (Today should already be wired by Story 4.2).
- [x] Task 2: Ensure completed tasks remain visible in Inbox and Upcoming and follow state styling.
- [x] Task 3: Verify completion timestamps are recorded regardless of view.
- [x] Task 4: Add tests for state changes in each view/filter.

## Dev Notes

### Developer Context
- Each view instantiates its own `TaskViewModel` with a filter (`inbox`, `today`, `upcoming`).
- `TaskRow` is shared across views; consistent styling comes from Story 4.3.
- State changes should be persisted in ViewModel so all FRC-backed lists update automatically.
### Technical Requirements
- State changes must persist immediately to Core Data regardless of view.
- Upcoming tasks can be marked active/completed without changing `scheduledDate`.
- Completed tasks should remain visible in Inbox/Upcoming (no state-based filters).
### Architecture Compliance
- Keep ViewModel as the single point of persistence for state changes.
- Maintain consistent MVVM patterns across view files; avoid duplicating logic.
### Library and Framework Requirements
- SwiftUI (consistent tap handling)
- Core Data (shared persistence)
### Project Structure Notes
- Update `Cmpe492/Cmpe492/Views/InboxView.swift` and `UpcomingView.swift` to call the state-cycle method.
- Ensure `Cmpe492/Cmpe492/Views/TodayView.swift` uses the same method for consistency.
- Keep all state styling in `Cmpe492/Cmpe492/Components/TaskRow.swift`.
### Testing Requirements
- Unit tests for state changes in each filter (inbox/today/upcoming) using separate `TaskViewModel` instances.
- Manual QA: tap-to-cycle in all three views and verify styling + persistence.
### Previous Story Intelligence
- Story 4.2 defines the tap-to-cycle behavior; ensure Inbox and Upcoming use the same state-cycle method.
- Story 4.3 defines visual differentiation; ensure consistent styling across all views.
- Story 4.5 ensures completion timestamps are set/cleared; verify this when state changes happen outside Today.

### Git Intelligence Summary
- Inbox and Upcoming views already include drag/drop and quick actions; keep tap handling lightweight to avoid gesture conflicts.
- TaskViewModel is shared across views; centralize state updates there to keep FRC updates consistent.

### Latest Tech Information
- Swift.org lists Swift 6.3 toolchains (Jan 29, 2026). Use the Swift toolchain bundled with your chosen Xcode, and verify language changes before adopting new syntax/features.
- Xcode Cloud release notes list Xcode 26.2 as available; App Store Connect release notes (Feb 3, 2026) accept uploads built with Xcode 26.3 RC and the iOS 26.2 SDK.
- Apple’s upcoming requirements indicate that, starting Apr 28, 2026, App Store uploads must use Xcode 26+ and the iOS 26 SDK.
- iOS & iPadOS 26.1 release notes are available for SDK-level changes; keep deployment target at iOS 15+ and guard newer APIs with availability checks.

### Project Context Reference
- No `project-context.md` found in repository; use architecture, PRD, and UX spec as authoritative context.

## References
- _bmad-output/planning-artifacts/epics.md#Story 4.8: Ensure State Changes Work Across All Views
- _bmad-output/planning-artifacts/architecture.md#State Management
- _bmad-output/planning-artifacts/ux-design-specification.md#State Changes
- _bmad-output/planning-artifacts/prd.md#Task State & Progress Tracking
- Cmpe492/Cmpe492/Views/InboxView.swift
- Cmpe492/Cmpe492/Views/TodayView.swift
- Cmpe492/Cmpe492/Views/UpcomingView.swift
- Cmpe492/Cmpe492/ViewModels/TaskViewModel.swift
- Cmpe492/Cmpe492/Components/TaskRow.swift

## Dev Agent Record

### Agent Model Used

GPT-5 (Codex)

### Debug Log References

- `xcodebuild test -project Cmpe492/Cmpe492.xcodeproj -scheme Cmpe492 -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.5' -derivedDataPath /tmp/Cmpe492DerivedData` (2026-02-12)
- Test results: `/tmp/Cmpe492DerivedData/Logs/Test/Test-Cmpe492-2026.02.12_21-33-44-+0300.xcresult`

### Implementation Plan

- Wire tap-to-cycle state in Inbox/Upcoming/Today.
- Confirm persistence and timestamp behavior across all filters.
- Add tests for multi-view state changes.

### Completion Notes List

- Ultimate context engine analysis completed - comprehensive developer guide created
- Verified state changes persist across Inbox/Today/Upcoming filters with new tests.
- Tests: `xcodebuild test -project Cmpe492/Cmpe492.xcodeproj -scheme Cmpe492 -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.5' -derivedDataPath /tmp/Cmpe492DerivedData`

- Code review pass: verified Epic 4 acceptance criteria and marked story done.

### File List

- _bmad-output/implementation-artifacts/4-8-ensure-state-changes-work-across-all-views.md
- Cmpe492Tests/TaskViewModelTests.swift
- _bmad-output/implementation-artifacts/sprint-status.yaml

### Change Log

- 2026-02-12: Added filter-level tests to confirm state changes persist in Inbox and Upcoming.

- 2026-02-12: Code review pass; marked story done.

## Completion Status

Status set to done.
- Sprint status updated for this story key.
