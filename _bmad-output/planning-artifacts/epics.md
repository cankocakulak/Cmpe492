---
stepsCompleted: ['step-01-validate-prerequisites', 'step-02-design-epics', 'step-03-create-stories', 'step-04-final-validation']
workflowCompleted: true
inputDocuments:
  - '_bmad-output/planning-artifacts/prd.md'
  - '_bmad-output/planning-artifacts/architecture.md'
  - '_bmad-output/planning-artifacts/ux-design-specification.md'
  - '_bmad-output/planning-artifacts/product-brief-Cmpe492-2026-02-11.md'
validationStatus:
  totalEpics: 7
  totalStories: 63
  allFRsCovered: true
  allNFRsAddressed: true
  noDependencyIssues: true
  implementationReady: true
date: '2026-02-11'
---

# Cmpe492 - Epic Breakdown

## Overview

This document provides the complete epic and story breakdown for Cmpe492, decomposing the requirements from the PRD, UX Design, and Architecture requirements into implementable stories.

## Requirements Inventory

### Functional Requirements

**Task Capture & Creation:**
- FR1: User can create a new task by typing text and pressing enter
- FR2: User can create tasks in under 3 seconds from app open to task saved
- FR3: User can create tasks without specifying any additional information (date, category, notes)
- FR4: User can create multiple tasks in rapid succession without navigation
- FR5: User can delete tasks they have created
- FR6: System persists all created tasks immediately upon entry

**Task Organization & Management:**
- FR7: User can view tasks organized in three separate views: Inbox, Today, and Upcoming
- FR8: User can reorder tasks within a view by dragging
- FR9: User can move tasks between views (Inbox → Today, Today → Upcoming, etc.) by dragging
- FR10: User can see all completed tasks within the Today view alongside incomplete tasks
- FR11: System maintains task order as specified by user drag operations
- FR12: User can access a persistent input field from any view for quick task capture

**Time & Schedule Management:**
- FR13: User can assign a specific date to any task
- FR14: User can move tasks to "Today" with a single action
- FR15: User can move tasks to "Tomorrow" with a single action
- FR16: User can move tasks to a future specific date via date picker
- FR17: User can move tasks to the timeless Inbox (unscheduled state)
- FR18: System does not automatically move incomplete tasks to the next day (no automatic rollover)
- FR19: User must explicitly choose which incomplete tasks to carry forward to future dates

**Task State & Progress Tracking:**
- FR20: User can mark a task as "Active" to indicate current focus
- FR21: User can mark a task as "Completed"
- FR22: User can see visual differentiation between Not Started, Active, and Completed task states
- FR23: System tracks the completion timestamp for all completed tasks
- FR24: System maintains completed tasks in visible state on Today view (not hidden or archived)
- FR25: User can change a task's state from any valid state to another (e.g., Active back to Not Started)

**Data Visualization & Insights:**
- FR26: User can view total count of tasks completed today
- FR27: User can view total count of tasks completed this week
- FR28: User can view total count of tasks completed this month
- FR29: User can view basic completion trend comparison (e.g., "45 this month, up from 38 last month")
- FR30: System maintains historical completion data for cumulative analysis
- FR31: User can access a simple cumulative statistics view separate from daily task views

**Data Management & Persistence:**
- FR32: System persists all task data locally on the device
- FR33: System maintains data across app launches and device restarts
- FR34: User can export all task data to JSON format
- FR35: System ensures zero data loss during normal operation
- FR36: System stores task metadata including creation date, update date, scheduled date, and completion date
- FR37: System assigns unique identifiers to all tasks for future sync capability

**User Experience & Interface:**
- FR38: User can launch the app and see the Today view by default
- FR39: User can navigate between Inbox, Today, and Upcoming views
- FR40: System provides visual feedback during drag operations
- FR41: System responds to all user interactions without perceptible lag
- FR42: User can see all task information within a single screen view (no complex navigation required)

### Non-Functional Requirements

**Performance:**
- NFR1: App launch to interactive Today view must complete within 1 second on modern iOS devices (iPhone 12 or newer)
- NFR2: Task creation from keystroke to visible persistence must complete within 100 milliseconds
- NFR3: Task state changes (Not Started → Active → Completed) must update UI within 50 milliseconds
- NFR4: Drag operations must maintain 60fps framerate during interaction with no perceptible lag
- NFR5: View transitions (Inbox → Today → Upcoming) must complete within 200 milliseconds
- NFR6: Cumulative statistics view must load and display data within 500 milliseconds for up to 1000 tasks
- NFR7: System must support rapid task entry (5+ tasks within 15 seconds) without performance degradation
- NFR8: System must maintain responsive performance with task lists containing up to 500 active tasks
- NFR9: App memory footprint must remain under 100MB during typical usage
- NFR10: App must not cause battery drain exceeding 5% per hour of active use
- NFR11: Local data storage must remain under 10MB for typical usage (1000 tasks with metadata)

**Reliability:**
- NFR12: System must achieve zero data loss during normal operation
- NFR13: System must persist task data immediately upon creation (no delayed save)
- NFR14: System must maintain data integrity across app crashes or force quits
- NFR15: System must maintain data integrity across iOS updates and device restarts
- NFR16: App crash rate must be below 0.1% of sessions
- NFR17: System must gracefully handle Core Data errors without data loss
- NFR18: System must recover from background app termination without user-visible disruption

**Availability:**
- NFR19: App must function 100% offline with no network dependency
- NFR20: App must be available immediately upon device unlock (no loading delays)

**Usability:**
- NFR21: Task capture flow must require no more than 2 user actions (type + enter)
- NFR22: All primary features must be accessible within 2 taps from app launch
- NFR23: Task organization actions (drag, reorder, move) must be discoverable without tutorial
- NFR24: Visual state differentiation must be immediately comprehensible without explanation
- NFR25: New user must be able to create and complete a task within 30 seconds of first launch
- NFR26: User must understand three-view system (Inbox, Today, Upcoming) within first 5 minutes of use
- NFR27: No tutorial or onboarding required to use core functionality
- NFR28: All user interactions must follow standard iOS gesture patterns
- NFR29: Visual design must follow iOS Human Interface Guidelines
- NFR30: System behavior must be predictable and consistent across all views

**Security & Privacy:**
- NFR31: All task data must remain on local device with no external transmission
- NFR32: Task data must be protected by iOS file system encryption when device is locked
- NFR33: App must respect iOS app sandboxing for data isolation
- NFR34: Exported JSON data must follow standard iOS file sharing security model
- NFR35: App must collect zero telemetry or analytics in MVP
- NFR36: App must not require internet connectivity or external accounts
- NFR37: All data remains under user control via iOS device management

### Additional Requirements

**Architecture Requirements:**

**Starter Template & Project Initialization:**
- Use standard Xcode SwiftUI + Core Data app template (File → New → Project → iOS → App)
- Enable Core Data support during project creation
- Configure SwiftUI as UI framework
- Set iOS 15+ as minimum deployment target
- Configure Swift 5.5+ as language version

**Core Data Schema Design:**
- Design Task entity with UUID primary key
- Implement comprehensive timestamp tracking (createdAt, updatedAt, completedAt, scheduledDate)
- Design schema to support future iCloud sync without migration
- Implement Core Data model versioning from day one

**MVVM Architecture Implementation:**
- Establish clean separation: Models (Core Data entities), Views (SwiftUI), ViewModels (ObservableObject)
- Implement state management through @Published properties
- Design testable business logic in ViewModels
- Establish clear data flow patterns

