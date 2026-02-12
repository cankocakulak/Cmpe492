# Story 2.7: Show Empty State Messages for Each View

Status: done

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->
## Story

As a user,
I want to see helpful empty-state messages when a view has no tasks,
so that I understand what each view is for and feel encouraged to add tasks.

## Acceptance Criteria

1. Empty Inbox shows: "No tasks in Inbox. Capture ideas here without scheduling them."
2. Empty Today shows: "No tasks scheduled for today. Drag tasks from Inbox or capture new ones."
3. Empty Upcoming shows: "No upcoming tasks. Schedule tasks for tomorrow and beyond."
4. Empty state text uses .caption font (12pt) and Color.secondary.
5. Empty state message is centered in the list area.
6. Empty state messages do not prevent the input field from working.
7. Empty state messages disappear as soon as the first task is added.

## Tasks / Subtasks

- [x] Task 1: Add empty state overlays to InboxView, TodayView, and UpcomingView when task lists are empty.
- [x] Task 2: Ensure empty state text is centered and uses .caption with Color.secondary.
- [x] Task 3: Verify empty state does not intercept input or list gestures.

### Review Follow-ups (AI)

- [x] [AI-Review][MEDIUM] Added localization scaffolding via `Localizable.strings` and centralized keys in `L10n`. [Cmpe492/Cmpe492/Utilities/L10n.swift:1]
- [x] [AI-Review][MEDIUM] Manual QA confirms empty-state messages toggle correctly when tasks are added/removed. [Cmpe492/Cmpe492/Views/TodayView.swift:44]
- [x] [AI-Review][MEDIUM] Story File List updated for traceability. [Cmpe492/Cmpe492/Views/InboxView.swift:1]
## Dev Notes

### Developer Context
- Each view should own its empty state message to keep messaging accurate and localized to the context.
- Do not hide the input field; empty state should live in the list area only.
### Technical Requirements
- Use SwiftUI overlay or background to place empty state without disrupting List layout.
- Text must respect Dynamic Type and accessibility settings.
### Architecture Compliance
- Keep empty state logic simple and view-local; avoid adding it to the data layer.
### Library and Framework Requirements
- SwiftUI Text and alignment only; no custom layout frameworks.
### Project Structure Notes
- Modify Cmpe492/Cmpe492/Views/InboxView.swift, TodayView.swift, UpcomingView.swift.
### Testing Requirements
- Manual QA: verify messages appear/disappear when task lists go from empty to non-empty.
### Previous Story Intelligence
- Previous story key prefix: 2-6-*
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

- Add empty-state overlays to each view’s List when tasks are empty.
- Style messages with .caption and Color.secondary and ensure they ignore hit testing.

### Completion Notes List

- Ultimate context engine analysis completed - comprehensive developer guide created
- Added centered empty-state messages to Inbox, Today, and Upcoming list areas with .caption styling.
- Empty states ignore hit testing to preserve list/input interaction.
- Tests: `xcodebuild test -project Cmpe492/Cmpe492.xcodeproj -scheme Cmpe492 -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.5' -derivedDataPath /tmp/Cmpe492DerivedData`
- Final regression run completed before marking story ready for review.

### File List

- _bmad-output/implementation-artifacts/2-7-show-empty-state-messages-for-each-view.md
- Cmpe492/Cmpe492/Localizable.strings
- Cmpe492/Cmpe492/Utilities/L10n.swift
- Cmpe492/Cmpe492/Views/InboxView.swift
- Cmpe492/Cmpe492/Views/TodayView.swift
- Cmpe492/Cmpe492/Views/UpcomingView.swift
- _bmad-output/implementation-artifacts/sprint-status.yaml

### Change Log

- 2026-02-12: Added empty-state overlays for Inbox, Today, and Upcoming views.
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

- [x] **[MEDIUM]** Empty-state strings now use localization scaffolding via `L10n` and `Localizable.strings`.  
- [x] **[MEDIUM]** Manual QA confirms empty-state visibility toggles as tasks are added/removed.  
- [x] **[MEDIUM]** Story File List updated for traceability.  
