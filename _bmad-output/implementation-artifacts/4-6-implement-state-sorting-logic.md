# Story 4.6: Implement State Sorting Logic

Status: done

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a user,
I want tasks organized by state within each view,
so that active and incomplete tasks are prioritized over completed ones.

## Acceptance Criteria

1. Given a view contains tasks in mixed states
2. When the view is displayed
3. Then tasks are sorted in this order:
   1. "active" tasks (top)
   2. "notStarted" tasks (middle)
   3. "completed" tasks (bottom)
4. And within each state group, tasks are sorted by `sortOrder` (user-defined order)
5. And when I mark a task as active, it moves to the top section
6. And when I complete a task, it moves to the bottom section
7. And the transition animation is smooth (200ms slide animation)
8. And drag-to-reorder still works within state groups
9. And completed tasks remain visible but don't compete for attention

## Tasks / Subtasks

- [x] Task 1: Define a state sort order mapping (active=0, notStarted=1, completed=2).
- [x] Task 2: Update `TaskViewModel` to apply state ordering before publishing tasks (post-fetch sort) or via a derived sort key.
  - [x] Subtask 2.1: Keep ordering stable by `sortOrder` within each state group.
- [x] Task 3: Ensure drag-to-reorder remains within state groups (clamp or reject cross-group moves).
- [x] Task 4: Add tests for state ordering and reorder behavior within groups.

## Dev Notes

### Developer Context
- `TaskViewModel` currently sorts only by `sortOrder` and `createdAt` via Core Data fetch descriptors.
- Drag reorder uses `TaskReorderDropDelegate` and `TaskViewModel.moveTasks` based on the current `tasks` array.
- State-based grouping needs to be layered on top of existing ordering without breaking drag behavior.
### Technical Requirements
- Keep sorting efficient; avoid heavy recomputation on every render.
- Maintain smooth 200ms animations for state moves and reorders.
- Preserve 60fps drag performance by minimizing list diff churn.
- Do not change `scheduledDate` or state during reorder operations.
### Architecture Compliance
- Prefer in-memory sorting in ViewModel to avoid Core Data schema changes.
- If a persistent `stateOrder` attribute is introduced, update the data model version deliberately and document the migration.
- Keep MVVM boundaries: ViewModel prepares ordered data, views render it.
### Library and Framework Requirements
- SwiftUI (List animations)
- Core Data (fetch + persistence)
### Project Structure Notes
- Update `Cmpe492/Cmpe492/ViewModels/TaskViewModel.swift` for ordering logic.
- Review `Cmpe492/Cmpe492/Utilities/TaskReorderDropDelegate.swift` if cross-group reorders need to be constrained.
- Ensure `TaskRow` and views rely on the ordered `tasks` array.
### Testing Requirements
- Unit tests verifying order: active → notStarted → completed, with `sortOrder` inside each group.
- Unit/QA tests that drag reorder remains within state groups and persists `sortOrder` correctly.
- Manual QA: completing/activating tasks causes smooth 200ms transitions to new positions.
### Previous Story Intelligence
- Story 4.3 defines the visual treatment for each state; sorting should reinforce that completed tasks are visually de-emphasized at the bottom.
- Story 4.2 adds tap-to-cycle state; ensure the list updates immediately when state changes.

### Git Intelligence Summary
- Drag-and-drop reorder logic is already implemented; keep state sorting compatible with existing drop delegates to avoid regressions.
- Recent commits optimized drag performance; avoid introducing heavy sorting on every drag event.

### Latest Tech Information
- Swift.org lists Swift 6.3 toolchains (Jan 29, 2026). Use the Swift toolchain bundled with your chosen Xcode, and verify language changes before adopting new syntax/features.
- Xcode Cloud release notes list Xcode 26.2 as available; App Store Connect release notes (Feb 3, 2026) accept uploads built with Xcode 26.3 RC and the iOS 26.2 SDK.
- Apple’s upcoming requirements indicate that, starting Apr 28, 2026, App Store uploads must use Xcode 26+ and the iOS 26 SDK.
- iOS & iPadOS 26.1 release notes are available for SDK-level changes; keep deployment target at iOS 15+ and guard newer APIs with availability checks.

### Project Context Reference
- No `project-context.md` found in repository; use architecture, PRD, and UX spec as authoritative context.

## References
- _bmad-output/planning-artifacts/epics.md#Story 4.6: Implement State Sorting Logic
- _bmad-output/planning-artifacts/architecture.md#State Management
- _bmad-output/planning-artifacts/prd.md#Task State & Progress Tracking
- _bmad-output/planning-artifacts/ux-design-specification.md#State Visibility Without Clutter
- Cmpe492/Cmpe492/ViewModels/TaskViewModel.swift
- Cmpe492/Cmpe492/Utilities/TaskReorderDropDelegate.swift

## Dev Agent Record

### Agent Model Used

GPT-5 (Codex)

### Debug Log References

- `xcodebuild test -project Cmpe492/Cmpe492.xcodeproj -scheme Cmpe492 -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.5' -derivedDataPath /tmp/Cmpe492DerivedData` (2026-02-12)
- Test results: `/tmp/Cmpe492DerivedData/Logs/Test/Test-Cmpe492-2026.02.12_21-30-07-+0300.xcresult`

### Implementation Plan

- Add state-order mapping and sort tasks by (stateOrder, sortOrder).
- Ensure reorder logic respects state groups.
- Add unit tests for ordering and reorder behavior.

### Completion Notes List

- Ultimate context engine analysis completed - comprehensive developer guide created
- Added state-order sorting in `TaskViewModel` and applied it to fetch/refresh updates.
- Updated reorder flow to maintain state grouping and stable ordering within groups.
- Added tests for state grouping and within-group reorder behavior.
- Tests: `xcodebuild test -project Cmpe492/Cmpe492.xcodeproj -scheme Cmpe492 -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.5' -derivedDataPath /tmp/Cmpe492DerivedData`

- Clamped reorders to stay within state groups and aligned list animation to 200ms during review.
- Code review pass: verified Epic 4 acceptance criteria and marked story done.

### File List

- _bmad-output/implementation-artifacts/4-6-implement-state-sorting-logic.md
- Cmpe492/Cmpe492/ViewModels/TaskViewModel.swift
- Cmpe492/Cmpe492/Views/TodayView.swift
- Cmpe492/Cmpe492/Views/InboxView.swift
- Cmpe492/Cmpe492/Views/UpcomingView.swift
- Cmpe492Tests/TaskViewModelTests.swift
- _bmad-output/implementation-artifacts/sprint-status.yaml

### Change Log

- 2026-02-12: Implemented state-based sorting with stable within-group order and added coverage tests.
- 2026-02-12: Clamped reorders to stay within state groups and aligned list animation to 200ms.

- 2026-02-12: Code review pass; marked story done.

## Completion Status

Status set to done.
- Sprint status updated for this story key.
