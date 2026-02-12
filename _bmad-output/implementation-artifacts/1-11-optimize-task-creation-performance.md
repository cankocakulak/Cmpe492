# Story 1.11: Optimize Task Creation Performance

Status: ready-for-dev

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a developer,
I want task creation to complete within strict performance budgets,
So that the "instant capture" user experience is maintained.


## Acceptance Criteria
**Given** the app is running on an iPhone 12 or newer
**When** a task is created
**Then** the performance metrics are:
- Keystroke to character display: <16ms (native TextField speed)
- Enter key to UI update: <100ms (optimistic update)
- Core Data persistence: <50ms (background save)
- Total user-perceived time: <100ms
**And** performance is maintained with up to 500 tasks in database
**And** memory footprint remains under 100MB during task creation
**And** no frame drops occur during task creation (60fps maintained)
**And** battery impact is negligible (<1% per 100 task creations)


## Tasks / Subtasks
- [ ] Add basic timing instrumentation around createTask and save.
- [ ] Ensure save occurs on the context queue and UI updates remain <100ms.
- [ ] Tune fetch request with batch size and appropriate sort descriptors.

## Dev Notes

### Developer Context

- Optimize task creation performance to meet strict NFR budgets.
- Add lightweight timing instrumentation for key steps.
- Ensure performance holds with 500 tasks.

### Technical Requirements

- Measure create-task timing using `os_signpost` or `Logger` timestamps.
- Avoid heavy work on main thread; use `context.perform` for saves.
- Set fetch batch size to reduce memory and improve list performance.

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
- `Cmpe492/Cmpe492/Utilities/PerformanceMetrics.swift` (new, optional)


### Testing Requirements

- Add XCTest `measure` block for createTask performance.
- Manual test with 500 tasks to confirm no frame drops.


### Previous Story Intelligence (1.10)

- Build on Story 1.10 output in `1-10-implement-rapid-succession-task-capture.md`.
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
- Previous story: 1.10 (1-10-implement-rapid-succession-task-capture).
- Next story: 1.12 (see epics.md).


### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story-1.11-Optimize-Task-Creation-Performance]
- [Source: _bmad-output/planning-artifacts/architecture.md]
- [Source: _bmad-output/planning-artifacts/prd.md]
- [Source: _bmad-output/planning-artifacts/ux-design-specification.md]
- [Source: _bmad-output/implementation-artifacts/1-10-implement-rapid-succession-task-capture.md]
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
- Cmpe492/Cmpe492/Utilities/PerformanceMetrics.swift (new, optional)
