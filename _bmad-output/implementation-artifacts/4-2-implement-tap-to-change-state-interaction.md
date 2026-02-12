# Story 4.2: Implement Tap-to-Change-State Interaction

Status: done

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a user,
I want to tap a task to cycle through states (Not Started → Active → Completed → Not Started),
so that I can quickly update task progress with a single tap.

## Acceptance Criteria

1. Given a task in "notStarted" state is displayed
2. When I tap on the task row
3. Then the state changes to "active" within 50ms
4. And the visual appearance updates immediately (see Story 4.3)
5. And haptic feedback occurs (light impact)
6. And the change persists to Core Data
7. Given a task in "active" state
8. When I tap on the task row
9. Then the state changes to "completed"
10. And `completedAt` timestamp is set to current time
11. And the visual appearance updates to completed style
12. And haptic feedback occurs (light impact)
13. Given a task in "completed" state
14. When I tap on the task row
15. Then the state changes back to "notStarted"
16. And `completedAt` timestamp is cleared (set to nil)
17. And the visual appearance updates to not started style
18. And users can freely cycle through states in any direction

## Tasks / Subtasks

- [x] Task 1: Add a `cycleState(for:)` (or `advanceState`) method in `TaskViewModel` to move Not Started → Active → Completed → Not Started.
  - [x] Subtask 1.1: Use `Task+Extensions` state helpers to update `state`, `updatedAt`, and `completedAt`.
- [x] Task 2: Wire `TaskRow` tap handling in Today, Inbox, and Upcoming views to call the ViewModel cycle method.
- [x] Task 3: Add light haptic feedback for each state change and respect system haptics settings.
- [x] Task 4: Add unit tests for state cycling order and persistence (including `completedAt` set/cleared).

## Dev Notes

### Developer Context
- `TaskRow` already exposes an `onTap` closure; it is currently passed as `{}` in Today/Inbox/Upcoming views.
- `TaskViewModel` currently lacks a state-cycling method; add it there to keep persistence logic centralized.
- `Task+Extensions.swift` already defines `TaskState` and helpers (`markActive`, `markCompleted`, `markNotStarted`).
### Technical Requirements
- State transitions must update UI within 50ms (NFR3); use optimistic updates.
- Keep cycle order deterministic: notStarted → active → completed → notStarted.
- Do not modify `scheduledDate` during state changes.
- Use UIImpactFeedbackGenerator(.light) and respect system haptics settings.
### Architecture Compliance
- Keep Core Data writes in the ViewModel (or service); views should only trigger intent.
- Use `Task+Extensions` helpers for state changes to avoid duplicated logic.
- Preserve MVVM boundaries and avoid view-layer persistence work.
### Library and Framework Requirements
- SwiftUI (`onTapGesture`, view updates)
- Core Data (`NSManagedObjectContext` save)
- UIKit (`UIImpactFeedbackGenerator`) for haptics
### Project Structure Notes
- Update `Cmpe492/Cmpe492/ViewModels/TaskViewModel.swift` to add state-cycling API.
- Wire `onTap` in `Cmpe492/Cmpe492/Views/TodayView.swift`, `InboxView.swift`, and `UpcomingView.swift`.
- Keep `Cmpe492/Cmpe492/Components/TaskRow.swift` minimal (just invokes the `onTap` closure).
### Testing Requirements
- Unit tests for cycle order and persistence in `Cmpe492Tests/TaskViewModelTests.swift`.
- Verify `completedAt` set/cleared and `updatedAt` updated on each tap.
- Manual QA: tap to cycle in Inbox/Today/Upcoming and confirm visual updates and haptics.
### Previous Story Intelligence
- Story 4.1 established the canonical `TaskState` values (`notStarted`, `active`, `completed`) and model helpers in `Task+Extensions`.
- Ensure `isNotStarted` exists alongside `isActive`/`isCompleted` and reuse `markActive/markCompleted/markNotStarted` for state changes.
### Git Intelligence Summary
- Recent commits ("epic 3", "continue") heavily modified `TaskRow`, `TaskViewModel`, and view files; follow existing patterns rather than refactoring.
- Drag-and-drop infrastructure (`DragCoordinator`, drop delegates, undo) is already in place; avoid interfering with drag state while adding tap handling.
### Latest Tech Information
- Swift.org lists Swift 6.3 toolchains (Jan 29, 2026). Use the Swift toolchain bundled with your chosen Xcode, and verify language changes before adopting new syntax/features.
- Xcode Cloud release notes list Xcode 26.2 as available; App Store Connect release notes (Feb 3, 2026) accept uploads built with Xcode 26.3 RC and the iOS 26.2 SDK.
- Apple’s upcoming requirements indicate that, starting Apr 28, 2026, App Store uploads must use Xcode 26+ and the iOS 26 SDK.
- iOS & iPadOS 26.1 release notes are available for SDK-level changes; keep deployment target at iOS 15+ and guard newer APIs with availability checks.

