# Story 4.5: Track Completion Timestamps

Status: done

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a user,
I want the system to record when I complete tasks,
so that future analytics can show my completion patterns over time.

## Acceptance Criteria

1. Given a task is in "notStarted" or "active" state
2. When I mark the task as "completed"
3. Then the `completedAt` timestamp is set to the current date and time
4. And the timezone of completion is recorded correctly
5. And the `updatedAt` timestamp is also updated
6. Given a completed task exists
7. When I mark it as "notStarted" or "active" again (uncomplete it)
8. Then the `completedAt` timestamp is cleared (set to nil)
9. And the `updatedAt` timestamp is updated
10. And the completion timestamp is stored with full datetime precision
11. And completion timestamps persist correctly across app restarts
12. And completion data is available for analytics queries (Epic 6)

## Tasks / Subtasks

- [x] Task 1: Ensure `markCompleted` sets `completedAt = Date()` and updates `updatedAt`.
- [x] Task 2: Ensure `markNotStarted`/`markActive` clears `completedAt` and updates `updatedAt`.
- [x] Task 3: Wire state-change flow to always persist timestamp updates to Core Data.
- [x] Task 4: Add unit tests verifying `completedAt` set/cleared and persists across fetches.

## Dev Notes

### Developer Context
- `Task+Extensions.swift` already contains `markCompleted` and `markNotStarted` helpers that update `completedAt` and `updatedAt`.
- State changes are triggered in Story 4.2; ensure those flows call the helpers and save the context.
- Core Data schema includes `completedAt` (Date, optional) for analytics in Epic 6.
### Technical Requirements
- Use `Date()` for timestamps (full datetime precision); no date-only truncation.
- Persist changes immediately; do not defer saves.
- Maintain UI responsiveness (<50ms) on completion/uncompletion.
### Architecture Compliance
- Keep timestamp logic in model helpers and ViewModel persistence layer.
- Core Data remains the single source of truth for timestamps.
- Do not introduce separate analytics storage at this stage.
### Library and Framework Requirements
- Foundation (`Date`)
- Core Data (persistence)
### Project Structure Notes
- `Cmpe492/Cmpe492/Models/Task+Extensions.swift` for timestamp helpers.
- `Cmpe492/Cmpe492/ViewModels/TaskViewModel.swift` for save/persistence flow.
### Testing Requirements
- Unit tests verifying `completedAt` set on completion and cleared on uncompletion.
- Verify timestamps persist after context save and refetch.
- Manual QA: complete/uncomplete a task and confirm timestamp changes via debug/logging.
### Previous Story Intelligence
- Story 4.2 adds tap-to-cycle state; ensure those transitions call `markCompleted`/`markNotStarted` consistently.
- Story 4.1 defines the canonical state helpers and properties; reuse them to avoid duplicated timestamp logic.

### Git Intelligence Summary
- Recent commits introduced `Task+Extensions` and expanded `TaskViewModel` tests; extend existing test suites rather than creating new ones.
- Keep persistence logic consistent with existing `saveWithRetry` patterns.

### Latest Tech Information
- Swift.org lists Swift 6.3 toolchains (Jan 29, 2026). Use the Swift toolchain bundled with your chosen Xcode, and verify language changes before adopting new syntax/features.
- Xcode Cloud release notes list Xcode 26.2 as available; App Store Connect release notes (Feb 3, 2026) accept uploads built with Xcode 26.3 RC and the iOS 26.2 SDK.
- Apple’s upcoming requirements indicate that, starting Apr 28, 2026, App Store uploads must use Xcode 26+ and the iOS 26 SDK.
- iOS & iPadOS 26.1 release notes are available for SDK-level changes; keep deployment target at iOS 15+ and guard newer APIs with availability checks.

### Project Context Reference
- No `project-context.md` found in repository; use architecture, PRD, and UX spec as authoritative context.

## References
- _bmad-output/planning-artifacts/epics.md#Story 4.5: Track Completion Timestamps
- _bmad-output/planning-artifacts/architecture.md#Core Data Schema Design
- _bmad-output/planning-artifacts/prd.md#Task State & Progress Tracking
- _bmad-output/planning-artifacts/ux-design-specification.md#State Changes
- Cmpe492/Cmpe492/Models/Task+Extensions.swift
- Cmpe492/Cmpe492/ViewModels/TaskViewModel.swift

## Dev Agent Record

### Agent Model Used

GPT-5 (Codex)

### Debug Log References

- `xcodebuild test -project Cmpe492/Cmpe492.xcodeproj -scheme Cmpe492 -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.5' -derivedDataPath /tmp/Cmpe492DerivedData` (2026-02-12)
- Test results: `/tmp/Cmpe492DerivedData/Logs/Test/Test-Cmpe492-2026.02.12_21-27-28-+0300.xcresult`

### Implementation Plan

- Confirm timestamp helper methods in `Task+Extensions`.
- Ensure ViewModel state transitions persist `completedAt` and `updatedAt`.
- Add unit tests for completion/uncompletion timestamp behavior.

### Completion Notes List

- Ultimate context engine analysis completed - comprehensive developer guide created
- Verified completion timestamps are set/cleared in `Task+Extensions` and persisted via ViewModel state updates.
- Confirmed unit tests cover `completedAt` set/cleared and persistence.
- Tests: `xcodebuild test -project Cmpe492/Cmpe492.xcodeproj -scheme Cmpe492 -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.5' -derivedDataPath /tmp/Cmpe492DerivedData`

- Code review pass: verified Epic 4 acceptance criteria and marked story done.

### File List

- _bmad-output/implementation-artifacts/4-5-track-completion-timestamps.md
- _bmad-output/implementation-artifacts/sprint-status.yaml

### Change Log

- 2026-02-12: Verified completion timestamp behavior and tests; no code changes required.

- 2026-02-12: Code review pass; marked story done.

## Completion Status

Status set to done.
- Sprint status updated for this story key.
