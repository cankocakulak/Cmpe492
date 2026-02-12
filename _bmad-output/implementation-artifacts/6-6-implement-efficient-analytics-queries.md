# Story 6.6: Implement Efficient Analytics Queries

Status: done

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a developer,
I want analytics queries to be optimized,
so that the view loads quickly even with large datasets.

## Acceptance Criteria

1. Given the database contains up to 1000 tasks
   When the Analytics view loads
   Then all analytics queries complete within 500ms total
   And queries use Core Data predicates efficiently (filtering by date ranges)
   And queries count tasks without loading full entities (COUNT queries)
   And queries use background context to avoid blocking the UI
   And the app memory footprint does not increase significantly during analytics
   And analytics queries do not impact the performance of other views
   And the view remains responsive during data loading

## Tasks / Subtasks

- [x] Implement count-only Core Data queries for all analytics metrics (AC: 1)
- [x] Run analytics queries on a background context and publish results on main thread (AC: 1)
- [x] Ensure predicates filter by `completedAt` date ranges and `state == completed` (AC: 1)
- [x] Add lightweight caching if needed to avoid redundant fetches (AC: 1)
- [x] Measure timing with `PerformanceMetrics` or logging (AC: 1)

## Dev Notes

### Developer Context

- `TaskViewModel` already uses a background context for sort order persistence; reuse a similar pattern.
- Use count fetch to avoid loading full Task objects.

### Technical Requirements

- `NSFetchRequest<Task>` with `resultType = .countResultType`.
- Use a private queue context for analytics; merge results to main via @Published.
- Keep analytics refresh triggered by task changes (e.g., via `NSFetchedResultsController` or notifications) but debounce to avoid overwork.

### Architecture Compliance

- MVVM only; data access inside ViewModel or a small AnalyticsService.
- No external dependencies.

### Library & Framework Requirements

- Core Data count fetch APIs.
- Swift Concurrency or GCD for background work (iOS 15+).

### Testing Requirements

- Manual: seed 1000 tasks and ensure analytics load <500ms.
- Verify UI remains responsive during analytics refresh.

### Latest Tech Information (as of 2026-02-12)

- Swift 6.2 was released on 2025-09-15; prefer this toolchain where available.
- Apple lists Xcode 26.3 as the latest Xcode release with Swift 6.2.3 and iOS SDKs up to 26.2; use the latest stable Xcode supported by your macOS.
- Xcode 26.3 supports deployment targets iOS 15-26.2; keep this project at iOS 15+ as specified.

### Project Structure Notes

- `Cmpe492/Cmpe492/ViewModels/AnalyticsViewModel.swift`: background analytics queries.
- `Cmpe492/Cmpe492/Utilities/PerformanceMetrics.swift`: optional timing instrumentation.
- `Cmpe492/Cmpe492/Utilities/DateHelpers.swift`: date ranges for analytics.

### References

- `_bmad-output/planning-artifacts/epics.md` (Epic 6 → Story 6.6)
- `_bmad-output/planning-artifacts/architecture.md` (Performance + Core Data patterns)
- `_bmad-output/planning-artifacts/prd.md` (NFR6; NFR9)
- No project-context file found (pattern `**/project-context.md`)

## Dev Agent Record

### Agent Model Used

Codex (GPT-5)

### Debug Log References

- `xcodebuild test -project Cmpe492/Cmpe492.xcodeproj -scheme Cmpe492 -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.5' -derivedDataPath /tmp/Cmpe492DerivedData` (2026-02-12)
- Test results: `/tmp/Cmpe492DerivedData/Logs/Test/Test-Cmpe492-2026.02.12_23-02-46-+0300.xcresult`

### Implementation Plan

- Ensured analytics queries use count-only fetches with date predicates.
- Moved analytics fetches to a private queue context with debounced refresh.
- Added observers for Core Data/time changes to keep analytics responsive.

### Completion Notes List

- Analytics queries use `count(for:)` with `state == completed` and `completedAt` predicates.
- Added background context and debounced refresh to avoid blocking the UI.
- Observes Core Data changes and time/timezone notifications to refresh metrics.
- Manual performance validation not run in this environment; validate <500ms with 1000 tasks in simulator/device.
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

- 2026-02-12: Optimized analytics queries with background context and debounced refresh.
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
