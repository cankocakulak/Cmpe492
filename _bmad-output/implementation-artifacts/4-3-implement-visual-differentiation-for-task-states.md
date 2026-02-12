# Story 4.3: Implement Visual Differentiation for Task States

Status: done

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a user,
I want to see clear visual differences between task states,
so that I can instantly understand task progress at a glance.

## Acceptance Criteria

1. Given tasks exist in different states
2. When viewing the task list
3. Then "notStarted" tasks display as:
   - Text color: Color.primary
   - Opacity: 1.0
   - Background: transparent
   - Text decoration: none
   - Font weight: regular
4. Then "active" tasks display as:
   - Text color: Color.blue (accent)
   - Background: Color.blue with 0.1 opacity
   - Opacity: 1.0
   - Text decoration: none
   - Font weight: regular (or semibold if needed)
5. Then "completed" tasks display as:
   - Text color: Color.secondary
   - Opacity: 0.5
   - Text decoration: strikethrough
   - Background: transparent
6. And all three states are immediately comprehensible without explanation
7. And state differentiation works in both light and dark mode
8. And state differentiation is accessible (multiple cues, not just color)
9. And transitions between states animate smoothly (200ms, .easeInOut)

## Tasks / Subtasks

- [x] Task 1: Update `TaskRow` to style each state with the required colors, opacity, and strikethrough.
  - [x] Subtask 1.1: Apply active background tint (Color.blue.opacity(0.1)) without breaking list row styling.
- [x] Task 2: Add 200ms easeInOut animations for state transitions; respect Reduce Motion.
- [x] Task 3: Validate accessibility cues (strikethrough + opacity) and dark mode behavior.
- [x] Task 4: Manual QA in light/dark mode and with Reduce Motion enabled.

## Dev Notes

### Developer Context
- `TaskRow` currently renders all tasks with `Color.primary` and no state-based styling.
- Task state is available via `Task+Extensions` (`stateValue`, `isActive`, `isCompleted`).
- The row is reused across Inbox/Today/Upcoming, so styling changes apply app-wide.
### Technical Requirements
- Use iOS system colors only (`Color.primary`, `Color.secondary`, `Color.blue`).
- Ensure state changes render within 50ms and animate over 200ms (NFR3 + UX spec).
- Respect `accessibilityReduceMotion` by disabling animations when enabled.
- Maintain minimum 44pt row height and existing insets.
### Architecture Compliance
- Keep visual styling isolated to `TaskRow` (no state styling scattered across views).
- Avoid custom color palettes or fonts; adhere to system typography and colors.
- Ensure accessibility cues do not rely on color alone (strikethrough + opacity).
### Library and Framework Requirements
- SwiftUI (Text, .foregroundStyle, .background, .strikethrough, animations)
### Project Structure Notes
- Update `Cmpe492/Cmpe492/Components/TaskRow.swift` for state-based styling.
- If introducing shared constants, add to `Cmpe492/Cmpe492/Utilities/DesignTokens.swift` (only if necessary; prefer local constants).
### Testing Requirements
- Manual QA in light/dark mode: verify color/opacity/strikethrough for each state.
- Verify Reduce Motion disables animations.
- Spot-check accessibility: strikethrough + opacity for completed, tint + background for active.
### Previous Story Intelligence
- Story 4.2 wires tap-to-cycle state; ensure visual changes update immediately on state change.
- Story 4.1 defines canonical `TaskState` values and helper methods; style based on those values.
### Git Intelligence Summary
- Recent commits added drag visuals and TaskRow updates; keep styling changes localized to avoid impacting drag previews.
- Follow existing list row insets and separator usage in Today/Inbox/Upcoming views.
### Latest Tech Information
- Swift.org lists Swift 6.3 toolchains (Jan 29, 2026). Use the Swift toolchain bundled with your chosen Xcode, and verify language changes before adopting new syntax/features.
- Xcode Cloud release notes list Xcode 26.2 as available; App Store Connect release notes (Feb 3, 2026) accept uploads built with Xcode 26.3 RC and the iOS 26.2 SDK.
- Apple’s upcoming requirements indicate that, starting Apr 28, 2026, App Store uploads must use Xcode 26+ and the iOS 26 SDK.
- iOS & iPadOS 26.1 release notes are available for SDK-level changes; keep deployment target at iOS 15+ and guard newer APIs with availability checks.

### Project Context Reference
- No `project-context.md` found in repository; use architecture, PRD, and UX spec as authoritative context.

## References
- _bmad-output/planning-artifacts/epics.md#Story 4.3: Implement Visual Differentiation for Task States
- _bmad-output/planning-artifacts/ux-design-specification.md#Color System
- _bmad-output/planning-artifacts/ux-design-specification.md#Typography System
- _bmad-output/planning-artifacts/ux-design-specification.md#Animation Patterns
- _bmad-output/planning-artifacts/prd.md#Task State & Progress Tracking
- Cmpe492/Cmpe492/Components/TaskRow.swift
- Cmpe492/Cmpe492/Models/Task+Extensions.swift

## Dev Agent Record

### Agent Model Used

GPT-5 (Codex)

### Debug Log References

- `xcodebuild test -project Cmpe492/Cmpe492.xcodeproj -scheme Cmpe492 -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.5' -derivedDataPath /tmp/Cmpe492DerivedData` (2026-02-12)
- Test results: `/tmp/Cmpe492DerivedData/Logs/Test/Test-Cmpe492-2026.02.12_21-24-56-+0300.xcresult`

### Implementation Plan

- Add state-based styling in `TaskRow` for notStarted/active/completed.
- Apply 200ms easeInOut animations with Reduce Motion fallback.
- Validate accessibility cues and dark mode behavior.

### Completion Notes List

- Ultimate context engine analysis completed - comprehensive developer guide created
- Added state-based styling in `TaskRow` (colors, opacity, active background tint) with 200ms animations.
- Implemented iOS 15-compatible strikethrough fallback using overlay for completed tasks.
- Tests: `xcodebuild test -project Cmpe492/Cmpe492.xcodeproj -scheme Cmpe492 -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.5' -derivedDataPath /tmp/Cmpe492DerivedData`

- Code review pass: verified Epic 4 acceptance criteria and marked story done.

### File List

- _bmad-output/implementation-artifacts/4-3-implement-visual-differentiation-for-task-states.md
- Cmpe492/Cmpe492/Components/TaskRow.swift
- _bmad-output/implementation-artifacts/sprint-status.yaml

### Change Log

- 2026-02-12: Added state-based row styling with animations and iOS 15 strikethrough fallback.

- 2026-02-12: Code review pass; marked story done.

## Completion Status

Status set to done.
- Sprint status updated for this story key.
