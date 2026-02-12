# Story 1.8: Implement Immediate Data Persistence

Status: done

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a user,
I want my tasks to save automatically without any save button,
So that I never lose data and can close the app immediately after capture.


## Acceptance Criteria
**Given** I create a new task
**When** the task is submitted via Enter key
**Then** the Core Data context saves immediately (within 100ms total)
**And** optimistic UI update shows the task before persistence completes
**And** if save fails, the task is retried automatically (up to 3 attempts)
**And** if all retries fail, an alert is shown: "Failed to save task. Please try again."
**And** successful saves generate no user-facing feedback (silent success)
**And** I can immediately close the app via home button and task persists
**And** when reopening the app, the task is still present


## Tasks / Subtasks
- [x] Add save-with-retry helper in TaskViewModel.
- [x] Update createTask to use retry logic and optimistic UI.
- [x] Expose error state for UI alert in TodayView.

## Dev Notes

### Developer Context

- Ensure tasks persist immediately on creation with optimistic UI updates.
- Implement retry logic and user alert on failure.
- Silent success; visible error only on failure.

### Technical Requirements

- Save Core Data context immediately on create (target <100ms).
- Perform optimistic UI update before save completes.
- On failure, retry save up to 3 times with exponential backoff.
- If all retries fail, present alert: "Failed to save task. Please try again."

### Architecture Compliance

- Keep Core Data write logic in TaskViewModel; views call the view model only.
- Use SwiftUI native components (List, TextField) and system colors/fonts.
- Respect MVVM folder structure and iOS 15.0 deployment target.

### Library / Framework Requirements

- Swift: use the Swift toolchain bundled with Xcode; current stable Swift release is 6.2.3.
- Xcode: Xcode 15.4 release notes list the iOS 17.5 SDK; project target remains iOS 15.0.
- Core Data + CloudKit: keep NSPersistentContainer for local-only MVP; adopt NSPersistentCloudKitContainer only when sync is implemented.

### Project Structure Notes

File locations to use (create folders on disk and Xcode groups to match):
- `Cmpe492/Cmpe492/ViewModels/TaskViewModel.swift` (update)
- `Cmpe492/Cmpe492/Views/TodayView.swift` (update)


### Testing Requirements

- Unit test: retry path invoked on simulated save failure.
- Manual test: on failure, alert is shown and UI remains responsive.


### Previous Story Intelligence (1.7)

- Build on Story 1.7 output in `1-7-display-tasks-in-list-with-basic-styling.md`.
- Follow established MVVM and Core Data patterns; avoid reintroducing template code.
- Keep deployment target at iOS 15.0.


### Git Intelligence Summary

- Recent commits use conventional messages like `feat(story-1.2): ...` and `docs(story-1.2): ...`.
- Story tracking updates are committed alongside story docs in `_bmad-output/implementation-artifacts/`.
- Keep commits focused and avoid adding DerivedData or user-specific Xcode state files.


### Latest Technical Information

- Swift: Swift.org lists the current stable Swift release as 6.2.3; use the Swift toolchain bundled with Xcode for iOS builds.
- Xcode: Xcode 15.4 release notes list the iOS 17.5 SDK; this project still targets iOS 15.0 minimum.
- Core Data + CloudKit: Apple guidance uses NSPersistentCloudKitContainer only when enabling sync; otherwise keep NSPersistentContainer for local-only MVP.


### Project Context Reference

- Project: Cmpe492 (iOS SwiftUI + Core Data, MVVM).
- Epic 1 goal: instant task capture and reliable persistence.
- Previous story: 1.7 (1-7-display-tasks-in-list-with-basic-styling).
- Next story: 1.9 (see epics.md).


### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story-1.8-Implement-Immediate-Data-Persistence]
- [Source: _bmad-output/planning-artifacts/architecture.md]
- [Source: _bmad-output/planning-artifacts/prd.md]
- [Source: _bmad-output/planning-artifacts/ux-design-specification.md]
- [Source: _bmad-output/implementation-artifacts/1-7-display-tasks-in-list-with-basic-styling.md]
- [Source: Apple Developer Documentation - Setting up Core Data with CloudKit]
- [Source: Apple Developer Documentation - Xcode 15.4 Release Notes]
- [Source: swift.org - Install Swift]


## Dev Agent Record

### Agent Model Used

Codex (GPT-5)

### Debug Log References

N/A

### Completion Notes List

- Implemented save-with-retry with exponential backoff and optimistic UI (save executes on context queue).
- TodayView shows error alert when persistence fails and restores input text.
- Added test covering retry failure path and surfaced error state.

### File List

- `Cmpe492/Cmpe492/ViewModels/TaskViewModel.swift` (update)
- `Cmpe492/Cmpe492/Views/TodayView.swift` (update)
- `Cmpe492Tests/TaskViewModelTests.swift` (update)