**Drag & Drop Implementation:**
- Custom drag & drop handlers using SwiftUI .onDrag/.onDrop
- Implement 60fps performance optimization
- Design semi-transparent drag previews
- Implement drop zone highlighting
- Handle invalid drop scenarios with rubber band animation

**Optimistic UI Updates:**
- Display changes immediately before Core Data write completes
- Implement rollback on persistence failure
- Ensure UI responsiveness during all state changes

**Background Context Pattern:**
- Implement Core Data background contexts for heavy operations
- Ensure thread-safe data access
- Maintain UI context on main thread
- Implement proper context merging

**Date & Time Management:**
- Implement timezone-aware date handling
- Design end-of-day boundary logic
- Support "Today", "Tomorrow", and future date scheduling
- Handle date transitions correctly

**Error Handling Strategy:**
- Implement graceful error recovery for Core Data failures
- Design non-blocking error presentation
- Implement automatic retry for transient failures
- Log errors using os_log for debugging

**Testing Infrastructure:**
- Set up XCTest framework for unit testing
- Implement Core Data persistence tests
- Design task state management logic tests
- Implement basic UI interaction tests

**Version Control & Deployment:**
- Initialize Git repository with .gitignore for Xcode
- Design commit message conventions
- Set up TestFlight for beta testing
- Plan App Store deployment workflow

**Logging Strategy:**
- Implement privacy-preserving logging using os_log
- Design log levels (debug, info, error)
- Ensure no sensitive data in logs
- Support debugging without telemetry

**UX Design Requirements:**

**Native iOS Component Usage:**
- Use SwiftUI List and ForEach for task display
- Use native TextField for task input with standard keyboard handling
- Use TabView for view navigation with native swipe gestures
- Implement pull-to-refresh using native .refreshable modifier
- Use native swipe actions for delete/quick actions

**Typography System:**
- Use San Francisco (SF Pro) system font exclusively
- Implement semantic text styles: .title3 for headers, .body for task text, .caption for metadata
- Support Dynamic Type for accessibility
- Ensure 17pt body text for comfortable reading

**Color System:**
- Use iOS system colors exclusively (Color.primary, Color.secondary, Color.accentColor)
- Implement automatic dark mode support through semantic colors
- Use blue accent for Active state with 0.1 opacity background tint
- Use gray with 50% opacity and strikethrough for Completed state
- Ensure WCAG 2.1 AA compliance automatically through system colors

**Spacing System:**
- Follow iOS standard spacing scale: 4pt, 8pt, 16pt (most common), 24pt, 32pt
- Ensure 44pt minimum touch targets (iOS HIG requirement)
- Use 16pt standard padding for list rows
- Respect iOS safe areas automatically

**Visual Feedback:**
- Implement drag preview with 0.7 opacity
- Show drop zone highlights with blue 0.2 opacity
- Use 200-300ms animation duration with .easeInOut curve
- Implement optional haptic feedback (.impact(.light)) on task completion
- Ensure smooth 60fps animations during all interactions

**Accessibility:**
- Support VoiceOver with automatic labels and state announcements
- Implement high contrast mode support through system colors
- Support Reduce Motion accessibility setting
- Ensure color-independent state indicators (use opacity, strikethrough, background in addition to color)
- Support keyboard navigation on iPad

**Responsive Design:**
- Design for iPhone portrait (primary)
- Support iPhone landscape with same layout
- Support iPad with adaptive layout (Phase 2)
- Handle multitasking window sizes gracefully

**Haptic Feedback System (Optional):**
- Implement UIImpactFeedbackGenerator for task completion
- Respect system haptic settings
- Use haptics as additional confirmation, not sole indicator
- Implement light tap for creation, medium for drag start

**Animation Patterns:**
- Slide-in animation for new tasks (200ms)
- Spring animation for drag drop (300ms)
- Instant state changes with smooth visual transitions (<50ms)
- Rubber band animation for invalid drops (400ms)

### FR Coverage Map

**Task Capture & Creation:**
- FR1 → Epic 1: Task creation by typing and pressing enter
- FR2 → Epic 1: Sub-3-second capture time
- FR3 → Epic 1: No required fields at capture
- FR4 → Epic 1: Rapid succession capture
- FR5 → Epic 5: Task deletion
- FR6 → Epic 1: Immediate persistence

**Task Organization & Management:**
- FR7 → Epic 2: Three-view system (Inbox, Today, Upcoming)
- FR8 → Epic 3: Reorder tasks within view by dragging
- FR9 → Epic 3: Move tasks between views by dragging
- FR10 → Epic 4: Completed tasks visible in Today view
- FR11 → Epic 3: System maintains user-specified order
- FR12 → Epic 2: Persistent input field across views

**Time & Schedule Management:**
- FR13 → Epic 3: Assign specific date to tasks
- FR14 → Epic 3: Move tasks to "Today" with single action
- FR15 → Epic 3: Move tasks to "Tomorrow" with single action
- FR16 → Epic 3: Move tasks to future date via date picker
- FR17 → Epic 3: Move tasks to timeless Inbox
- FR18 → Epic 3: No automatic rollover
- FR19 → Epic 3: Explicit carry-forward choices

**Task State & Progress Tracking:**
- FR20 → Epic 4: Mark task as "Active"
- FR21 → Epic 4: Mark task as "Completed"
- FR22 → Epic 4: Visual state differentiation
- FR23 → Epic 4: Track completion timestamps
- FR24 → Epic 4: Completed tasks remain visible
- FR25 → Epic 4: Change task state freely

**Data Visualization & Insights:**
- FR26 → Epic 6: View tasks completed today
- FR27 → Epic 6: View tasks completed this week
- FR28 → Epic 6: View tasks completed this month
- FR29 → Epic 6: View completion trend comparisons
- FR30 → Epic 6: Maintain historical completion data
- FR31 → Epic 6: Access cumulative statistics view

**Data Management & Persistence:**
- FR32 → Epic 1: Local data persistence
- FR33 → Epic 1: Data survives app restarts
- FR34 → Epic 7: Export data to JSON
- FR35 → Epic 1: Zero data loss guarantee
- FR36 → Epic 1: Store comprehensive task metadata
- FR37 → Epic 1: UUID-based task identifiers

**User Experience & Interface:**
- FR38 → Epic 1: Launch to Today view by default
- FR39 → Epic 2: Navigate between views
- FR40 → Epic 3: Visual feedback during drag
- FR41 → Epic 1: No perceptible interaction lag
- FR42 → Epic 2: Single-screen view (no complex navigation)

## Epic List

### Epic 1: Project Foundation & Instant Task Capture

Users can capture tasks instantly (under 3 seconds) with zero friction and have them persist reliably across app launches. This establishes the "Notes app DNA" foundation—fast capture with no required fields—while setting up the technical infrastructure (Xcode project, Core Data, MVVM architecture) that enables all future features.

**FRs covered:** FR1, FR2, FR3, FR4, FR6, FR32, FR33, FR35, FR36, FR37, FR38, FR41

### Epic 2: Three-View Organization System

Users can organize their tasks across three distinct views: Inbox (timeless holding space), Today (scheduled for today), and Upcoming (future scheduled tasks). They can navigate seamlessly between views and access the persistent input field from anywhere, providing time awareness and conscious task organization.

**FRs covered:** FR7, FR12, FR39, FR42

### Epic 3: Drag-Based Time Manipulation

Users can drag tasks to reorder them (priority) and drag between views to reschedule them through spatial "sliding through time" interactions. This replaces clunky date pickers and menus with fluid, intuitive gestures that make time feel physical and immediate, with clear visual feedback and 60fps performance.

