# Story 6.5: Display Simple Completion Trends

Status: done

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a user,
I want to see a basic comparison of this month vs last month,
so that I can see if I'm completing more or fewer tasks over time.

## Acceptance Criteria

1. Given the Analytics view is displayed
   When the view loads
   Then a "Trends" section shows
     - "X tasks this month, [up/down/same] from Y last month"
   And "this month" counts tasks completed in the current month
   And "last month" counts tasks completed in the previous month
   And if last month is higher, the message says "down from"
   And if last month is lower, the message says "up from"
   And if equal, the message says "same as"
   And if no data from last month, the message says "No data from last month"
   And the trend direction uses subtle color: green for up, red for down, gray for same
   And the query completes within 300ms

## Tasks / Subtasks

- [x] Add month comparison counts to `AnalyticsViewModel` (AC: 1)
- [x] Implement trend message formatting logic (AC: 1)
- [x] Display Trends section with subtle color cues (AC: 1)
- [x] Use count-only Core Data fetch for current and previous month (AC: 1)

## Dev Notes

### Developer Context

- Trend is a simple text line, not a chart.
- Use existing month interval helpers; derive previous month via calendar date arithmetic.

### Technical Requirements

- Compute current month interval and previous month interval using `Calendar`.
- Use count-only fetches for both intervals.
- Apply color only to the trend word or indicator (subtle, non-gamified).

### Architecture Compliance

- MVVM only; view reads from ViewModel.
- Keep UI minimal and consistent with system typography.

### Library & Framework Requirements

- SwiftUI `Text` and basic color styling (`.foregroundStyle`).
- Core Data count fetch with `NSPredicate`.

### Testing Requirements

- Manual: verify trend text for up/down/same/no data cases.
- Ensure color changes match trend direction.

### Latest Tech Information (as of 2026-02-12)

- Swift 6.2 was released on 2025-09-15; prefer this toolchain where available.
- Apple lists Xcode 26.3 as the latest Xcode release with Swift 6.2.3 and iOS SDKs up to 26.2; use the latest stable Xcode supported by your macOS.
- Xcode 26.3 supports deployment targets iOS 15-26.2; keep this project at iOS 15+ as specified.

### Project Structure Notes

- `Cmpe492/Cmpe492/ViewModels/AnalyticsViewModel.swift`: add trend computation.
- `Cmpe492/Cmpe492/Views/AnalyticsView.swift`: show Trends section UI.
- `Cmpe492/Cmpe492/Utilities/DateHelpers.swift`: add previous month interval helper if needed.

### References

- `_bmad-output/planning-artifacts/epics.md` (Epic 6 → Story 6.5)
- `_bmad-output/planning-artifacts/prd.md` (FR29; NFR6)
- `_bmad-output/planning-artifacts/ux-design-specification.md` (Color system; minimal design)
- No project-context file found (pattern `**/project-context.md`)

## Dev Agent Record

### Agent Model Used

Codex (GPT-5)

### Debug Log References

- `xcodebuild test -project Cmpe492/Cmpe492.xcodeproj -scheme Cmpe492 -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.5' -derivedDataPath /tmp/Cmpe492DerivedData` (2026-02-12)
- Test results: `/tmp/Cmpe492DerivedData/Logs/Test/Test-Cmpe492-2026.02.12_23-02-46-+0300.xcresult`

### Implementation Plan

- Added previous-month interval helper and trend message logic in the view model.
- Added trend color mapping in `AnalyticsView`.
- Added unit tests for trend messages across up/down/same/no-data cases.

### Completion Notes List

- Trend message compares current month vs last month and sets direction accordingly.
- Trend text color reflects direction (green/red/secondary).
- Added unit tests for trend message edge cases (no data, up, down, same).
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

- 2026-02-12: Added monthly trend messaging and color cues in analytics.
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
