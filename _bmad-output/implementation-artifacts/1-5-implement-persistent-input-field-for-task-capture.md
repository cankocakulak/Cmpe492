# Story 1.5: Implement Persistent Input Field for Task Capture

Status: done

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a user,
I want to see a persistent input field at the top of the Today view,
So that I can quickly capture new tasks without extra navigation.


## Acceptance Criteria
**Given** the Today view is displayed
**When** the view appears
**Then** a TextField is visible at the top with placeholder "What needs to be done?"
**And** the TextField automatically gains focus with keyboard appearing
**And** the TextField uses .body font (17pt, San Francisco)
**And** the TextField uses standard iOS styling (.textFieldStyle(.plain))
**And** the TextField has 16pt horizontal padding and 12pt vertical padding
**And** tapping the TextField (if focus lost) brings keyboard back immediately
**And** the TextField remains visible while scrolling the task list below


## Tasks / Subtasks
- [x] Create `Components/PersistentInputField.swift`.
- [x] Integrate PersistentInputField into TodayView above the list.
- [x] Ensure keyboard focuses on appear and returns on tap.

## Dev Notes

### Developer Context

- Add a persistent input field at the top of Today view.
- Keep input visible while the list scrolls.
- No task creation logic yet; this is UI-only.

### Technical Requirements

- Create a `PersistentInputField` component using SwiftUI `TextField`.
- Placeholder text: "What needs to be done?" with `.body` font.
- Apply `.textFieldStyle(.plain)` and padding: 16pt horizontal, 12pt vertical.
- Auto-focus on appear using `@FocusState`; tapping re-focuses.
- Place input above the list so it remains visible while scrolling.

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
- `Cmpe492/Cmpe492/Components/PersistentInputField.swift` (new)
- `Cmpe492/Cmpe492/Views/TodayView.swift` (update)


### Testing Requirements

- Manual test: input field auto-focuses on view appear.
- Manual test: input field stays visible while list scrolls.


### Previous Story Intelligence (1.4)

- Build on Story 1.4 output in `1-4-build-basic-today-view-with-task-list.md`.
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
- Previous story: 1.4 (1-4-build-basic-today-view-with-task-list).
- Next story: 1.6 (see epics.md).


### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story-1.5-Implement-Persistent-Input-Field-for-Task-Capture]
- [Source: _bmad-output/planning-artifacts/architecture.md]
- [Source: _bmad-output/planning-artifacts/prd.md]
- [Source: _bmad-output/planning-artifacts/ux-design-specification.md]
- [Source: _bmad-output/implementation-artifacts/1-4-build-basic-today-view-with-task-list.md]
- [Source: Apple Developer Documentation - Setting up Core Data with CloudKit]
- [Source: Apple Developer Documentation - Xcode 15.4 Release Notes]
- [Source: swift.org - Install Swift]


## Dev Agent Record

### Agent Model Used

Codex (GPT-5)

### Debug Log References

N/A

### Completion Notes List

- Implemented PersistentInputField with placeholder, styling, padding, and focus management (explicit tap-to-refocus).
- Integrated input field at the top of TodayView above the task list.
- Manual focus/scroll behavior verified on device/simulator.

### File List

- `Cmpe492/Cmpe492/Components/PersistentInputField.swift` (new)
- `Cmpe492/Cmpe492/Views/TodayView.swift` (update)
