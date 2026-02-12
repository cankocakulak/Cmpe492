# Story 1.9: Ensure Data Persistence Across App Launches

Status: ready-for-dev

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a user,
I want my tasks to survive app restarts and device reboots,
So that my data is reliable and I can trust the system.


## Acceptance Criteria
**Given** I have created multiple tasks and closed the app
**When** I force quit the app via the app switcher
**Then** all tasks remain saved in Core Data
**When** I reopen the app
**Then** all previously created tasks are loaded and displayed
**And** tasks appear in the same order as before closing
**And** task data is complete (text, dates, states all correct)
**And** the load happens within the 1 second app launch time budget
**Given** the device is rebooted
**When** I reopen the app after reboot
**Then** all tasks are still present with correct data
**And** Core Data file integrity is maintained


## Tasks / Subtasks
- [ ] Verify TaskViewModel fetch is called on app start.
- [ ] Ensure list renders in sortOrder sequence after relaunch.
- [ ] Validate app launch time remains under 1 second.

## Dev Notes

### Developer Context

- Ensure tasks persist across app restarts and device reboots.
- Load tasks on app launch in the same order as before.
- Keep launch time under 1 second.

### Technical Requirements

- Fetch tasks on app launch with sortOrder as primary sort key.
- Ensure fetch is efficient (use batch size if needed).
- Preserve order and data integrity after force quit and relaunch.

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

- Manual test: create tasks, force quit, relaunch; tasks load in same order.
- Manual test: reboot device/simulator and verify tasks persist.


### Previous Story Intelligence (1.8)

- Build on Story 1.8 output in `1-8-implement-immediate-data-persistence.md`.
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
- Previous story: 1.8 (1-8-implement-immediate-data-persistence).
- Next story: 1.10 (see epics.md).


### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story-1.9-Ensure-Data-Persistence-Across-App-Launches]
- [Source: _bmad-output/planning-artifacts/architecture.md]
- [Source: _bmad-output/planning-artifacts/prd.md]
- [Source: _bmad-output/planning-artifacts/ux-design-specification.md]
- [Source: _bmad-output/implementation-artifacts/1-8-implement-immediate-data-persistence.md]
- [Source: Apple Developer Documentation - Setting up Core Data with CloudKit]
- [Source: Apple Developer Documentation - Xcode 15.4 Release Notes]
- [Source: swift.org - Install Swift]


## Dev Agent Record

### Agent Model Used

Codex (GPT-5)

### Debug Log References

N/A

### Completion Notes List

- Ultimate context engine analysis completed - comprehensive developer guide created.
- Status set to ready-for-dev.

### File List

- Cmpe492/Cmpe492/ViewModels/TaskViewModel.swift (update)
- Cmpe492/Cmpe492/Views/TodayView.swift (update)