**FRs covered:** FR8, FR9, FR11, FR13, FR14, FR15, FR16, FR17, FR18, FR19, FR40

### Epic 4: Task State Management & Completion

Users can track task progress through three states (Not Started → Active → Completed) with clear visual differentiation. Completed tasks remain visible on Today view for "today wasn't wasted" emotional validation, and users can freely change states as their work evolves.

**FRs covered:** FR10, FR20, FR21, FR22, FR23, FR24, FR25

### Epic 5: Task Deletion

Users can remove tasks they no longer need through familiar swipe-to-delete gestures, enabling task lifecycle completion and keeping their lists clean without accumulation.

**FRs covered:** FR5

### Epic 6: Simple Cumulative Analytics

Users can view completion statistics (tasks completed today/week/month) and basic trend comparisons in a separate analytics view. This provides progress visibility and behavioral insights without gamification, answering "today wasn't wasted" through simple data.

**FRs covered:** FR26, FR27, FR28, FR29, FR30, FR31

### Epic 7: Data Export Capability

Users can export all their task data to JSON format for backup, portability, and data ownership. The export integrates with iOS standard share sheet for saving to Files app or sharing to other apps.

**FRs covered:** FR34

---

## Epic 1: Project Foundation & Instant Task Capture

Users can capture tasks instantly (under 3 seconds) with zero friction and have them persist reliably across app launches. This establishes the "Notes app DNA" foundation—fast capture with no required fields—while setting up the technical infrastructure (Xcode project, Core Data, MVVM architecture) that enables all future features.

### Story 1.1: Initialize Xcode Project with Core Data

As a developer,
I want to create a new Xcode SwiftUI project with Core Data support,
So that the technical foundation is ready for building the task management app.

**Acceptance Criteria:**

**Given** Xcode 13+ is installed on the development machine
**When** creating a new iOS project
**Then** the project is configured with:
- SwiftUI as the UI framework
- Core Data support enabled
- iOS 15+ as minimum deployment target
- Swift 5.5+ as language version
- Standard Xcode project structure with ContentView.swift and Persistence.swift
**And** the project builds successfully without errors
**And** the Core Data stack initializes correctly with PersistenceController
**And** Git repository is initialized with appropriate .gitignore for Xcode projects

### Story 1.2: Design Core Data Task Entity Schema

As a developer,
I want to define the Task entity in the Core Data model,
So that tasks can be persisted with all required metadata for current and future features.

**Acceptance Criteria:**

**Given** the Xcode project with Core Data is set up
**When** designing the Task entity in the .xcdatamodeld file
**Then** the Task entity includes these attributes:
- `id` (UUID, required) - unique identifier for sync readiness
- `text` (String, required) - task description
- `state` (String, required) - "notStarted", "active", or "completed"
- `createdAt` (Date, required) - creation timestamp
- `updatedAt` (Date, required) - last modification timestamp
- `completedAt` (Date, optional) - completion timestamp
- `scheduledDate` (Date, optional) - scheduled date for Today/Upcoming (nil = Inbox)
- `sortOrder` (Int32, required) - user-defined order within view
**And** appropriate default values are set (state: "notStarted", dates: current time, sortOrder: 0)
**And** the schema is designed for future extensibility (version 1.0 model)
**And** Core Data model compiles without warnings

### Story 1.3: Create Task Model and MVVM Structure

As a developer,
I want to implement the Task model with MVVM architecture pattern,
So that business logic is separated from the UI and the codebase is testable and maintainable.

**Acceptance Criteria:**

**Given** the Task entity is defined in Core Data
**When** implementing the MVVM structure
**Then** a Task class extension provides:
- Computed properties for easy access to Core Data attributes
- Helper methods for state transitions
- Proper Hashable and Identifiable conformance for SwiftUI
**And** a TaskViewModel (ObservableObject) is created with:
- @Published property for tasks array
- Methods for CRUD operations
- Reference to PersistenceController
- Proper initialization
**And** folder structure follows: Models/, Views/, ViewModels/
**And** code compiles without errors

### Story 1.4: Build Basic Today View with Task List

As a user,
I want to launch the app and see the Today view with a list of tasks,
So that I can immediately view my tasks without navigation.

**Acceptance Criteria:**

**Given** the app is installed on an iOS device
**When** launching the app for the first time
**Then** the Today view appears as the default screen within 1 second
**And** an empty list is displayed (since no tasks exist yet)
**And** the view title "Today" is visible at the top
**And** the interface follows iOS Human Interface Guidelines
**And** the app uses native SwiftUI List component for displaying tasks
**And** the background uses Color.systemBackground for automatic dark mode support

### Story 1.5: Implement Persistent Input Field for Task Capture

As a user,
I want to see a persistent input field at the top of the Today view,
So that I can quickly capture new tasks without extra navigation.

**Acceptance Criteria:**

**Given** the Today view is displayed
**When** the view appears
**Then** a TextField is visible at the top with placeholder "What needs to be done?"
**And** the TextField automatically gains focus with keyboard appearing
**And** the TextField uses .body font (17pt, San Francisco)
**And** the TextField uses standard iOS styling (.textFieldStyle(.plain))
**And** the TextField has 16pt horizontal padding and 12pt vertical padding
**And** tapping the TextField (if focus lost) brings keyboard back immediately
**And** the TextField remains visible while scrolling the task list below

### Story 1.6: Enable Task Creation via Text Input

As a user,
I want to type a task description and press Enter to create it,
So that I can capture tasks in under 3 seconds with zero friction.

**Acceptance Criteria:**

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

### Story 1.7: Display Tasks in List with Basic Styling

As a user,
I want to see my created tasks displayed in a clean, readable list,
So that I can quickly scan my tasks without visual clutter.

**Acceptance Criteria:**

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

### Story 1.8: Implement Immediate Data Persistence

As a user,
I want my tasks to save automatically without any save button,
So that I never lose data and can close the app immediately after capture.

**Acceptance Criteria:**

**Given** I create a new task
**When** the task is submitted via Enter key
**Then** the Core Data context saves immediately (within 100ms total)
**And** optimistic UI update shows the task before persistence completes
**And** if save fails, the task is retried automatically (up to 3 attempts)
**And** if all retries fail, an alert is shown: "Failed to save task. Please try again."
**And** successful saves generate no user-facing feedback (silent success)
**And** I can immediately close the app via home button and task persists
**And** when reopening the app, the task is still present

### Story 1.9: Ensure Data Persistence Across App Launches

As a user,
I want my tasks to survive app restarts and device reboots,
So that my data is reliable and I can trust the system.

**Acceptance Criteria:**

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

### Story 1.10: Implement Rapid Succession Task Capture

As a user,
I want to create multiple tasks quickly one after another,
So that I can capture a batch of related tasks in a flow state.

**Acceptance Criteria:**

**Given** the input field is focused
**When** I type "Task 1" + Enter, then "Task 2" + Enter, then "Task 3" + Enter in rapid succession
**Then** all three tasks are created successfully
**And** each task appears in the list immediately after Enter
**And** the entire process for 5 tasks completes within 15 seconds (3 seconds per task average)
**And** no performance degradation occurs during rapid entry
**And** the TextField remains focused throughout the entire sequence
**And** no tasks are lost or duplicated
**And** tasks appear in creation order (sortOrder maintained)

### Story 1.11: Optimize Task Creation Performance

As a developer,
I want task creation to complete within strict performance budgets,
So that the "instant capture" user experience is maintained.

**Acceptance Criteria:**

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

### Story 1.12: Handle Task Creation Error Cases

