# Story 1.7: Display Tasks in List with Basic Styling

Status: done

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a user,
I want to see my created tasks displayed in a clean, readable list,
So that I can quickly scan my tasks without visual clutter.


## Acceptance Criteria
**Given** tasks have been created
**When** viewing the Today view
**Then** each task is displayed in a List row with:
- Task text in .body font (17pt, San Francisco)
- Color.primary text color (automatic dark mode)
- 16pt horizontal padding, 12pt vertical padding
- Minimum 44pt row height (iOS touch target requirement)
- Tasks stacked vertically in order
**And** tasks are displayed in sortOrder sequence
**And** the list scrolls smoothly when tasks exceed screen height
**And** the list uses SwiftUI List component with .plain style
**And** separator lines between tasks use Color.separator (automatic dark mode)
**And** the entire row is tappable (for future state management)


## Tasks / Subtasks
- [x] Create `Components/TaskRow.swift`.
- [x] Update TodayView list to use TaskRow for each task.
- [x] Verify padding, separators, and smooth scrolling.

## Dev Notes

### Developer Context

- Render created tasks in a clean, readable list with basic styling.
- Introduce a reusable TaskRow component.
- Keep list scrolling smooth and rows fully tappable.

### Technical Requirements

- Create `TaskRow` component using `.body` font and `Color.primary`.
- Apply 16pt horizontal and 12pt vertical padding, min row height 44pt.
- Use `.listStyle(.plain)` and separators tinted with `Color(.separator)`.
- Make entire row tappable with `contentShape(Rectangle())`.

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
- `Cmpe492/Cmpe492/Components/TaskRow.swift` (new)
- `Cmpe492/Cmpe492/Views/TodayView.swift` (update)


### Testing Requirements

- Manual test: rows render with correct font, padding, and separators.
- Manual test: list scrolls smoothly with many tasks.


### Previous Story Intelligence (1.6)

- Build on Story 1.6 output in `1-6-enable-task-creation-via-text-input.md`.
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
- Previous story: 1.6 (1-6-enable-task-creation-via-text-input).
- Next story: 1.8 (see epics.md).


### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story-1.7-Display-Tasks-in-List-with-Basic-Styling]
- [Source: _bmad-output/planning-artifacts/architecture.md]
- [Source: _bmad-output/planning-artifacts/prd.md]
- [Source: _bmad-output/planning-artifacts/ux-design-specification.md]
- [Source: _bmad-output/implementation-artifacts/1-6-enable-task-creation-via-text-input.md]
- [Source: Apple Developer Documentation - Setting up Core Data with CloudKit]
- [Source: Apple Developer Documentation - Xcode 15.4 Release Notes]
- [Source: swift.org - Install Swift]


## Dev Agent Record

### Agent Model Used

Codex (GPT-5)

### Debug Log References

N/A

### Completion Notes List

- TaskRow renders task text with required font, color, padding, and tappable area.
- TodayView list uses TaskRow and separator tinting.
- List row insets are zeroed to preserve exact 16pt/12pt padding.
- Manual visual/scroll verification completed on device/simulator.

### File List

- `Cmpe492/Cmpe492/Components/TaskRow.swift` (new)
- `Cmpe492/Cmpe492/Views/TodayView.swift` (update)
- `Cmpe492Tests/TaskViewModelTests.swift` (touched in working tree; not part of Story 1.7 implementation)
