# Story 6.3: Display Tasks Completed This Week

Status: done

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a user,
I want to see the count of tasks I completed this week,
so that I can understand my weekly rhythm and productivity patterns.

## Acceptance Criteria

1. Given the Analytics view is displayed
   When the view loads
   Then a "This Week" section shows "X tasks completed this week"
   And the count includes tasks completed from Monday-Sunday of the current week
   And the week boundary follows the device's locale settings
   And the count is accurate (completedAt within the current week)
   And the section is visually distinct from Today
   And the query completes within 200ms

## Tasks / Subtasks

- [x] Add week count to `AnalyticsViewModel` using `Calendar` week interval (AC: 1)
- [x] Display This Week section in `AnalyticsView` (AC: 1)
- [x] Ensure locale-aware week boundaries (AC: 1)
- [x] Use count-only Core Data fetch for performance (AC: 1)

## Dev Notes

### Developer Context

- Use `Calendar.current.dateInterval(of: .weekOfYear, for: Date())` to respect locale.
- Completed tasks are identified by `state == completed` and `completedAt`.

### Technical Requirements

- Use date interval start/end for the current week based on device settings.
- Avoid loading full entities; use count result type.

### Architecture Compliance

- MVVM only; Core Data access stays in ViewModel or analytics service.

### Library & Framework Requirements

- SwiftUI `Text` and `Section`.
- Core Data count fetch with `NSPredicate`.

### Testing Requirements

- Manual: complete tasks on different days and verify week count.
- Verify locale change (week starts Sunday vs Monday) changes boundaries.

### Latest Tech Information (as of 2026-02-12)

- Swift 6.2 was released on 2025-09-15; prefer this toolchain where available.
- Apple lists Xcode 26.3 as the latest Xcode release with Swift 6.2.3 and iOS SDKs up to 26.2; use the latest stable Xcode supported by your macOS.
- Xcode 26.3 supports deployment targets iOS 15-26.2; keep this project at iOS 15+ as specified.

### Project Structure Notes

- `Cmpe492/Cmpe492/ViewModels/AnalyticsViewModel.swift`: add week count query.
- `Cmpe492/Cmpe492/Views/AnalyticsView.swift`: show This Week section UI.
- `Cmpe492/Cmpe492/Utilities/DateHelpers.swift`: add helper for week interval if needed.

### References

- `_bmad-output/planning-artifacts/epics.md` (Epic 6 → Story 6.3)
- `_bmad-output/planning-artifacts/prd.md` (FR27; NFR6)
- `_bmad-output/planning-artifacts/ux-design-specification.md` (Typography system)
- No project-context file found (pattern `**/project-context.md`)

## Dev Agent Record

### Agent Model Used

Codex (GPT-5)

### Debug Log References

- `xcodebuild test -project Cmpe492/Cmpe492.xcodeproj -scheme Cmpe492 -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.5' -derivedDataPath /tmp/Cmpe492DerivedData` (2026-02-12)
- Test results: `/tmp/Cmpe492DerivedData/Logs/Test/Test-Cmpe492-2026.02.12_23-02-46-+0300.xcresult`

### Implementation Plan

- Added week interval helper and count query for weekly completions.
- Displayed This Week section value in `AnalyticsView`.
- Added unit test validating locale-aware week boundaries.

### Completion Notes List

- Week count uses `DateHelpers.weekInterval` with locale-aware week boundaries.
- Analytics view displays "X tasks completed this week" in the This Week section.
- Added unit test verifying week boundary filtering.
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

- 2026-02-12: Added locale-aware weekly completion count and display.
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