As a user,
I want the app to handle errors gracefully,
So that I don't lose my task if something goes wrong.

**Acceptance Criteria:**

**Given** I create a task
**When** Core Data persistence fails (simulated disk full or corruption)
**Then** the app retries the save automatically (3 attempts with exponential backoff)
**And** if all retries fail, I see an alert: "Unable to save task. Please check device storage."
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

## Epic 2: Three-View Organization System

Users can organize their tasks across three distinct views: Inbox (timeless holding space), Today (scheduled for today), and Upcoming (future scheduled tasks). They can navigate seamlessly between views and access the persistent input field from anywhere, providing time awareness and conscious task organization.

### Story 2.1: Implement Three-View Tab Navigation

As a user,
I want to navigate between Inbox, Today, and Upcoming views using a tab bar,
So that I can organize tasks by time horizon.

**Acceptance Criteria:**

**Given** the app is open
**When** viewing the main screen
**Then** a bottom tab bar is visible with three tabs:
- "Inbox" (leftmost)
- "Today" (center)
- "Upcoming" (rightmost)
**And** each tab has an appropriate SF Symbol icon
**And** the "Today" tab is selected by default on app launch
**And** tapping a tab switches to that view within 200ms
**And** the selected tab is highlighted with blue accent color
**And** tab switches use smooth slide transitions
**And** tab bar follows iOS standard design (44pt height, safe area insets respected)

### Story 2.2: Build Inbox View for Timeless Tasks

As a user,
I want to see an Inbox view for tasks without assigned dates,
So that I can capture tasks without immediately scheduling them.

**Acceptance Criteria:**

**Given** I navigate to the Inbox tab
**When** the view loads
**Then** I see the view title "Inbox" at the top
**And** a persistent input field is visible (same as Today view)
**And** all tasks with scheduledDate = nil are displayed
**And** tasks are ordered by sortOrder
**And** the view uses the same List styling as Today view
**And** the input field remains focused when switching to this view
**And** tasks created in Inbox view have scheduledDate = nil
**And** the view loads within 200ms when switching tabs

### Story 2.3: Build Upcoming View for Future Tasks

As a user,
I want to see an Upcoming view for tasks scheduled for tomorrow and beyond,
So that I can see what's coming up without cluttering today's view.

**Acceptance Criteria:**

**Given** I navigate to the Upcoming tab
**When** the view loads
**Then** I see the view title "Upcoming" at the top
**And** a persistent input field is visible (same as other views)
**And** all tasks with scheduledDate > today are displayed
**And** tasks are grouped by date (Tomorrow, Feb 12, Feb 13, etc.)
**And** within each date group, tasks are ordered by sortOrder
**And** date headers use .title3 font (20pt, Semibold)
**And** the view uses the same List styling as other views
**And** tasks created in Upcoming view default to scheduledDate = tomorrow
**And** the view loads within 200ms when switching tabs

### Story 2.4: Filter Today View to Show Only Today's Tasks

As a user,
I want the Today view to display only tasks scheduled for today,
So that I can focus on my current day's work without distraction.

**Acceptance Criteria:**

**Given** tasks exist with various scheduledDate values
**When** viewing the Today tab
**Then** only tasks where scheduledDate = today's date are shown
**And** tasks where scheduledDate = nil (Inbox) are NOT shown
**And** tasks where scheduledDate > today (Upcoming) are NOT shown
**And** tasks where scheduledDate < today (past) are NOT shown
**And** date comparison uses start-of-day logic (ignores time component)
**And** timezone of the device is respected
**And** the filter updates automatically at midnight (date boundary transition)

### Story 2.5: Maintain Persistent Input Field Across All Views

As a user,
I want the input field to be available at the top of all three views,
So that I can capture tasks instantly regardless of which view I'm in.

**Acceptance Criteria:**

**Given** I am in any view (Inbox, Today, or Upcoming)
**When** the view is displayed
**Then** the input field is visible at the top
**And** the input field maintains focus when switching between views
**And** the placeholder text is "What needs to be done?" in all views
**And** the styling is identical across all views (16pt padding, .body font)
**And** tasks created in Inbox get scheduledDate = nil
**And** tasks created in Today get scheduledDate = today
**And** tasks created in Upcoming get scheduledDate = tomorrow (default)
**And** the input field behavior is consistent (Enter to create, auto-clear, retain focus)

### Story 2.6: Implement Horizontal Swipe Navigation Between Views

As a user,
I want to swipe left/right to navigate between views,
So that I can quickly move between Inbox, Today, and Upcoming with familiar iOS gestures.

**Acceptance Criteria:**

**Given** I am viewing any of the three views
**When** I swipe right
**Then** the view transitions to the next view in sequence (Inbox → Today → Upcoming)
**And** the transition uses smooth slide animation
**And** the transition completes within 300ms
**When** I swipe left
**Then** the view transitions to the previous view (Upcoming → Today → Inbox)
**And** swiping left from Inbox has no effect (stays on Inbox)
**And** swiping right from Upcoming has no effect (stays on Upcoming)
**And** the selected tab indicator updates to match the current view
**And** the swipe gesture follows iOS standard behavior (edge-to-edge swipe)

### Story 2.7: Show Empty State Messages for Each View

As a user,
I want to see helpful empty state messages when a view has no tasks,
So that I understand what each view is for and feel encouraged to add tasks.

**Acceptance Criteria:**

**Given** a view has no tasks to display
**When** viewing the empty Inbox
**Then** a message appears: "No tasks in Inbox. Capture ideas here without scheduling them."
**And** the message uses .caption font (12pt) with Color.secondary
**And** the message is centered in the list area
**When** viewing the empty Today view
**Then** a message appears: "No tasks scheduled for today. Drag tasks from Inbox or capture new ones."
**When** viewing the empty Upcoming view
**Then** a message appears: "No upcoming tasks. Schedule tasks for tomorrow and beyond."
**And** empty state messages don't prevent the input field from working
**And** empty state messages disappear as soon as the first task is added

### Story 2.8: Ensure Single-Screen Simplicity (No Deep Navigation)

As a user,
I want all task information visible within the main three views,
So that I don't have to navigate through multiple screens to see my tasks.

**Acceptance Criteria:**

**Given** I am using the app
**When** navigating between Inbox, Today, and Upcoming
**Then** all navigation happens via the tab bar only
**And** there are no drill-down screens or modal views (in MVP)
**And** task details are shown inline in the list (no tap-to-expand in MVP)
**And** all task operations happen within the same screen
**And** I can see the input field and task list simultaneously
**And** no navigation bar "Back" buttons exist (single-level navigation)
**And** the app structure follows: TabView → [InboxView, TodayView, UpcomingView]

---

## Epic 3: Drag-Based Time Manipulation

Users can drag tasks to reorder them (priority) and drag between views to reschedule them through spatial "sliding through time" interactions. This replaces clunky date pickers and menus with fluid, intuitive gestures that make time feel physical and immediate, with clear visual feedback and 60fps performance.

### Story 3.1: Implement Drag-to-Reorder Within a Single View

As a user,
I want to drag tasks up and down to reorder them within the same view,
So that I can adjust priority without extra menus.

**Acceptance Criteria:**

**Given** I am viewing any view with multiple tasks
**When** I long-press (300ms) on a task
**Then** the task lifts slightly with a subtle shadow
**And** haptic feedback occurs (medium impact)
**And** the task becomes semi-transparent (0.7 opacity)
**And** the task follows my finger as I drag vertically
**And** drag tracking maintains 60fps performance
**When** I drag the task over another task
**Then** the other tasks shift to make space for the dragged task
**And** the shift animation is smooth (spring animation, 200ms)
**When** I release the task in a new position
**Then** the task drops into place with smooth animation
**And** haptic feedback occurs (light impact)
**And** the sortOrder values are updated for all affected tasks
**And** the new order persists in Core Data immediately
**And** the new order is maintained after app restart

