# Story 2.4: Filter Today View to Show Only Today's Tasks

Status: done

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->
## Story

As a user,
I want to see only tasks scheduled for today in the Today view,
so that I can focus on my current day without distraction.

## Acceptance Criteria

1. Only tasks where scheduledDate equals today's date are shown.
2. Tasks where scheduledDate is nil (Inbox) are not shown.
3. Tasks where scheduledDate is greater than today (Upcoming) are not shown.
4. Tasks where scheduledDate is earlier than today are not shown.
5. Date comparison uses start-of-day logic (time component ignored).
6. Device timezone is respected for date boundaries.
7. The filter updates automatically at midnight (date boundary transition).

## Tasks / Subtasks

- [x] Task 1: Update TodayView to use a filtered Core Data fetch for scheduledDate == today.
- [x] Subtask 1.1: Add a date-range predicate (todayStart to tomorrowStart) instead of exact timestamp match.
- [x] Task 2: Add a date-boundary refresh (e.g., observe NSCalendarDayChanged or schedule a midnight timer).
- [x] Task 3: Ensure tasks created in Today view default to scheduledDate = today.
- [x] Task 4: Add unit tests for date filtering across timezone boundaries.

### Review Follow-ups (AI)

- [x] [AI-Review][HIGH] DateHelpers.swift is tracked and included in the review. [Cmpe492/Cmpe492/Utilities/DateHelpers.swift:1]
- [x] [AI-Review][MEDIUM] Added observers for significant time change and foreground to refresh Today filtering. [Cmpe492/Cmpe492/Views/TodayView.swift:60]
- [x] [AI-Review][MEDIUM] Added deterministic refresh-default tests covering day-change logic in the view model. [Cmpe492Tests/TaskViewModelTests.swift:474]
## Dev Notes

### Developer Context
- TodayView currently shows all tasks; filtering must be moved into Core Data fetch logic.
- Date handling must be timezone-aware to avoid off-by-one-day bugs.
### Technical Requirements
- Use start-of-day boundaries for predicate comparisons.
- Keep updates responsive and avoid full reloads on every minute; only refresh on day change.
### Architecture Compliance
- Encapsulate date-range logic in a helper (Utilities/DateHelpers.swift).
- Keep view logic simple; filter in view model or fetch request.
### Library and Framework Requirements
- Foundation Calendar/Date APIs only; no third-party date libraries.
### Project Structure Notes
- Modify Cmpe492/Cmpe492/Views/TodayView.swift to use the filtered view model.
- Modify Cmpe492/Cmpe492/ViewModels/TaskViewModel.swift (or add TodayViewModel) for date filtering.
- Modify Cmpe492/Cmpe492/Utilities/DateHelpers.swift if created in Story 2.3.
### Testing Requirements
- Unit test: tasks across yesterday/today/tomorrow and timezone shifts; verify Today filter.
- Manual QA: switch device timezone and confirm Today list updates correctly.
### Previous Story Intelligence
- Previous story key prefix: 2-3-*
- No dev notes recorded yet; keep patterns consistent with prior story file layout.
### Git Intelligence Summary
- Recent commits indicate Epic 1 completion and Core Data + MVVM foundation already in place (see git log).
- Do not refactor existing TaskViewModel behavior unless required for filtering; keep changes incremental.
### Latest Tech Information
- Swift 6.2 was released on Sep 15, 2025; use the latest stable Swift toolchain available in Xcode and review Swift release notes for language changes.
- Xcode release notes list current Xcode 26.x updates; consult the latest Xcode release notes for SwiftUI and tooling changes while keeping the deployment target at iOS 15+.
- Apple's iOS 26 update page indicates the current major iOS line; ensure any APIs used are available on iOS 15 with availability checks where needed.
### Project Context Reference
- No project-context.md found in repository; use architecture, PRD, and UX spec as the authoritative context.

## References
- _bmad-output/planning-artifacts/epics.md#Epic 2: Three-View Organization System
- _bmad-output/planning-artifacts/architecture.md#Project Structure (Xcode Standard)
- _bmad-output/planning-artifacts/architecture.md#Custom Architecture Setup Required
- _bmad-output/planning-artifacts/ux-design-specification.md#Design Direction Decision
- _bmad-output/planning-artifacts/ux-design-specification.md#Component Strategy
- _bmad-output/planning-artifacts/prd.md#Functional Requirements
- Cmpe492/Cmpe492/Views/ContentView.swift
- Cmpe492/Cmpe492/Views/TodayView.swift
- Cmpe492/Cmpe492/ViewModels/TaskViewModel.swift
- Cmpe492/Cmpe492/Components/PersistentInputField.swift

## Dev Agent Record

### Agent Model Used

GPT-5 (Codex)

### Debug Log References

- 

### Implementation Plan

- Extend TaskViewModel with a today filter and day-change refresh logic.
- Update TodayView to use the today-filtered view model and refresh on calendar day changes.
- Add tests for today filtering, timezone boundaries, default scheduling, and day-change refresh.

### Completion Notes List

- Ultimate context engine analysis completed - comprehensive developer guide created
- Added today-specific filtering and day-change refresh in TaskViewModel and TodayView.
- Added today filter and timezone-boundary tests plus default scheduledDate coverage.
- Tests: `xcodebuild test -project Cmpe492/Cmpe492.xcodeproj -scheme Cmpe492 -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.5' -derivedDataPath /tmp/Cmpe492DerivedData`
- Final regression run completed before marking story ready for review.

### File List

- _bmad-output/implementation-artifacts/2-4-filter-today-view-to-show-only-todays-tasks.md
- Cmpe492/Cmpe492/Utilities/DateHelpers.swift
- Cmpe492/Cmpe492/ViewModels/TaskViewModel.swift
- Cmpe492/Cmpe492/Views/TodayView.swift
- Cmpe492Tests/TaskViewModelTests.swift
- _bmad-output/implementation-artifacts/sprint-status.yaml

### Change Log

- 2026-02-12: Added today date-range filtering and day-change refresh handling.
- 2026-02-12: Updated TodayView to use the today-filtered view model and refresh on day change.
- 2026-02-12: Added today filtering, timezone boundary, and day-change refresh unit tests.
- 2026-02-12: Added significant time change and foreground refresh handling for TodayView.
## Completion Status

- Status set to done.
- Sprint status updated for this story key.

## Senior Developer Review (AI)

**Review Date:** 2026-02-12  
**Reviewer:** GPT-5 (Adversarial Code Review)  
**Review Outcome:** ✅ **APPROVED**

### Review Summary

Found 0 issues. Git vs Story discrepancies: 0.

### Action Items

- [x] **[HIGH]** DateHelpers.swift is tracked and included.  
- [x] **[MEDIUM]** TodayView refreshes on day-change, significant time change, and app foreground.  
- [x] **[MEDIUM]** Added refresh-default tests in the view model to validate day-change behavior.  
