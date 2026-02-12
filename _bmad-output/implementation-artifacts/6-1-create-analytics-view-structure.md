# Story 6.1: Create Analytics View Structure

Status: done

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a user,
I want to access a separate Analytics view,
so that I can see my completion statistics without cluttering the task views.

## Acceptance Criteria

1. Given the app is open
   When I navigate to the analytics section (could be a 4th tab or accessible via button)
   Then an "Analytics" view is displayed
   And the view title "Analytics" appears at the top
   And the view uses clean, minimal design matching the rest of the app
2. The view displays statistics in a scrollable list or card layout
   And no task input field is present (this is view-only)
   And the view uses `.title3` for section headers and `.body` for data
3. The view loads within 500ms even with 1000 tasks in the database

## Tasks / Subtasks

- [x] Create `AnalyticsView` with `NavigationView` title "Analytics" and scrollable layout (AC: 1, 2)
- [x] Add `AnalyticsViewModel` placeholder for upcoming stats (AC: 2, 3)
- [x] Add sections for Today / This Week / This Month / Trends using `.title3` and `.body` (AC: 2)
- [x] Provide navigation access (4th tab preferred) and keep design minimal (AC: 1)
- [x] Keep initial loading lightweight to meet 500ms target (AC: 3)

## Dev Notes

### Developer Context

- No Analytics view exists yet; architecture expects `AnalyticsView` + `AnalyticsViewModel` in Views/ViewModels.
- `ContentView` uses `TabView` with 3 tabs and custom edge-swipe logic; adding a 4th tab requires updates to:
  - `MainTab` enum cases and tab ordering.
  - `handleSwipe` logic (edge-swipe transitions).
  - `TabBarDropOverlay`/`TabBarDropDelegate` width/offset math (currently hard-coded to 3 tabs).
  - `DragCoordinator.targetTabs` switch (new `.analytics` case should not be a drag target).
- Keep UI minimal and consistent with system typography/colors.

### Technical Requirements

- Use `NavigationView` (iOS 15+) to match existing views and show "Analytics" title.
- Layout should be a `List` or `ScrollView` with card-like sections; no input field.
- Keep initial data lightweight (placeholder values) to meet 500ms load requirement.

### Architecture Compliance

- MVVM only: view reads from `AnalyticsViewModel`, no Core Data in the view body.
- Local-only data; no networking or third-party dependencies.
- Respect existing folder structure and naming conventions.

### Library & Framework Requirements

- SwiftUI components only (`NavigationView`, `List`/`ScrollView`, `Text`, `Section`).
- System typography: `.title3` headers and `.body` values.
- System colors only (`Color.primary`, `Color.secondary`).
- Tab icon should be a SF Symbol (e.g., `chart.bar`).

### Testing Requirements

- Manual: open Analytics via navigation path; verify title, scrollable layout, no input field.
- Verify `.title3` and `.body` styling matches other views.
- Confirm view appears instantly with large datasets (no blocking fetches yet).

### Latest Tech Information (as of 2026-02-12)

- Swift 6.2 was released on 2025-09-15; prefer this toolchain where available.
- Apple lists Xcode 26.3 as the latest Xcode release with Swift 6.2.3 and iOS SDKs up to 26.2; use the latest stable Xcode supported by your macOS.
- Xcode 26.3 supports deployment targets iOS 15-26.2; keep this project at iOS 15+ as specified.

### Project Structure Notes

- `Cmpe492/Cmpe492/Views/AnalyticsView.swift`: new analytics view UI.
- `Cmpe492/Cmpe492/ViewModels/AnalyticsViewModel.swift`: placeholder view model for stats.
- `Cmpe492/Cmpe492/Views/ContentView.swift`: add analytics tab and update swipe handling.
- `Cmpe492/Cmpe492/Utilities/TabBarDropDelegate.swift`: update tab math for 4 tabs.
- `Cmpe492/Cmpe492/Utilities/DragCoordinator.swift`: add `.analytics` case handling.
- `Cmpe492/Cmpe492/Utilities/L10n.swift` + `Cmpe492/Cmpe492/Localizable.strings`: add localized strings if new UI text is introduced.

### References

- `_bmad-output/planning-artifacts/epics.md` (Epic 6 → Story 6.1)
- `_bmad-output/planning-artifacts/ux-design-specification.md` (Analytics view + typography and layout guidance)
- `_bmad-output/planning-artifacts/architecture.md` (Project Structure: AnalyticsView/AnalyticsViewModel)
- `_bmad-output/planning-artifacts/prd.md` (FR26–FR31; NFR6)
- No project-context file found (pattern `**/project-context.md`)

## Dev Agent Record

### Agent Model Used

Codex (GPT-5)

### Debug Log References

- `xcodebuild test -project Cmpe492/Cmpe492.xcodeproj -scheme Cmpe492 -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.5' -derivedDataPath /tmp/Cmpe492DerivedData` (2026-02-12)
- Test results: `/tmp/Cmpe492DerivedData/Logs/Test/Test-Cmpe492-2026.02.12_23-02-46-+0300.xcresult`

### Implementation Plan

- Added `AnalyticsView` with NavigationView title and scrollable sections.
- Introduced `AnalyticsViewModel` and wired the analytics tab into `ContentView`.
- Updated drag/swipe/tab drop handling for the fourth tab and added tab label tests.

### Completion Notes List

- Added `AnalyticsView` with "Analytics" navigation title and `.title3` section headers.
- Introduced `AnalyticsViewModel` and hooked analytics into `MainTab` in `ContentView`.
- Updated `TabBarDropDelegate` and `DragCoordinator` to handle the new tab order.
- Added `ContentViewTests` coverage for analytics tab title and symbol.
- Manual verification not run in this environment; validate analytics tab navigation in simulator/device.
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

- 2026-02-12: Added analytics view scaffolding and navigation entry in the main tab bar.
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