### Story 3.2: Implement Drag Between Views (Inbox to Today)

As a user,
I want to drag a task from Inbox to Today to schedule it for today,
So that I can spatially move tasks through time without date pickers.

**Acceptance Criteria:**

**Given** I am viewing the Inbox with tasks present
**When** I long-press on a task and begin dragging
**Then** the task lifts and becomes draggable
**When** I drag toward the bottom of the screen near the tab bar
**Then** the "Today" tab highlights with blue background (0.2 opacity)
**And** visual indication shows the tab is a valid drop zone
**When** I continue dragging over the "Today" tab for 500ms
**Then** the view automatically switches to Today view
**And** the dragged task preview continues to follow my finger
**And** the Today view shows drop zones for task placement
**When** I release the task in Today view
**Then** the task is inserted at the drop position
**And** the task's scheduledDate is updated to today's date
**And** the task disappears from Inbox
**And** the task appears in Today with smooth slide-in animation
**And** sortOrder is recalculated for the new position
**And** the change persists immediately to Core Data

### Story 3.3: Implement Drag Between Views (Today to Upcoming)

As a user,
I want to drag a task from Today to Upcoming to reschedule it for the future,
So that I can consciously defer tasks without automatic rollover.

**Acceptance Criteria:**

**Given** I am viewing Today with tasks present
**When** I drag a task toward the "Upcoming" tab
**Then** the "Upcoming" tab highlights as a valid drop zone
**When** I hover over the Upcoming tab for 500ms
**Then** the view switches to Upcoming automatically
**And** the dragged task continues following my finger
**When** I release the task in Upcoming view
**Then** the task's scheduledDate is updated to tomorrow's date (default)
**And** the task disappears from Today view
**And** the task appears in Upcoming under "Tomorrow" date group
**And** sortOrder is calculated for the new position
**And** all changes persist immediately
**And** the task will not appear in Today anymore unless manually moved back

### Story 3.4: Implement Drag to Inbox (Unscheduling)

As a user,
I want to drag a task from Today or Upcoming back to Inbox,
So that I can remove scheduling and return it to the timeless holding space.

**Acceptance Criteria:**

**Given** I am viewing Today or Upcoming with tasks
**When** I drag a task toward the "Inbox" tab
**Then** the Inbox tab highlights as a valid drop zone
**When** I hover over Inbox tab for 500ms
**Then** the view switches to Inbox
**When** I release the task in Inbox
**Then** the task's scheduledDate is set to nil
**And** the task disappears from the original view (Today/Upcoming)
**And** the task appears in Inbox at the drop position
**And** sortOrder is recalculated
**And** changes persist immediately
**And** the task remains in Inbox until manually scheduled again

### Story 3.5: Implement Visual Feedback During Drag Operations

As a user,
I want clear visual feedback during drag operations,
So that I understand where the task will land and feel confident in the interaction.

**Acceptance Criteria:**

**Given** I am dragging a task
**When** the drag operation begins
**Then** the original task position is marked with reduced opacity (0.3)
**And** the dragged preview is semi-transparent (0.7 opacity)
**And** the dragged preview has a subtle shadow (8pt offset, 0.2 opacity)
**And** the preview follows my finger with zero lag (60fps)
**When** dragging over a valid drop zone within a view
**Then** other tasks shift to show where the drop will occur
**And** a blue indicator line shows the exact drop position
**When** dragging over a tab to switch views
**Then** the tab background tints blue (0.2 opacity)
**And** a subtle animation indicates hover state
**When** dragging over an invalid drop zone (edge of screen, non-droppable area)
**Then** no drop indicator appears
**And** the cursor/preview doesn't change
**When** I release over an invalid zone
**Then** the task animates back to original position (rubber band effect, 400ms)
**And** haptic feedback does NOT occur (no success confirmation)

### Story 3.6: Implement Date Picker for Specific Future Dates

As a user,
I want to assign a specific future date to a task beyond tomorrow,
So that I can schedule tasks for exact dates without dragging through many days.

**Acceptance Criteria:**

**Given** I am viewing a task in any view
**When** I tap and hold on a task (long press) for 1 second without dragging
**Then** a context menu appears with options:
- "Move to Today"
- "Move to Tomorrow"
- "Choose Date..."
- "Move to Inbox"
- "Cancel"
**When** I select "Choose Date..."
**Then** an iOS native date picker appears
**And** the date picker defaults to tomorrow's date
**And** the date picker allows selecting any future date
**When** I select a date and tap "Done"
**Then** the task's scheduledDate is updated to the selected date
**And** the task moves to the appropriate view (Today if today, Upcoming if future)
**And** the task appears under the correct date group in Upcoming
**And** changes persist immediately
**When** I select "Cancel" on the context menu or date picker
**Then** no changes occur and the menu dismisses

### Story 3.7: Implement Quick Actions (Move to Today/Tomorrow)

As a user,
I want quick one-tap actions to move tasks to Today or Tomorrow,
So that I can rapidly reschedule without drag interactions.

**Acceptance Criteria:**

**Given** a task exists in any view
**When** I swipe left on the task row
**Then** action buttons appear on the right side:
- Blue "Today" button
- Green "Tomorrow" button
- Red "Delete" button (Epic 5)
**When** I tap the "Today" button
**Then** the task's scheduledDate is set to today's date
**And** the task moves to Today view
**And** the task disappears from current view with slide-out animation
**And** changes persist immediately
**When** I tap the "Tomorrow" button
**Then** the task's scheduledDate is set to tomorrow's date
**And** the task moves to Upcoming view under "Tomorrow"
**And** the task disappears from current view
**And** changes persist immediately
**When** I swipe right to close actions or tap elsewhere
**Then** the action buttons slide away and task returns to normal

### Story 3.8: Enforce No Automatic Rollover Logic

As a developer,
I want to ensure tasks never automatically move to the next day,
So that users maintain full agency over their task lifecycle.

**Acceptance Criteria:**

**Given** tasks exist in Today view at the end of the day (11:59 PM)
**When** the date boundary transitions to midnight (12:00 AM)
**Then** the tasks from yesterday remain with their original scheduledDate
**And** the tasks appear in the view for yesterday's date (past tasks)
**And** the Today view filters to show only tasks with today's new date
**And** yesterday's incomplete tasks are NOT automatically moved to today
**And** yesterday's incomplete tasks remain accessible (could show in "Past" view in Phase 2)
**And** the user must manually drag tasks to today if they want to carry them forward
**And** this behavior is consistent across app restarts and force quits
**And** no background process or system logic automatically updates scheduledDate

### Story 3.9: Handle Date Transition at Midnight

As a user,
I want the view filters to update automatically at midnight,
So that "Today" always reflects the current day without restarting the app.

**Acceptance Criteria:**

**Given** the app is open during the day-to-night transition (11:59 PM → 12:00 AM)
**When** midnight occurs
**Then** the Today view filter automatically updates to the new date
**And** tasks that were "Upcoming/Tomorrow" now appear in "Today" (if scheduledDate = new today)
**And** the view refreshes smoothly without user action
**And** no tasks are lost or duplicated during the transition
**And** the Upcoming view also updates its date groupings
**And** timezone changes (traveling) are handled correctly
**And** if the app was backgrounded, the date filter updates on returning to foreground

