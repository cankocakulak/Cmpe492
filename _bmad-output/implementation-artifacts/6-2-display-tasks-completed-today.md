# Story 6.2: Display Tasks Completed Today

Status: done

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a user,
I want to see the count of tasks I completed today,
so that I have immediate feedback on my daily productivity.

## Acceptance Criteria

1. Given the Analytics view is displayed
   When the view loads
   Then a "Today" section shows "X tasks completed today"
   And the count is accurate (tasks where state = completed and completedAt is today)
   And the count updates in real-time if I complete more tasks
   And the section uses Color.primary for the number
   And the query completes within 100ms
2. When no tasks are completed today
   Then the count shows "0 tasks completed today"
   And the message is neutral

## Tasks / Subtasks

- [x] Add Today count to `AnalyticsViewModel` using a date-range predicate (AC: 1, 2)
- [x] Display Today section in `AnalyticsView` with `.title3` header and `.body` value (AC: 1)
- [x] Ensure updates propagate when tasks change (AC: 1)
- [x] Keep query under 100ms using count-only Core Data fetch (AC: 1)

## Dev Notes

### Developer Context

- Completed tasks already store `completedAt` (Story 4.5).
- Analytics view will be new; keep it lightweight and read-only.

### Technical Requirements

- Use `Calendar.current` with a start-of-day and end-of-day range based on device timezone.
- Query only completed tasks (`state == completed`) with `completedAt` in today range.
- Use count fetch (`resultType = .countResultType`) to avoid loading full entities.

### Architecture Compliance

- MVVM only: `AnalyticsView` reads from `AnalyticsViewModel`.
- Keep Core Data access inside ViewModel (or a small AnalyticsService if introduced).

### Library & Framework Requirements

- SwiftUI `Text` and `Section` for UI.
- Core Data `NSFetchRequest` with `NSPredicate` and count result type.

### Testing Requirements

- Manual: complete tasks and verify Today count updates without app relaunch.
- Verify count is 0 when no completed tasks exist today.

### Latest Tech Information (as of 2026-02-12)

- Swift 6.2 was released on 2025-09-15; prefer this toolchain where available.
- Apple lists Xcode 26.3 as the latest Xcode release with Swift 6.2.3 and iOS SDKs up to 26.2; use the latest stable Xcode supported by your macOS.
- Xcode 26.3 supports deployment targets iOS 15-26.2; keep this project at iOS 15+ as specified.

### Project Structure Notes

- `Cmpe492/Cmpe492/ViewModels/AnalyticsViewModel.swift`: add today count query.
- `Cmpe492/Cmpe492/Views/AnalyticsView.swift`: show Today section UI.
- `Cmpe492/Cmpe492/Utilities/DateHelpers.swift`: add helper for start/end of day if needed.

### References

- `_bmad-output/planning-artifacts/epics.md` (Epic 6 → Story 6.2)
- `_bmad-output/planning-artifacts/architecture.md` (Analytics module; Core Data patterns)
- `_bmad-output/planning-artifacts/prd.md` (FR26; NFR6)
- No project-context file found (pattern `**/project-context.md`)

## Dev Agent Record

### Agent Model Used

Codex (GPT-5)

### Debug Log References

- `xcodebuild test -project Cmpe492/Cmpe492.xcodeproj -scheme Cmpe492 -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.5' -derivedDataPath /tmp/Cmpe492DerivedData` (2026-02-12)
- Test results: `/tmp/Cmpe492DerivedData/Logs/Test/Test-Cmpe492-2026.02.12_23-02-46-+0300.xcresult`

### Implementation Plan

- Added day interval helper and count query for today completions.
- Displayed Today section value in `AnalyticsView`.
- Added unit test validating today count by completedAt range.

### Completion Notes List

- Today count uses `DateHelpers.dayInterval` and count-only fetch for completed tasks.
- Analytics view displays "X tasks completed today" in the Today section.
- Added unit test for today count range filtering.
- Tests: `xcodebuild test -project Cmpe492/Cmpe492.xcodeproj -scheme Cmpe492 -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.5' -derivedDataPath /tmp/Cmpe492DerivedData`
- Review fixes: added analytics performance instrumentation, added refresh tests, and reconciled file list.

### File List

- `Cmpe492/Cmpe492/Components/TaskRow.swift`
- `Cmpe492/Cmpe492/Utilities/DateHelpers.swift`
- `Cmpe492/Cmpe492/Utilities/DragCoordinator.swift`
- `Cmpe492/Cmpe492/Utilities/TabBarDropDelegate.swift`
- `Cmpe492/Cmpe492/ViewModels/TaskViewModel.swift`
- `Cmpe492/Cmpe492/Views/ContentView.swift`
- `Cmpe492/Cmpe492/Views/InboxView.swift`
- `Cmpe492/Cmpe492/Views/TodayView.swift`
- `Cmpe492/Cmpe492/Views/UpcomingView.swift`
- `Cmpe492/Cmpe492/ViewModels/AnalyticsViewModel.swift`
- `Cmpe492/Cmpe492/Views/AnalyticsView.swift`
- `Cmpe492Tests/ContentViewTests.swift`
- `Cmpe492Tests/TaskViewModelTests.swift`
- `Cmpe492Tests/AnalyticsViewModelTests.swift`
- `_bmad-output/implementation-artifacts/5-1-implement-swipe-to-delete-gesture.md`
- `_bmad-output/implementation-artifacts/5-2-implement-full-swipe-to-delete.md`
- `_bmad-output/implementation-artifacts/5-3-handle-delete-operation-errors.md`
- `_bmad-output/implementation-artifacts/5-4-ensure-delete-works-consistently-across-all-views.md`
- `_bmad-output/implementation-artifacts/6-1-create-analytics-view-structure.md`
- `_bmad-output/implementation-artifacts/6-2-display-tasks-completed-today.md`
- `_bmad-output/implementation-artifacts/6-3-display-tasks-completed-this-week.md`
- `_bmad-output/implementation-artifacts/6-4-display-tasks-completed-this-month.md`
- `_bmad-output/implementation-artifacts/6-5-display-simple-completion-trends.md`
- `_bmad-output/implementation-artifacts/6-6-implement-efficient-analytics-queries.md`
- `_bmad-output/implementation-artifacts/6-7-maintain-historical-completion-data.md`
- `_bmad-output/implementation-artifacts/6-8-handle-edge-cases-in-analytics.md`
- `_bmad-output/implementation-artifacts/sprint-status.yaml`

### Change Log

- 2026-02-12: Added today completion count and analytics view display.
- 2026-02-12: Code review fixes - added analytics performance instrumentation and refresh tests; updated file list.

## Senior Developer Review (AI)

**Review Date:** 2026-02-12  **Reviewer:** GPT-5 (Adversarial Code Review)  **Review Outcome:** ✅ **APPROVED**

### Review Summary

Found 3 issues. Git vs Story discrepancies: 1. All issues fixed.

### Action Items

- [x] **[MEDIUM]** Added analytics refresh performance instrumentation via `PerformanceMetrics`.
- [x] **[MEDIUM]** Added refresh-after-context-change test coverage for analytics counts.
- [x] **[MEDIUM]** Story File List updated to reflect current git changes.

## Completion Status

Status set to done.
- Sprint status updated for this story key.
