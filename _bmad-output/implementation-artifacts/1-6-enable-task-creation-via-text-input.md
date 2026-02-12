# Story 1.6: Enable Task Creation via Text Input

Status: done

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a user,
I want to type a task description and press Enter to create it,
So that I can capture tasks in under 3 seconds with zero friction.


## Acceptance Criteria
**Given** the persistent input field is focused and empty
**When** I type "Review chapter 3 feedback" and press Return/Enter key
**Then** a new task is created immediately (within 100ms)
**And** the task appears in the list below the input field
**And** the task persists to Core Data with:
- UUID generated automatically
- text: "Review chapter 3 feedback"
- state: "notStarted"
- createdAt: current timestamp
- updatedAt: current timestamp
- completedAt: nil
- scheduledDate: nil (goes to Inbox by default)
- sortOrder: auto-calculated to appear last
**And** the TextField clears automatically
**And** focus remains in the TextField for rapid successive entries
**And** if the TextField is empty when Enter is pressed, nothing happens (no error)


## Tasks / Subtasks
- [x] Add create-task logic to TaskViewModel.
- [x] Wire PersistentInputField onSubmit to create task.
- [x] Ensure TextField clears and retains focus after submit.
- [x] Ensure new tasks appear at end of list using sortOrder.

## Dev Notes

### Developer Context

- Enable task creation via Enter/Return in the persistent input field.
- Must create Task in Core Data and keep input focused for rapid entry.
- Default scheduledDate = nil (Inbox).

### Technical Requirements

- On submit, call `TaskViewModel.createTask(text:)`.
- Ignore empty input (no-op).
- Assign required Task fields: `id`, `text`, `state`, `createdAt`, `updatedAt`, `sortOrder`.
- Set `completedAt = nil` and `scheduledDate = nil` (Inbox default).
- Clear TextField and keep focus after submit.

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
- `Cmpe492/Cmpe492/Components/PersistentInputField.swift` (update)
- `Cmpe492/Cmpe492/Views/TodayView.swift` (update)


### Testing Requirements

- Unit test: createTask sets required fields and persists (in-memory store).
- Manual test: Enter creates task, clears input, keeps focus.


### Previous Story Intelligence (1.5)

- Build on Story 1.5 output in `1-5-implement-persistent-input-field-for-task-capture.md`.
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
- Previous story: 1.5 (1-5-implement-persistent-input-field-for-task-capture).
- Next story: 1.7 (see epics.md).


### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story-1.6-Enable-Task-Creation-via-Text-Input]
- [Source: _bmad-output/planning-artifacts/architecture.md]
- [Source: _bmad-output/planning-artifacts/prd.md]
- [Source: _bmad-output/planning-artifacts/ux-design-specification.md]
- [Source: _bmad-output/implementation-artifacts/1-5-implement-persistent-input-field-for-task-capture.md]
- [Source: Apple Developer Documentation - Setting up Core Data with CloudKit]
- [Source: Apple Developer Documentation - Xcode 15.4 Release Notes]
- [Source: swift.org - Install Swift]


## Dev Agent Record

### Agent Model Used

Codex (GPT-5)

### Debug Log References

N/A

### Completion Notes List

- Task creation wired through TaskViewModel with required field defaults and sortOrder handling.
- PersistentInputField submit clears text and re-focuses for rapid entry.
- Unit tests cover createTask behavior; manual input/UX verification completed.

### File List

- `Cmpe492/Cmpe492/ViewModels/TaskViewModel.swift` (update)
- `Cmpe492/Cmpe492/Components/PersistentInputField.swift` (update)
- `Cmpe492/Cmpe492/Views/TodayView.swift` (update)
- `Cmpe492Tests/TaskViewModelTests.swift` (update)