### Story 3.10: Optimize Drag Performance for 60fps

As a developer,
I want drag operations to maintain 60fps performance,
So that the spatial manipulation feels fluid and responsive.

**Acceptance Criteria:**

**Given** a view with up to 100 tasks
**When** dragging a task
**Then** the preview tracks finger movement at 60fps (16.67ms per frame)
**And** no frame drops occur during drag
**And** animation of other tasks shifting is smooth (60fps)
**And** tab highlighting responds instantly (<50ms)
**And** view transitions during drag complete within 300ms
**And** Core Data queries for filtering views complete within 50ms
**And** sortOrder recalculations happen in background context
**And** optimistic UI updates show changes before persistence completes
**And** memory usage during drag remains under 100MB
**And** battery impact of drag operations is negligible

### Story 3.11: Implement Undo for Drag Operations

As a user,
I want an undo option after moving a task,
So that I can quickly correct mistakes without manually moving it back.

**Acceptance Criteria:**

**Given** I successfully move a task via drag or quick action
**When** the task lands in its new location
**Then** a toast notification appears at the bottom: "Moved to [View Name]" with "Undo" button
**And** the toast is visible for 3 seconds
**And** the toast doesn't block the input field or primary interactions
**When** I tap "Undo" within 3 seconds
**Then** the task returns to its original view and position
**And** the scheduledDate reverts to the previous value
**And** the sortOrder reverts to the previous value
**And** the undo action completes with smooth animation
**And** all changes persist immediately
**When** 3 seconds elapse without tapping Undo
**Then** the toast dismisses automatically
**And** the move becomes permanent (but still manually reversible)

---

## Epic 4: Task State Management & Completion

Users can track task progress through three states (Not Started → Active → Completed) with clear visual differentiation. Completed tasks remain visible on Today view for "today wasn't wasted" emotional validation, and users can freely change states as their work evolves.

### Story 4.1: Implement Three Task States (Model Layer)

As a developer,
I want to implement the three task states in the data model,
So that tasks can track their progress through the workflow.

**Acceptance Criteria:**

**Given** the Task entity exists in Core Data
**When** updating the Task model
**Then** the `state` attribute supports three string values:
- "notStarted" (default for new tasks)
- "active" (user is currently working on it)
- "completed" (task is done)
**And** helper methods exist for state transitions:
- `markAsActive()` → sets state to "active", updates updatedAt
- `markAsCompleted()` → sets state to "completed", sets completedAt to current time, updates updatedAt
- `markAsNotStarted()` → sets state to "notStarted", clears completedAt, updates updatedAt
**And** state changes persist immediately to Core Data
**And** computed properties exist for checking state: `isNotStarted`, `isActive`, `isCompleted`

### Story 4.2: Implement Tap-to-Change-State Interaction

As a user,
I want to tap a task to cycle through states (Not Started → Active → Completed → Not Started),
So that I can quickly update task progress with a single tap.

**Acceptance Criteria:**

**Given** a task in "notStarted" state is displayed
**When** I tap on the task row
**Then** the state changes to "active" within 50ms
**And** the visual appearance updates immediately (see Story 4.3)
**And** haptic feedback occurs (light impact)
**And** the change persists to Core Data
**Given** a task in "active" state
**When** I tap on the task row
**Then** the state changes to "completed"
**And** completedAt timestamp is set to current time
**And** the visual appearance updates to completed style
**And** haptic feedback occurs (light impact)
**Given** a task in "completed" state
**When** I tap on the task row
**Then** the state changes back to "notStarted"
**And** completedAt timestamp is cleared (set to nil)
**And** the visual appearance updates to not started style
**And** users can freely cycle through states in any direction

### Story 4.3: Implement Visual Differentiation for Task States

As a user,
I want to see clear visual differences between task states,
So that I can instantly understand task progress at a glance.

**Acceptance Criteria:**

**Given** tasks exist in different states
**When** viewing the task list
**Then** "notStarted" tasks display as:
- Text color: Color.primary (full contrast, black in light mode)
- Opacity: 1.0 (fully visible)
- Background: transparent
- Text decoration: none
- Font weight: regular
**Then** "active" tasks display as:
- Text color: Color.blue (accent color)
- Background: Color.blue with 0.1 opacity (subtle blue tint)
- Opacity: 1.0 (fully visible)
- Text decoration: none
- Font weight: regular (or semibold for emphasis - test with user)
**Then** "completed" tasks display as:
- Text color: Color.secondary (gray, reduced importance)
- Opacity: 0.5 (reduced visual presence)
- Text decoration: strikethrough (`.strikethrough()` modifier)
- Background: transparent
**And** all three states are immediately comprehensible without explanation
**And** state differentiation works in both light and dark mode
**And** state differentiation is accessible (uses multiple visual indicators, not just color)
**And** transitions between states animate smoothly (200ms duration, .easeInOut curve)

### Story 4.4: Keep Completed Tasks Visible in Today View

As a user,
I want completed tasks to remain visible in Today view,
So that I can see what I accomplished and feel "today wasn't wasted" validation.

**Acceptance Criteria:**

**Given** I complete a task in Today view
**When** the task state changes to "completed"
**Then** the task remains in the Today view list
**And** the task moves to the bottom of the list (below not started and active tasks)
**And** the task displays with completed styling (gray, strikethrough, 0.5 opacity)
**And** the task is still present after switching views and returning
**And** the task is still present after closing and reopening the app
**And** the task contributes to the daily completion count (Epic 6)
**And** completed tasks do NOT hide or archive automatically
**And** completed tasks remain visible until the day ends (midnight transition)
**And** users can still interact with completed tasks (tap to uncomplete)

### Story 4.5: Track Completion Timestamps

As a user,
I want the system to record when I complete tasks,
So that future analytics can show my completion patterns over time.

**Acceptance Criteria:**

**Given** a task is in "notStarted" or "active" state
**When** I mark the task as "completed"
**Then** the completedAt timestamp is set to the current date and time
**And** the timezone of completion is recorded correctly
**And** the updatedAt timestamp is also updated
**Given** a completed task exists
**When** I mark it as "notStarted" or "active" again (uncomplete it)
**Then** the completedAt timestamp is cleared (set to nil)
**And** the updatedAt timestamp is updated
**And** the completion timestamp is stored with full datetime precision (not just date)
**And** completion timestamps persist correctly across app restarts
**And** completion data is available for analytics queries (Epic 6)

### Story 4.6: Implement State Sorting Logic

As a user,
I want tasks organized by state within each view,
So that active and incomplete tasks are prioritized over completed ones.

**Acceptance Criteria:**

**Given** a view contains tasks in mixed states
**When** the view is displayed
**Then** tasks are sorted in this order:
1. "active" tasks (at top)
2. "notStarted" tasks (middle)
3. "completed" tasks (at bottom)
**And** within each state group, tasks are sorted by sortOrder (user-defined order)
**And** when I mark a task as active, it moves to the top section
**And** when I complete a task, it moves to the bottom section
**And** the transition animation is smooth (200ms slide animation)
**And** drag-to-reorder still works within state groups
**And** completed tasks remain visible but don't compete for attention

### Story 4.7: Display Completion Count in Today View

As a user,
I want to see a simple count of completed tasks in Today view,
So that I have immediate feedback on my daily progress.

**Acceptance Criteria:**

