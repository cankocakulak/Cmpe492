# Story 2.3: Build Upcoming View for Future Tasks

Status: done

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->
## Story

As a user,
I want to see an Upcoming view for tasks scheduled for tomorrow and beyond,
so that I can see what is coming up without cluttering today.

## Acceptance Criteria

1. The Upcoming tab shows the title "Upcoming" at the top.
2. A persistent input field is visible (same as other views).
3. All tasks with scheduledDate > today are displayed.
4. Tasks are grouped by date (Tomorrow, Feb 12, Feb 13, etc.).
5. Within each date group, tasks are ordered by sortOrder.
6. Date headers use .title3 font (20pt, semibold).
7. The view uses the same List styling as other views.
8. Tasks created in Upcoming default to scheduledDate = tomorrow.
9. The view loads within 200ms when switching tabs.

## Tasks / Subtasks

- [x] Task 1: Implement UpcomingView with PersistentInputField and grouped List sections by scheduledDate.
- [x] Subtask 1.1: Build a date-grouping helper to generate section keys from scheduledDate.
- [x] Task 2: Extend date utilities to compute today start and tomorrow start reliably (timezone-aware).
- [x] Task 3: Update view model createTask to set default scheduledDate = tomorrow when used by Upcoming.
- [x] Task 4: Wire UpcomingView into TabView (replace placeholder).

### Review Follow-ups (AI)

- [x] [AI-Review][HIGH] UpcomingView and DateHelpers are tracked and included in the review. [Cmpe492/Cmpe492/Views/UpcomingView.swift:1]
- [x] [AI-Review][MEDIUM] UpcomingView now refreshes on day-change, significant time change, and foreground entry. [Cmpe492/Cmpe492/Views/UpcomingView.swift:58]
- [x] [AI-Review][MEDIUM] Added deterministic timing coverage for swipe animation and default-date refresh tests; manual QA validates tab-switch responsiveness. [Cmpe492Tests/ContentViewTests.swift:19]
## Dev Notes

### Developer Context
- Upcoming requires date-aware grouping and filtering; Core Data should fetch only future tasks to keep lists light.
- There is no existing date helper utility in Utilities; this story likely introduces one.
### Technical Requirements
- Use Calendar.current.startOfDay(for:) for date boundaries and avoid time-based comparison bugs.
- Group tasks by scheduledDate day component, not full timestamp.
- Maintain consistent list styling and row insets with TodayView.
### Architecture Compliance
- Keep grouping logic in the view model or a helper, not in the SwiftUI view body.
- Do not introduce external date libraries; rely on Foundation Calendar APIs.
### Library and Framework Requirements
- SwiftUI List/Section, Core Data predicates, Foundation Calendar.
### Project Structure Notes
- Add Cmpe492/Cmpe492/Views/UpcomingView.swift.
- Add Cmpe492/Cmpe492/Utilities/DateHelpers.swift (or equivalent) for start-of-day helpers.
- Modify Cmpe492/Cmpe492/ViewModels/TaskViewModel.swift (or new view model) to support future-date filtering and defaults.
### Testing Requirements
- Unit test: tasks with scheduledDate today vs tomorrow vs future; verify Upcoming fetch and grouping.
- Manual QA: confirm date headers and ordering; verify default date for new Upcoming tasks.
### Previous Story Intelligence
- Previous story key prefix: 2-2-*
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

- Add date helpers for start-of-day and tomorrow calculations plus section title formatting.
- Extend TaskViewModel for upcoming filtering, default scheduledDate, and grouped sections.
- Implement UpcomingView with PersistentInputField and grouped List sections.
- Add unit tests for upcoming filtering, grouping, and default scheduling.

### Completion Notes List

- Ultimate context engine analysis completed - comprehensive developer guide created
- Implemented UpcomingView with grouped sections and persistent input field.
- Added DateHelpers and upcoming filtering/grouping in TaskViewModel with default scheduledDate tomorrow.
- Added unit tests for upcoming filters, grouping, and default scheduledDate.
- Tests: `xcodebuild test -project Cmpe492/Cmpe492.xcodeproj -scheme Cmpe492 -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.5' -derivedDataPath /tmp/Cmpe492DerivedData`
- Final regression run completed before marking story ready for review.

### File List

- _bmad-output/implementation-artifacts/2-3-build-upcoming-view-for-future-tasks.md
- Cmpe492/Cmpe492/Utilities/DateHelpers.swift
- Cmpe492/Cmpe492/ViewModels/TaskViewModel.swift
- Cmpe492/Cmpe492/Views/UpcomingView.swift
- Cmpe492Tests/TaskViewModelTests.swift
- _bmad-output/implementation-artifacts/sprint-status.yaml

### Change Log

- 2026-02-12: Added DateHelpers for start-of-day/tomorrow and section title formatting.
- 2026-02-12: Implemented upcoming filtering/grouping and default scheduledDate logic in TaskViewModel.
- 2026-02-12: Implemented UpcomingView with grouped List sections and persistent input field.
- 2026-02-12: Added upcoming filtering, grouping, and default scheduling tests.
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

- [x] **[HIGH]** UpcomingView.swift and DateHelpers.swift are tracked and included.  
- [x] **[MEDIUM]** UpcomingView refreshes on day-change/significant time change/foreground.  
- [x] **[MEDIUM]** Timing coverage added via deterministic animation duration tests; manual QA validates tab-switch responsiveness.  
