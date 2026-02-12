# Story 1.4: Build Basic Today View with Task List

Status: done

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a user,
I want to launch the app and see the Today view with a list of tasks,
So that I can immediately view my tasks without navigation.


## Acceptance Criteria
**Given** the app is installed on an iOS device
**When** launching the app for the first time
**Then** the Today view appears as the default screen within 1 second
**And** an empty list is displayed (since no tasks exist yet)
**And** the view title "Today" is visible at the top
**And** the interface follows iOS Human Interface Guidelines
**And** the app uses native SwiftUI List component for displaying tasks
**And** the background uses Color.systemBackground for automatic dark mode support


## Tasks / Subtasks
- [x] Create `Views/TodayView.swift` with a basic SwiftUI List.
- [x] Update `Cmpe492App.swift` to show TodayView on launch.
- [x] Ensure navigation title is visible and list is empty when no tasks exist.

## Dev Notes

### Developer Context

- Create the Today view as the default launch screen with a task list scaffold.
- Depends on MVVM scaffold from Story 1.3.
- No task creation yet; empty list is acceptable when no tasks exist.

### Technical Requirements

- Create `TodayView` with `NavigationView` and `navigationTitle("Today")`.
- Render tasks using SwiftUI `List` with `.plain` style.
- Use `Color(.systemBackground)` for the view background to support dark mode.
- Set `TodayView` as the root view in `Cmpe492App` with the managed object context injected.

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
- `Cmpe492/Cmpe492/Views/TodayView.swift` (new)
- `Cmpe492/Cmpe492/Cmpe492App.swift` (update to use TodayView)


### Testing Requirements

- Manual smoke test: launch app and verify Today view appears within 1 second.
- Verify empty list state with no crashes.


### Previous Story Intelligence (1.3)

- Build on Story 1.3 output in `1-3-create-task-model-and-mvvm-structure.md`.
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
- Previous story: 1.3 (1-3-create-task-model-and-mvvm-structure).
- Next story: 1.5 (see epics.md).


### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story-1.4-Build-Basic-Today-View-with-Task-List]
- [Source: _bmad-output/planning-artifacts/architecture.md]
- [Source: _bmad-output/planning-artifacts/prd.md]
- [Source: _bmad-output/planning-artifacts/ux-design-specification.md]
- [Source: _bmad-output/implementation-artifacts/1-3-create-task-model-and-mvvm-structure.md]
- [Source: Apple Developer Documentation - Setting up Core Data with CloudKit]
- [Source: Apple Developer Documentation - Xcode 15.4 Release Notes]
- [Source: swift.org - Install Swift]


## Dev Agent Record

### Agent Model Used

Codex (GPT-5)

### Debug Log References

N/A

### Completion Notes List

- TodayView is the default launch screen with NavigationView, title, and list scaffold.
- Background uses system background and list style is plain.
- TodayView now also hosts the persistent input field from later stories; base list scaffold remains intact.
- Manual smoke test completed on device/simulator.

### File List

- `Cmpe492/Cmpe492/Views/TodayView.swift` (new)
- `Cmpe492/Cmpe492/Cmpe492App.swift` (update)