**Given** I am viewing the Today view
**When** the view is displayed
**Then** a subtle count appears at the top: "X completed today"
**And** the count uses .caption font (12pt) with Color.secondary
**And** the count appears near the view title or above the input field
**And** the count updates in real-time as tasks are completed
**When** I complete a task
**Then** the count increments immediately (e.g., "3 completed today" → "4 completed today")
**When** I uncomplete a task
**Then** the count decrements immediately
**When** no tasks are completed yet
**Then** the count shows "0 completed today" or is hidden entirely
**And** the count resets at midnight to reflect the new day
**And** the count only includes tasks with scheduledDate = today and state = completed

### Story 4.8: Ensure State Changes Work Across All Views

As a user,
I want to mark tasks active or complete from any view (Inbox, Today, Upcoming),
So that I have consistent functionality regardless of where the task is.

**Acceptance Criteria:**

**Given** tasks exist in Inbox view
**When** I tap a task to cycle states
**Then** the state changes work identically to Today view
**And** completed tasks in Inbox remain visible (don't hide)
**Given** tasks exist in Upcoming view
**When** I tap a task to cycle states
**Then** the state changes work identically to other views
**And** I can mark future tasks as completed (pre-completion)
**And** I can mark future tasks as active (starting early)
**And** all state changes persist correctly regardless of view
**And** visual styling is consistent across all views
**And** completion timestamps are recorded regardless of view

---

## Epic 5: Task Deletion

Users can remove tasks they no longer need through familiar swipe-to-delete gestures, enabling task lifecycle completion and keeping their lists clean without accumulation.

### Story 5.1: Implement Swipe-to-Delete Gesture

As a user,
I want to swipe left on a task to reveal a delete button,
So that I can remove tasks I no longer need.

**Acceptance Criteria:**

**Given** a task exists in any view
**When** I swipe left on the task row
**Then** a red "Delete" button appears on the right side
**And** the delete button uses iOS standard red color (Color.red)
**And** the delete button displays a trash icon (SF Symbol: "trash")
**And** the swipe gesture follows iOS standard behavior (smooth reveal)
**When** I tap the "Delete" button
**Then** the task is removed from the view immediately
**And** the task is deleted from Core Data
**And** the deletion animates smoothly (slide-out animation, 200ms)
**And** other tasks shift up to fill the gap
**And** the deletion persists (task is gone after app restart)
**When** I swipe left but don't tap delete, then swipe right or tap elsewhere
**Then** the delete button slides away and task returns to normal

### Story 5.2: Implement Full-Swipe to Delete

As a user,
I want to swipe fully left to immediately delete a task,
So that I can quickly remove tasks without tapping the delete button.

**Acceptance Criteria:**

**Given** a task exists in any view
**When** I swipe left on the task row all the way to the left edge
**Then** the task is deleted immediately (full-swipe shortcut)
**And** the deletion uses the same animation as button delete
**And** the task is removed from Core Data
**And** no confirmation dialog appears (fast delete)
**And** the gesture follows iOS standard full-swipe-to-delete behavior
**And** haptic feedback occurs on deletion (medium impact)

### Story 5.3: Handle Delete Operation Errors

As a developer,
I want deletion to handle errors gracefully,
So that users don't encounter cryptic errors or data corruption.

**Acceptance Criteria:**

**Given** a task is being deleted
**When** Core Data deletion fails (simulated database lock or corruption)
**Then** the task reappears in the list with smooth animation
**And** an alert appears: "Unable to delete task. Please try again."
**And** the user can retry the deletion
**And** if retry succeeds, task is deleted successfully
**And** if retry fails repeatedly, the app logs the error (os_log)
**And** the app doesn't crash or lose other task data
**And** the UI remains responsive during error handling

### Story 5.4: Ensure Delete Works Consistently Across All Views

As a user,
I want delete functionality to work the same in Inbox, Today, and Upcoming,
So that I have a consistent experience everywhere.

**Acceptance Criteria:**

**Given** tasks exist in Inbox view
**When** I delete a task via swipe
**Then** the task is removed from Inbox and Core Data
**Given** tasks exist in Today view
**When** I delete a task via swipe
**Then** the task is removed from Today and Core Data
**Given** tasks exist in Upcoming view
**When** I delete a task via swipe
**Then** the task is removed from Upcoming and Core Data
**And** deletion behavior is identical across all views
**And** delete button styling is consistent
**And** animations are consistent
**And** error handling is consistent

---

## Epic 6: Simple Cumulative Analytics

Users can view completion statistics (tasks completed today/week/month) and basic trend comparisons in a separate analytics view. This provides progress visibility and behavioral insights without gamification, answering "today wasn't wasted" through simple data.

### Story 6.1: Create Analytics View Structure

As a user,
I want to access a separate Analytics view,
So that I can see my completion statistics without cluttering the task views.

**Acceptance Criteria:**

**Given** the app is open
**When** I navigate to the analytics section (could be a 4th tab or accessible via button)
**Then** an "Analytics" view is displayed
**And** the view title "Analytics" appears at the top
**And** the view uses clean, minimal design matching the rest of the app
**And** the view displays statistics in a scrollable list or card layout
**And** no task input field is present (this is view-only)
**And** the view uses .title3 for section headers and .body for data
**And** the view loads within 500ms even with 1000 tasks in database

### Story 6.2: Display Tasks Completed Today

As a user,
I want to see the count of tasks I completed today,
So that I have immediate feedback on my daily productivity.

**Acceptance Criteria:**

**Given** the Analytics view is displayed
**When** the view loads
**Then** a "Today" section shows:
- "X tasks completed today"
- The count is accurate (queries tasks where state="completed" and completedAt=today)
**And** the count updates in real-time if I switch to another view and complete more tasks
**And** the section uses Color.primary for the number (emphasis)
**And** the query completes within 100ms
**When** no tasks are completed today
**Then** the count shows "0 tasks completed today"
**And** the message is neutral, not judgmental

### Story 6.3: Display Tasks Completed This Week

As a user,
I want to see the count of tasks I completed this week,
So that I can understand my weekly rhythm and productivity patterns.

**Acceptance Criteria:**

**Given** the Analytics view is displayed
**When** the view loads
**Then** a "This Week" section shows:
- "X tasks completed this week"
- The count includes tasks completed from Monday-Sunday of current week
**And** the week boundary follows the device's locale settings (some locales start week on Sunday)
**And** the count is accurate (queries tasks where completedAt is within current week)
**And** the section is visually distinct from the "Today" section (spacing or divider)
**And** the query completes within 200ms

### Story 6.4: Display Tasks Completed This Month

As a user,
I want to see the count of tasks I completed this month,
So that I can see longer-term progress and momentum.

**Acceptance Criteria:**

**Given** the Analytics view is displayed
**When** the view loads
**Then** a "This Month" section shows:
- "X tasks completed this month"
- The count includes tasks completed from the 1st to the last day of the current month
**And** the count is accurate (queries tasks where completedAt is within current month)
**And** the section is visually distinct from previous sections
**And** the query completes within 300ms

### Story 6.5: Display Simple Completion Trends

As a user,
I want to see a basic comparison of this month vs last month,
So that I can see if I'm completing more or fewer tasks over time.

**Acceptance Criteria:**

**Given** the Analytics view is displayed
**When** the view loads
**Then** a "Trends" section shows:
- "X tasks this month, [up/down] from Y last month"
- Example: "45 tasks this month, up from 38 last month"
- Or: "32 tasks this month, down from 45 last month"
**And** the comparison is calculated correctly:
- "this month" = tasks completed in current month
- "last month" = tasks completed in previous month
**And** if last month is higher, the message says "down from"
**And** if last month is lower, the message says "up from"
**And** if equal, the message says "same as last month"
**And** if no data from last month, the message says "No data from last month"
**And** the trend direction uses subtle color: green for up, red for down, gray for same
**And** the query completes within 300ms

### Story 6.6: Implement Efficient Analytics Queries

As a developer,
I want analytics queries to be optimized,
So that the view loads quickly even with large datasets.

**Acceptance Criteria:**

**Given** the database contains up to 1000 tasks
**When** the Analytics view loads
**Then** all analytics queries complete within 500ms total
**And** queries use Core Data predicates efficiently (filtering by date ranges)
**And** queries count tasks without loading full entities (use COUNT queries)
**And** queries use background context to avoid blocking the UI
**And** the app memory footprint doesn't increase significantly during analytics
**And** analytics queries don't impact the performance of other views
**And** the view remains responsive during data loading

### Story 6.7: Maintain Historical Completion Data

As a developer,
I want to ensure completedAt timestamps are never lost,
So that analytics remain accurate over time.

**Acceptance Criteria:**

**Given** a task is marked as completed
**When** the completedAt timestamp is set
**Then** the timestamp is stored permanently in Core Data
**And** the timestamp is never cleared except when the task is marked incomplete
**And** the timestamp survives app restarts
**And** the timestamp survives iOS updates
**And** even if a task is deleted, its completion still counts toward historical analytics (or: decide if deletion removes from analytics)
**And** Core Data schema supports storing historical completion data indefinitely
**And** completedAt uses Date type with full datetime precision

### Story 6.8: Handle Edge Cases in Analytics

As a user,
I want analytics to handle edge cases gracefully,
So that I see sensible information even in unusual situations.

**Acceptance Criteria:**

**Given** no tasks have ever been completed
**When** viewing Analytics
**Then** all counts show "0 tasks completed [period]"
**And** the trends section shows "No data available yet"
**Given** the app was just installed today
**When** viewing Analytics
**Then** week and month counts are accurate based on completions since install
**And** last month comparison shows "No data from last month"
**Given** it's the 1st day of a new month
**When** viewing Analytics
**Then** "This Month" shows only today's completions
**And** "Last Month" shows the full previous month's completions
**Given** timezone changes (user travels)
**When** viewing Analytics
**Then** date boundaries use the device's current timezone
**And** historical data remains accurate

---

## Epic 7: Data Export Capability

Users can export all their task data to JSON format for backup, portability, and data ownership. The export integrates with iOS standard share sheet for saving to Files app or sharing to other apps.

### Story 7.1: Implement JSON Export Functionality

As a user,
I want to export all my task data to a JSON file,
So that I can back up my data or move it to another app.

**Acceptance Criteria:**

**Given** tasks exist in the database
**When** I trigger the export function
**Then** all tasks are serialized to JSON format including:
- id (UUID as string)
- text (task description)
- state (notStarted/active/completed)
- createdAt (ISO 8601 datetime string)
- updatedAt (ISO 8601 datetime string)
- completedAt (ISO 8601 datetime string or null)
- scheduledDate (ISO 8601 date string or null)
- sortOrder (integer)
**And** the JSON is well-formatted (pretty-printed with indentation)
**And** the JSON is valid and parseable
**And** the export includes all tasks (not just visible ones)
**And** the export completes within 2 seconds for 1000 tasks
**And** the JSON file is saved to a temporary location for sharing

### Story 7.2: Add Export Button to Settings or Menu

As a user,
I want to easily access the export function,
So that I can back up my data whenever I want.

**Acceptance Criteria:**

**Given** the app is open
**When** I navigate to a settings or options menu (could be a gear icon in nav bar)
**Then** an "Export Data" button is visible
**And** the button is clearly labeled
**And** the button is easily tappable (44pt minimum height)
**When** I tap "Export Data"
**Then** the export process begins
**And** a loading indicator appears if export takes >500ms
**And** the button is disabled during export to prevent duplicate taps

### Story 7.3: Integrate with iOS Share Sheet

As a user,
I want to share or save the exported JSON file using iOS standard sharing,
So that I can save to Files, iCloud, or share via AirDrop/Messages.

**Acceptance Criteria:**

**Given** the export JSON is generated
**When** export completes
**Then** the iOS share sheet appears automatically
**And** the share sheet shows standard iOS sharing options:
- Save to Files
- Save to iCloud Drive
- AirDrop
- Share via Messages/Mail
- Copy
- Other app-specific options
**And** the file is named descriptively: "Cmpe492-Tasks-Export-YYYY-MM-DD.json"
**And** the file includes the current date in the filename
**When** I select "Save to Files"
**Then** I can choose a location and the file saves successfully
**And** I can verify the file in the Files app afterward
**When** I select "Cancel" on the share sheet
**Then** the temporary export file is deleted
**And** I return to the app

### Story 7.4: Handle Export Errors Gracefully

As a developer,
I want export errors to be handled gracefully,
So that users get helpful feedback if something goes wrong.

**Acceptance Criteria:**

**Given** the export process is triggered
**When** JSON serialization fails (corrupted data, encoding error)
**Then** an alert appears: "Unable to export data. Please try again."
**And** the error is logged using os_log for debugging
**And** the app doesn't crash
**When** file writing fails (no storage space, permission denied)
**Then** an alert appears: "Unable to save export file. Please check device storage."
**And** the user can dismiss the alert and try again
**Given** export succeeds but share sheet fails to present
**Then** the export file is saved to a fallback location
**And** an alert explains where the file was saved

### Story 7.5: Ensure Export Data Completeness and Privacy

As a user,
I want the export to include all my data without exposing it insecurely,
So that I have a complete backup that respects my privacy.

**Acceptance Criteria:**

**Given** the export is generated
**When** reviewing the JSON contents
**Then** all tasks from all views (Inbox, Today, Upcoming, past) are included
**And** all timestamps are preserved with correct timezone information
**And** task order (sortOrder) is preserved
**And** no data is omitted or corrupted during export
**And** the export file uses standard iOS file security (respects device encryption)
**And** the temporary export file is deleted after sharing (no copies left behind)
**And** export respects iOS app sandboxing and doesn't access data from other apps
**And** no telemetry or external transmission occurs during export (local only)

### Story 7.6: Test Export with Various Data Sizes

As a developer,
I want to ensure export performs well with different dataset sizes,
So that users with many tasks don't experience slowdowns or failures.

**Acceptance Criteria:**

**Given** a database with 10 tasks
**When** exporting
**Then** export completes within 500ms
**Given** a database with 500 tasks
**When** exporting
**Then** export completes within 1 second
**Given** a database with 1000 tasks
**When** exporting
**Then** export completes within 2 seconds
**And** memory usage during export remains under 100MB
**And** the app remains responsive during export (doesn't freeze UI)
**And** export happens on background thread (doesn't block main thread)
**And** progress indicator shows during longer exports

### Story 7.7: Document JSON Export Format

As a developer,
I want to document the JSON export format,
So that users or developers can understand the structure for import or analysis.

**Acceptance Criteria:**

**Given** the export feature is implemented
**When** documentation is created (could be in-app help or README)
**Then** the JSON structure is documented with example:
```json
{
  "exportDate": "2026-02-11T15:30:00Z",
  "appVersion": "1.0.0",
  "tasks": [
    {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "text": "Review chapter 3 feedback",
      "state": "completed",
      "createdAt": "2026-02-10T09:15:00Z",
      "updatedAt": "2026-02-11T14:30:00Z",
      "completedAt": "2026-02-11T14:30:00Z",
      "scheduledDate": "2026-02-11",
      "sortOrder": 0
    }
  ]
}
```
**And** field meanings are explained
**And** date format (ISO 8601) is specified
**And** the documentation notes that import functionality is not included in MVP
