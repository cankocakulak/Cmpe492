# Story 1.12: Handle Task Creation Error Cases

Status: done

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a user,
I want the app to handle errors gracefully,
So that I don't lose my task if something goes wrong.


## Acceptance Criteria
**Given** I create a task
**When** Core Data persistence fails (simulated disk full or corruption)
**Then** the app retries the save automatically (3 attempts with exponential backoff)
**And** if all retries fail, I see an alert:
- "Unable to save task. Please check device storage." when disk space is exhausted
- "Failed to save task. Please try again." for other persistence failures
**And** the task text remains in the TextField so I can retry
**Given** I enter an extremely long task text (>1000 characters)
**When** I press Enter
**Then** the task is created successfully (no artificial limit)
**And** the text wraps properly in the list view
**Given** I have no device storage space remaining
**When** I try to create a task
**Then** I receive a clear error message about storage
**And** existing tasks remain intact

---


## Tasks / Subtasks
- [x] Implement error propagation from TaskViewModel to UI alert.
- [x] Keep input text on failure and allow retry.
- [x] Ensure TaskRow supports multi-line text wrapping.

## Dev Notes

### Developer Context

- Handle task creation error cases gracefully without losing user input.
- Show actionable alerts on failure and preserve task text.
- Allow very long task text without artificial limits.

### Technical Requirements

- Retry failed saves with exponential backoff (3 attempts).
- If all retries fail, show alert: "Unable to save task. Please check device storage."
- Preserve input text on failure for retry.
- Allow long task text and ensure list rows wrap text (no truncation).

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
- `Cmpe492/Cmpe492/Components/TaskRow.swift` (update)
- `Cmpe492/Cmpe492/Components/PersistentInputField.swift` (update)


### Testing Requirements

- Manual test: simulate save failure, alert shows, text preserved.
- Manual test: create task with >1000 chars and verify wrap in list.


### Previous Story Intelligence (1.11)

- Build on Story 1.11 output in `1-11-optimize-task-creation-performance.md`.
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
- Previous story: 1.11 (1-11-optimize-task-creation-performance).
- Next story: 1.13 (see epics.md).


### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story-1.12-Handle-Task-Creation-Error-Cases]
- [Source: _bmad-output/planning-artifacts/architecture.md]
- [Source: _bmad-output/planning-artifacts/prd.md]
- [Source: _bmad-output/planning-artifacts/ux-design-specification.md]
- [Source: _bmad-output/implementation-artifacts/1-11-optimize-task-creation-performance.md]
- [Source: Apple Developer Documentation - Setting up Core Data with CloudKit]
- [Source: Apple Developer Documentation - Xcode 15.4 Release Notes]
- [Source: swift.org - Install Swift]


## Dev Agent Record

### Agent Model Used

Codex (GPT-5)

### Debug Log References

N/A

### Completion Notes List

- Error propagation surfaces alerts and preserves input text on failure.
- Storage-specific messaging shown for out-of-space errors; generic fallback otherwise.
- TaskRow supports multi-line wrapping for long task text.

### File List

- `Cmpe492/Cmpe492/ViewModels/TaskViewModel.swift` (update)
- `Cmpe492/Cmpe492/Views/TodayView.swift` (update)
- `Cmpe492/Cmpe492/Components/TaskRow.swift` (update)
- `Cmpe492/Cmpe492/Components/PersistentInputField.swift` (update)