### Project Context Reference
- No `project-context.md` found in repository; use architecture, PRD, and UX spec as authoritative context.

## References
- _bmad-output/planning-artifacts/epics.md#Story 4.2: Implement Tap-to-Change-State Interaction
- _bmad-output/planning-artifacts/architecture.md#State Management
- _bmad-output/planning-artifacts/ux-design-specification.md#State Changes
- _bmad-output/planning-artifacts/prd.md#Task State & Progress Tracking
- Cmpe492/Cmpe492/Models/Task+Extensions.swift
- Cmpe492/Cmpe492/ViewModels/TaskViewModel.swift
- Cmpe492/Cmpe492/Components/TaskRow.swift
- Cmpe492/Cmpe492/Views/TodayView.swift
- Cmpe492/Cmpe492/Views/InboxView.swift
- Cmpe492/Cmpe492/Views/UpcomingView.swift

## Dev Agent Record

### Agent Model Used

GPT-5 (Codex)

### Debug Log References

- `xcodebuild test -project Cmpe492/Cmpe492.xcodeproj -scheme Cmpe492 -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.5' -derivedDataPath /tmp/Cmpe492DerivedData` (2026-02-12)
- Test results: `/tmp/Cmpe492DerivedData/Logs/Test/Test-Cmpe492-2026.02.12_21-22-24-+0300.xcresult`

### Implementation Plan

- Add a state-cycling method in `TaskViewModel` using `Task+Extensions` helpers.
- Wire `TaskRow` taps in Today/Inbox/Upcoming to call the ViewModel.
- Add light haptics on state change and confirm accessibility behavior.
- Add unit tests for cycle order and persistence.

### Completion Notes List

- Ultimate context engine analysis completed - comprehensive developer guide created
- Added `cycleTaskState(taskID:now:)` in `TaskViewModel` to advance state in a single tap.
- Wired task row taps in Today/Inbox/Upcoming to cycle state with light haptics.
- Added unit test for state cycle order and persistence.
- Tests: `xcodebuild test -project Cmpe492/Cmpe492.xcodeproj -scheme Cmpe492 -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.5' -derivedDataPath /tmp/Cmpe492DerivedData`

- Code review pass: verified Epic 4 acceptance criteria and marked story done.

### File List

- _bmad-output/implementation-artifacts/4-2-implement-tap-to-change-state-interaction.md
- Cmpe492/Cmpe492/ViewModels/TaskViewModel.swift
- Cmpe492/Cmpe492/Views/TodayView.swift
- Cmpe492/Cmpe492/Views/InboxView.swift
- Cmpe492/Cmpe492/Views/UpcomingView.swift
- Cmpe492Tests/TaskViewModelTests.swift
- _bmad-output/implementation-artifacts/sprint-status.yaml

### Change Log

- 2026-02-12: Added tap-to-cycle state behavior in all views with haptics and tests.

- 2026-02-12: Code review pass; marked story done.

## Completion Status

Status set to done.
- Sprint status updated for this story key.
