# Story 4.7: Display Completion Count in Today View

Status: done

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a user,
I want to see a simple count of completed tasks in Today view,
so that I have immediate feedback on my daily progress.

## Acceptance Criteria

1. Given I am viewing the Today view
2. When the view is displayed
3. Then a subtle count appears at the top: "X completed today"
4. And the count uses .caption font (12pt) with Color.secondary
5. And the count appears near the view title or above the input field
6. And the count updates in real-time as tasks are completed
7. When I complete a task
8. Then the count increments immediately
9. When I uncomplete a task
10. Then the count decrements immediately
11. When no tasks are completed yet
12. Then the count shows "0 completed today" or is hidden entirely
13. And the count resets at midnight to reflect the new day
14. And the count only includes tasks with scheduledDate = today and state = completed

## Tasks / Subtasks

- [x] Task 1: Add a computed completed count for Today tasks (state = completed).
- [x] Task 2: Display the count near the Today title or above the input field using .caption + Color.secondary.
- [x] Task 3: Ensure the count updates in real time on state changes and resets on day change.
- [x] Task 4: Add unit tests for count updates when completing/uncompleting tasks.

## Dev Notes

### Developer Context
- TodayView is a `VStack` with `PersistentInputField` and `List`; there is room to insert a small caption above the list or between the title and input field.
- The Today filter already scopes tasks to today via `scheduledDate` predicate in `TaskViewModel`.
- `DayChangeObserver` triggers `refreshForNewDay()` and can be used to reset the count naturally.
### Technical Requirements
- Count must be derived from Today tasks only (`scheduledDate` within today) and `state = completed`.
- Updates should be instantaneous on state changes (NFR3).
- Use system typography and colors; no custom styling.
### Architecture Compliance
- Compute count in ViewModel or as a derived value from `tasks` to avoid duplicate fetches.
- Keep view logic minimal; render the count but avoid business logic in the view body.
### Library and Framework Requirements
- SwiftUI (Text, .font(.caption), Color.secondary)
### Project Structure Notes
- Update `Cmpe492/Cmpe492/Views/TodayView.swift` to render the completion count.
- Optionally add a computed property in `Cmpe492/Cmpe492/ViewModels/TaskViewModel.swift` (e.g., `completedTodayCount`).
### Testing Requirements
- Unit tests for count changes when tasks complete/uncomplete in Today filter.
- Manual QA: verify count placement, styling, and midnight reset via `DayChangeObserver`.
### Previous Story Intelligence
- Story 4.4 keeps completed tasks visible in Today; the count should reflect those tasks.
- Story 4.5 ensures `completedAt` is set/cleared correctly; use state + today filter to compute the count.

### Git Intelligence Summary
- TodayView already includes list overlays and drag/drop; keep the count view lightweight to avoid layout regressions.
- Use existing `DayChangeObserver` refresh flow to reset counts at midnight.

### Latest Tech Information
- Swift.org lists Swift 6.3 toolchains (Jan 29, 2026). Use the Swift toolchain bundled with your chosen Xcode, and verify language changes before adopting new syntax/features.
- Xcode Cloud release notes list Xcode 26.2 as available; App Store Connect release notes (Feb 3, 2026) accept uploads built with Xcode 26.3 RC and the iOS 26.2 SDK.
- Apple’s upcoming requirements indicate that, starting Apr 28, 2026, App Store uploads must use Xcode 26+ and the iOS 26 SDK.
- iOS & iPadOS 26.1 release notes are available for SDK-level changes; keep deployment target at iOS 15+ and guard newer APIs with availability checks.

### Project Context Reference
- No `project-context.md` found in repository; use architecture, PRD, and UX spec as authoritative context.

## References
- _bmad-output/planning-artifacts/epics.md#Story 4.7: Display Completion Count in Today View
- _bmad-output/planning-artifacts/ux-design-specification.md#Typography System
- _bmad-output/planning-artifacts/ux-design-specification.md#Color System
- _bmad-output/planning-artifacts/prd.md#Data Visualization & Insights
- Cmpe492/Cmpe492/Views/TodayView.swift
- Cmpe492/Cmpe492/ViewModels/TaskViewModel.swift
- Cmpe492/Cmpe492/Utilities/DayChangeObserver.swift

## Dev Agent Record

### Agent Model Used

GPT-5 (Codex)

### Debug Log References

- `xcodebuild test -project Cmpe492/Cmpe492.xcodeproj -scheme Cmpe492 -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.5' -derivedDataPath /tmp/Cmpe492DerivedData` (2026-02-12)
- Test results: `/tmp/Cmpe492DerivedData/Logs/Test/Test-Cmpe492-2026.02.12_21-31-51-+0300.xcresult`

### Implementation Plan

- Add a computed completed-today count from the Today task list.
- Render the count in TodayView with caption styling.
- Wire day-change refresh to reset the count.
- Add tests for count updates.

### Completion Notes List

- Ultimate context engine analysis completed - comprehensive developer guide created
- Added `completedCount` in `TaskViewModel` and rendered the count in Today view with caption styling.
- Added unit test covering count updates on completion/uncompletion.
- Tests: `xcodebuild test -project Cmpe492/Cmpe492.xcodeproj -scheme Cmpe492 -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.5' -derivedDataPath /tmp/Cmpe492DerivedData`

- Code review pass: verified Epic 4 acceptance criteria and marked story done.

### File List

- _bmad-output/implementation-artifacts/4-7-display-completion-count-in-today-view.md
- Cmpe492/Cmpe492/Views/TodayView.swift
- Cmpe492/Cmpe492/ViewModels/TaskViewModel.swift
- Cmpe492Tests/TaskViewModelTests.swift
- _bmad-output/implementation-artifacts/sprint-status.yaml

### Change Log

- 2026-02-12: Added Today completion count display and test coverage.

- 2026-02-12: Code review pass; marked story done.

## Completion Status

Status set to done.
- Sprint status updated for this story key.
