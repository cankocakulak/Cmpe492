---
stepsCompleted: ['step-01-init', 'step-02-discovery', 'step-03-success', 'step-04-journeys', 'step-05-domain', 'step-06-innovation', 'step-07-project-type', 'step-08-scoping', 'step-09-functional', 'step-10-nonfunctional', 'step-11-polish']
inputDocuments: 
  - '_bmad-output/planning-artifacts/product-brief-Cmpe492-2026-02-11.md'
  - '_bmad-output/brainstorming/brainstorming-session-2026-02-11.md'
workflowType: 'prd'
briefCount: 1
brainstormingCount: 1
researchCount: 0
projectDocsCount: 0
classification:
  projectType: 'mobile_app'
  domain: 'general'
  complexity: 'low-medium'
  projectContext: 'greenfield'
---

# Product Requirements Document - Cmpe492

**Author:** Mcan
**Date:** 2026-02-11

## Success Criteria

### User Success

**Primary Success Indicator: Sustained Daily Use Without Abandonment**

Continuous use for 3+ months without falling into the "death spiral" (accumulation → overwhelm → abandonment) that kills traditional to-do apps.

**Week 1 Validation:**
- Task capture feels effortless (under 3 seconds from thought to saved)
- No psychological friction before opening app
- Daily use happens naturally without conscious effort

**Month 1 Validation:**
- 30+ consecutive days of active use (habit formed)
- Notes app usage for tasks drops significantly
- Core interactions feel intuitive and fast
- No multi-day gaps indicating breakage

**Month 3+ Validation (Critical Success Milestone):**
- Sustained use proven - still actively using after 90+ days
- Notes app fully displaced for task management
- Can skip days and return without guilt or intimidation
- System survives life interruptions (travel, illness, busy periods)

### Business Success

**Personal ROI - "This Was Worth Building"**

Success measured by meaningful life improvements rather than commercial metrics:

**Subjective Life Improvements:**
- **Reduced cognitive load:** Tasks no longer living in head creating background anxiety
- **Visible life balance:** Can see when too focused on work vs. other life areas through cumulative category data
- **Progress validation:** Evidence of meaningful time usage over weeks/months reduces "drift anxiety"
- **Sustainable execution:** Fewer tasks disappear silently, repeated postponements become visible and actionable

**Cumulative Value Realization:**
- **Week 2-4:** First behavioral insights emerge from cumulative data
- **Month 2:** Life balance patterns become visible (category distribution over time)
- **Month 3:** Can identify execution patterns and behavioral trends that were previously invisible
- **Month 6+:** Historical data reveals meaningful life patterns and progress trajectories

**Critical Success Factor:**
User continues using after thesis/project deadline pressure ends - proving it's valuable beyond crisis mode.

### Technical Success

**Performance & Reliability:**
- App remains responsive under normal load (100+ tasks)
- No lag during core interactions (task creation, state changes, reorganization)
- Data persistence reliable - zero task loss
- Core interactions feel as fluid as typing in Notes app

**Architecture Success:**
- Local-first data persistence (Core Data) fully functional
- Data model supports future sync capability (UUID-based, proper timestamps)
- Clean separation of concerns (MVVM architecture)
- JSON export capability for data portability and backup

**Interaction Success:**
- Core task operations are intuitive and effortless
- Visual feedback is clear and immediate
- App feels native to iOS (follows platform conventions)
- Minimal cognitive load for common operations

### Measurable Outcomes

**Engagement Metrics:**
- App opens per day: 3-5 times (target)
- Task captures per day: 5-10 tasks (target)
- Daily view check: Morning and evening routine established
- End-of-day review: 80%+ completion rate

**Retention Metrics:**
- 30-day retention: Must maintain daily use
- 90-day retention: Proves sustainable momentum
- Return-after-gap: Successfully resume after 2-3 day breaks without abandonment

**Value Realization Metrics:**
- Time to first cumulative insight: Within 2-3 weeks
- Cumulative data showing patterns: By week 4
- Life balance visibility: Monthly category distribution meaningful by month 2
- Behavioral pattern recognition: Postponement trends, category balance, execution rhythms visible

**Quality Metrics:**
- Capture speed: Consistently under 3 seconds
- Daily cognitive load: Today view never exceeds ~15 active tasks
- Zero data loss incidents
- Seamless return after gaps (no intimidating backlog)

## User Journeys

### Primary User: Self-Directed Builder (Personal Use)

**User Profile:**
Context-switcher running multiple parallel projects (thesis, personal projects, learning, social) without external structure. Already productive and self-motivated, needs visibility and clarity rather than motivation. Currently uses Notes app for task capture.

### Journey 1: Daily Task Management - Happy Path

**Morning - Task Planning (7:00 AM):**
- Opens app to see Today view
- Sees 5 tasks from yesterday that were carried forward
- Types new task "Review chapter 3 feedback" - hits enter (2 seconds)
- Types "Buy groceries" - hits enter (2 seconds)
- Types "Call mom about weekend" - hits enter (2 seconds)
- Reorders tasks by dragging - puts thesis work at top
- Marks "Review chapter 3 feedback" as Active to focus on it first
- Closes app - ready to start day with clarity

**Throughout Day - Dynamic Capture (Various Times):**
- 10:00 AM: Remembers something during meeting - opens app, types "Research Swift concurrency patterns", saves to Inbox (2 seconds)
- 2:00 PM: Completes "Review chapter 3 feedback" - taps to mark completed, stays visible with strikethrough
- 3:00 PM: Wants to focus on groceries - marks "Buy groceries" as Active
- 4:30 PM: Completes groceries - marks completed
- 6:00 PM: Task "Research Swift concurrency" feels like tomorrow work - moves from Inbox to Tomorrow view

**Evening - Daily Review (9:00 PM):**
- Opens app to see Today view
- Sees 3 completed tasks (strikethrough, visible)
- Sees 2 incomplete tasks ("Call mom", "Prepare presentation slides")
- Decides "Call mom" can wait - moves to Tomorrow
- "Prepare presentation slides" is important - keeps for tomorrow via conscious choice
- Feels satisfied seeing completed tasks - "today wasn't wasted"
- Closes app with clear mind

### Journey 2: Weekly Pattern Discovery

**End of Week 2 (Saturday Morning):**
- Uses app daily for 14 days straight
- Opens app, notices pattern: lots of "Business" tasks completed, very few "Hobby" tasks
- Realizes life balance is off - too work-focused
- Looks at cumulative completion data - 40 business tasks, 5 hobby tasks, 3 learning tasks
- Decides to consciously add more hobby tasks for next week
- Creates tasks: "Play guitar for 30 min", "Read fiction book chapter"

### Journey 3: Month-Long Sustained Use

**End of Month 1 (Day 30):**
- Still using app daily without conscious effort
- Has captured 150+ tasks over the month
- Completed 120 tasks, some moved to future, some discarded
- Opens cumulative analytics view
- Sees category breakdown: Business 60%, Learning 20%, Hobby 10%, Friends 5%, Random 5%
- Sees weekly completion trend line - relatively stable
- Notices some tasks get postponed repeatedly - becomes visible
- Adjusts behavior based on these insights
- Notes app completely replaced for task management

### Journey 4: Multiple Context Switching (Typical Tuesday)

**9:00 AM - Thesis Work Context:**
- Opens app, filters view to "Learning" category
- Sees only thesis and research-related tasks
- Marks "Write methodology section" as Active
- Works on thesis for 2 hours

**1:00 PM - Personal Project Context:**
- Switches to "Business" category filter
- Sees personal app project tasks
- Marks "Implement Core Data schema" as Active
- Codes for 3 hours

**6:00 PM - Life Admin Context:**
- Clears category filter to see all Today tasks
- Sees "Pay utility bill" and "Schedule dentist appointment"
- Quickly completes both
- Sees completed tasks from multiple contexts today

## Mobile App Specific Requirements

### Project-Type Overview

**Platform:** iOS Native Application (SwiftUI)

Native iOS app built with SwiftUI for iPhone, targeting users who need instant task capture and management on their primary mobile device. Local-first architecture for maximum speed and reliability, with all data stored on-device using Core Data.

**Target iOS Version:** iOS 15+
**Supported Devices:** iPhone (primary), iPad (secondary/adaptive layout)

### Technical Architecture Considerations

**Local-First Architecture:**
- All data stored locally using Core Data
- No server dependency for core functionality
- Instant app launch and task operations
- Zero network latency for all user interactions
- Complete offline functionality

**Data Model Design:**
- UUID-based task identifiers (sync-ready for future phases)
- Proper timestamp tracking (createdAt, updatedAt, completedAt, scheduledDate)
- Core Data entities: Task, Category
- JSON export capability for data portability and backup
- Schema designed to support future iCloud sync without migration

**Performance Requirements:**
- App launch: Under 1 second on modern devices
- Task creation: Under 100ms from tap to persistence
- View transitions: Smooth 60fps animations
- Drag operations: Responsive with no perceptible lag
- Memory footprint: Efficient handling of 500+ tasks

### Platform Requirements

**MVP (Phase 1) - Essential iOS Features:**

**Core iOS Integration:**
- Native SwiftUI interface following iOS design patterns
- Standard iOS gestures (tap, drag, swipe)
- Keyboard management for text input
- App lifecycle management (background/foreground transitions)
- Data persistence across app launches

**App Store Compliance:**
- Privacy manifest documenting data handling practices
- Local-only data storage (no external data transmission in MVP)
- Free personal tool (no in-app purchases in MVP)
- Standard App Store review guidelines compliance

**Device Permissions (MVP):**
- No special permissions required for MVP
- Standard file system access (implicit for Core Data)

**Post-MVP (Phase 2+) - Enhanced iOS Features:**

**Optional Device Permissions:**
- Notifications permission (for local notifications - end-of-day review reminders)
- Siri & Shortcuts access (for quick task capture via voice)

**iOS-Native Integrations:**
- Today Widget (glanceable task view and quick capture)
- Share Sheet extension (add tasks from Safari/other apps)
- Siri Shortcuts (voice-based task capture)
- Haptic feedback system (tactile interaction feedback)

**Notification Strategy:**
- Local notifications only (no push notification server required)
- Optional end-of-day review reminders
- Smart timing based on user behavior patterns
- User-controlled notification preferences

### Offline Mode

**Complete Offline Functionality:**
- 100% offline operation for all MVP features
- No network dependency for any core functionality
- All data persists locally on device
- Fast, reliable operation regardless of connectivity

**Data Portability:**
- JSON export for manual backup
- Standard iOS file sharing for exported data
- Future: iCloud sync for multi-device (Phase 3+)

### Implementation Considerations

**Development Stack:**
- Language: Swift 5.5+
- UI Framework: SwiftUI
- Data Layer: Core Data
- Architecture: MVVM (Model-View-ViewModel)
- No external dependencies for MVP

**Code Organization:**
- Clean separation: Models, Views, ViewModels
- Reusable SwiftUI components
- Testable business logic
- Clear data flow patterns

**UI/UX Principles:**
- Typography-first design (minimal visual chrome)
- Native iOS feel (standard controls and patterns)
- Smooth animations for state transitions
- Clear visual feedback for all interactions
- Single-screen simplicity (avoid navigation complexity)

**Testing Strategy:**
- Core Data persistence testing
- Task state management logic testing
- Basic UI interaction testing
- Performance testing (drag operations, large task lists)

**Deployment:**
- TestFlight for initial testing
- Personal App Store distribution (free)
- Standard iOS app lifecycle (updates via App Store)

### iOS-Specific Constraints

**Storage:**
- Local device storage only (Core Data SQLite file)
- Estimated storage: ~1MB for 1000 tasks with metadata
- No cloud storage in MVP
- User manages device storage through iOS settings

**Battery & Performance:**
- Minimal battery impact (local-only operations)
- No background processing in MVP
- Efficient Core Data queries
- Optimized SwiftUI view updates

**Privacy & Security:**
- All data stays on device (maximum privacy)
- No external data transmission
- No analytics or telemetry in MVP
- User controls all data through iOS settings (backup, deletion)
- Respects iOS system privacy features

## Project Scoping & Phased Development

### MVP Strategy & Philosophy

**MVP Approach:** Problem-Solving MVP

The MVP validates the core hypothesis: **Can Notes-app-simple interface with time awareness and task states replace Notes for task management while enabling sustained use?**

Focus on proving three critical assumptions:
1. **Frictionless capture** - Can we achieve sub-3-second task entry?
2. **Sustained use** - Will the conscious task lifecycle prevent abandonment?
3. **Cumulative value** - Does simple progress visibility provide meaningful insights?

**Success Validation Period:** 21-30 days of continuous use

**MVP Philosophy:**
- Lean feature set focused on core value proposition
- No feature bloat that adds complexity
- Defer nice-to-haves to validate essentials first
- "Notes app DNA" maintained throughout

**Resource Requirements:**
- Solo developer
- iOS development (Swift/SwiftUI)
- 6-8 weeks development time
- No external dependencies or services

### MVP Feature Set (Phase 1)

**Core User Journeys Supported:**

1. **Daily Task Management** - Full support
   - Morning planning and task entry
   - Throughout-day dynamic capture
   - Evening review with conscious carry-forward

2. **Weekly Pattern Discovery** - Partial support
   - Task completion tracking over time
   - Simple cumulative view (e.g., "You completed 45 tasks this month")
   - No category analytics (deferred to Phase 2)

3. **Month-Long Sustained Use** - Data foundation only
   - All data captured and stored
   - Basic cumulative statistics visible
   - Full analytics visualizations in Phase 2

4. **Multiple Context Switching** - Not supported in MVP
   - No category filtering initially
   - All tasks visible together in unified view
   - Deferred to Phase 2 if category implementation proves complex

**Must-Have Capabilities:**

**Task Capture & Management:**
- Persistent input field (always accessible, 2-3 second capture)
- Task creation with instant persistence
- Task state management (Not Started → Active → Completed)
- Task deletion
- Visual state differentiation (color, opacity, or icon)

**Organization & Views:**
- Three-view system: Inbox, Today, Upcoming
- Drag-to-reorder tasks within views
- Drag/move tasks between views (intuitive rescheduling)
- Completed tasks remain visible on Today view
- Clean single-screen interface

**Time Management:**
- Date assignment for tasks
- Manual scheduling (move to Today, Tomorrow, specific date)
- No automatic rollover - conscious carry-forward only
- Tomorrow quick action

**Cumulative Data (Simplified):**
- Task completion history stored
- Simple cumulative statistics view:
  - Total tasks completed (week/month)
  - Tasks completed today
  - Basic completion trend (e.g., "45 tasks this month, up from 38 last month")
- Foundation for future analytics

**Technical Foundation:**
- iOS app (SwiftUI, native)
- Local Core Data persistence
- UUID-based tasks (sync-ready schema)
- JSON export capability
- Responsive performance (no lag during interactions)

**Out of Scope for MVP:**
- Categories and category filtering (Phase 2)
- Task notes/details (Phase 2)
- Recurring tasks (Phase 2)
- Advanced analytics visualizations (Phase 2)
- iOS native integrations: widget, Siri, share sheet (Phase 2)
- Notifications (Phase 2)
- iCloud sync (Phase 3)

### Post-MVP Features

**Phase 2: Enhanced Execution System (Month 2-4)**

**Categories & Life Balance:**
- User-defined categories (Business, Learning, Hobby, Friends, Random, Uncategorized)
- Optional category assignment
- Category-based filtering (show only specific category)
- Cumulative category distribution over time
- Life balance insights ("60% Business, 20% Learning...")

**Advanced Analytics & Insights:**
- Weekly/monthly completion trend visualizations
- Category balance heatmaps
- Behavioral pattern recognition (postponement trends, execution rhythms)
- "Today wasn't wasted" comprehensive validation
- Momentum tracking showing progress trajectories

**Enhanced Task Management:**
- Task notes/details (progressive disclosure via tap-to-expand)
- Link detection and previews
- End-of-day review workflow with guided carry-forward
- Recurring tasks with day pattern selector

**iOS Native Integration:**
- Share sheet extension (add from Safari/other apps)
- Siri shortcuts for quick capture
- Today widget (glanceable stats and quick input)

**Phase 3: Life Management Platform (Month 6+)**

**Advanced Cumulative Intelligence:**
- Long-term behavioral learning (6+ months of data)
- Smart category suggestions based on patterns
- Context-based task grouping ("when I'm bored" lists)
- Workload awareness (actual vs. planned capacity)
- Predictive insights from historical behavior

**Advanced Features:**
- Haptic feedback system for satisfying interactions
- Advanced recurring patterns (habit mode vs. work mode)
- Template system for recurring project patterns
- Historical retrospectives (monthly/yearly reviews)

**Ecosystem Features:**
- iCloud sync for multi-device use
- Advanced local notifications (smart, optional)
- API/integration ecosystem (calendar sync, automation)
- Export/backup enhancements

**Long-Term Philosophy:**
Depth over breadth. Add features that deepen clarity and cumulative insights, reduce cognitive load, never add complexity for its own sake. Always maintain "Notes app DNA" - simple by default, powerful when needed.

### Risk Mitigation Strategy

**Technical Risks:**

**Risk:** Drag interactions feel laggy or unnatural
**Mitigation:** 
- Prototype drag UX early in development (week 1-2)
- Test on older devices to ensure performance
- Fallback: Use swipe gestures instead of drag if performance issues

**Risk:** Core Data complexity delays MVP
**Mitigation:**
- Start with minimal schema (Task entity only)
- Add complexity incrementally
- Use Core Data code generation for simplicity
- Fallback: UserDefaults with JSON if Core Data proves too complex

**Risk:** SwiftUI learning curve impacts timeline
**Mitigation:**
- Leverage existing SwiftUI knowledge and tutorials
- Use standard SwiftUI components where possible
- Prototype complex interactions separately
- Timeline buffer: 6-8 weeks accounts for learning

**Market Risks:**

**Risk:** Conscious task lifecycle doesn't prevent abandonment as theorized
**Mitigation:**
- Validate early (within week 2-3 of use)
- Monitor daily usage patterns closely
- Fallback: Add optional automatic rollover as configurable setting if needed
- Success metric: 21+ days continuous use proves viability

**Risk:** Users want categories immediately, can't validate without them
**Mitigation:**
- MVP tracks all completion data even without categories
- Can add categories in quick Phase 1.5 release if blocking validation
- Monitor personal usage: if context-switching feels painful, prioritize categories sooner

**Resource Risks:**

**Risk:** Development takes longer than 6-8 weeks
**Mitigation:**
- Cut cumulative view to Phase 1.5 if timeline pressure
- Launch with just core task management, validate with personal use
- Absolute minimum: Task capture + Today view + manual scheduling (4 weeks)

**Risk:** Solo development burnout or competing priorities
**Mitigation:**
- MVP is small enough to complete in focused sprints
- Personal use case ensures sustained motivation
- Can pause and resume without team coordination issues
- Built for yourself first = natural prioritization

**Contingency MVP (Absolute Minimum):**
If resources become severely constrained, the absolute minimum viable product:
- Task capture (input field + save)
- Today view (list of today's tasks)
- Task completion (tap to mark done)
- Manual date assignment

This ultra-lean version could be built in 3-4 weeks and would still test the core "Notes app + time" hypothesis.

## Functional Requirements

### Task Capture & Creation

- **FR1:** User can create a new task by typing text and pressing enter
- **FR2:** User can create tasks in under 3 seconds from app open to task saved
- **FR3:** User can create tasks without specifying any additional information (date, category, notes)
- **FR4:** User can create multiple tasks in rapid succession without navigation
- **FR5:** User can delete tasks they have created
- **FR6:** System persists all created tasks immediately upon entry

### Task Organization & Management

- **FR7:** User can view tasks organized in three separate views: Inbox, Today, and Upcoming
- **FR8:** User can reorder tasks within a view by dragging
- **FR9:** User can move tasks between views (Inbox → Today, Today → Upcoming, etc.) by dragging
- **FR10:** User can see all completed tasks within the Today view alongside incomplete tasks
- **FR11:** System maintains task order as specified by user drag operations
- **FR12:** User can access a persistent input field from any view for quick task capture

### Time & Schedule Management

- **FR13:** User can assign a specific date to any task
- **FR14:** User can move tasks to "Today" with a single action
- **FR15:** User can move tasks to "Tomorrow" with a single action
- **FR16:** User can move tasks to a future specific date via date picker
- **FR17:** User can move tasks to the timeless Inbox (unscheduled state)
- **FR18:** System does not automatically move incomplete tasks to the next day (no automatic rollover)
- **FR19:** User must explicitly choose which incomplete tasks to carry forward to future dates

### Task State & Progress Tracking

- **FR20:** User can mark a task as "Active" to indicate current focus
- **FR21:** User can mark a task as "Completed" 
- **FR22:** User can see visual differentiation between Not Started, Active, and Completed task states
- **FR23:** System tracks the completion timestamp for all completed tasks
- **FR24:** System maintains completed tasks in visible state on Today view (not hidden or archived)
- **FR25:** User can change a task's state from any valid state to another (e.g., Active back to Not Started)

### Data Visualization & Insights

- **FR26:** User can view total count of tasks completed today
- **FR27:** User can view total count of tasks completed this week
- **FR28:** User can view total count of tasks completed this month
- **FR29:** User can view basic completion trend comparison (e.g., "45 this month, up from 38 last month")
- **FR30:** System maintains historical completion data for cumulative analysis
- **FR31:** User can access a simple cumulative statistics view separate from daily task views

### Data Management & Persistence

- **FR32:** System persists all task data locally on the device
- **FR33:** System maintains data across app launches and device restarts
- **FR34:** User can export all task data to JSON format
- **FR35:** System ensures zero data loss during normal operation
- **FR36:** System stores task metadata including creation date, update date, scheduled date, and completion date
- **FR37:** System assigns unique identifiers to all tasks for future sync capability

### User Experience & Interface

- **FR38:** User can launch the app and see the Today view by default
- **FR39:** User can navigate between Inbox, Today, and Upcoming views
- **FR40:** System provides visual feedback during drag operations
- **FR41:** System responds to all user interactions without perceptible lag
- **FR42:** User can see all task information within a single screen view (no complex navigation required)

## Non-Functional Requirements

### Performance

**Response Time Requirements:**

- **NFR1:** App launch to interactive Today view must complete within 1 second on modern iOS devices (iPhone 12 or newer)
- **NFR2:** Task creation from keystroke to visible persistence must complete within 100 milliseconds
- **NFR3:** Task state changes (Not Started → Active → Completed) must update UI within 50 milliseconds
- **NFR4:** Drag operations must maintain 60fps framerate during interaction with no perceptible lag
- **NFR5:** View transitions (Inbox → Today → Upcoming) must complete within 200 milliseconds
- **NFR6:** Cumulative statistics view must load and display data within 500 milliseconds for up to 1000 tasks

**Throughput Requirements:**

- **NFR7:** System must support rapid task entry (5+ tasks within 15 seconds) without performance degradation
- **NFR8:** System must maintain responsive performance with task lists containing up to 500 active tasks

**Resource Efficiency:**

- **NFR9:** App memory footprint must remain under 100MB during typical usage
- **NFR10:** App must not cause battery drain exceeding 5% per hour of active use
- **NFR11:** Local data storage must remain under 10MB for typical usage (1000 tasks with metadata)

### Reliability

**Data Integrity:**

- **NFR12:** System must achieve zero data loss during normal operation
- **NFR13:** System must persist task data immediately upon creation (no delayed save)
- **NFR14:** System must maintain data integrity across app crashes or force quits
- **NFR15:** System must maintain data integrity across iOS updates and device restarts

**Stability:**

- **NFR16:** App crash rate must be below 0.1% of sessions
- **NFR17:** System must gracefully handle Core Data errors without data loss
- **NFR18:** System must recover from background app termination without user-visible disruption

**Availability:**

- **NFR19:** App must function 100% offline with no network dependency
- **NFR20:** App must be available immediately upon device unlock (no loading delays)

### Usability

**Ease of Use:**

- **NFR21:** Task capture flow must require no more than 2 user actions (type + enter)
- **NFR22:** All primary features must be accessible within 2 taps from app launch
- **NFR23:** Task organization actions (drag, reorder, move) must be discoverable without tutorial
- **NFR24:** Visual state differentiation must be immediately comprehensible without explanation

**Learnability:**

- **NFR25:** New user must be able to create and complete a task within 30 seconds of first launch
- **NFR26:** User must understand three-view system (Inbox, Today, Upcoming) within first 5 minutes of use
- **NFR27:** No tutorial or onboarding required to use core functionality

**Consistency:**

- **NFR28:** All user interactions must follow standard iOS gesture patterns
- **NFR29:** Visual design must follow iOS Human Interface Guidelines
- **NFR30:** System behavior must be predictable and consistent across all views

### Security & Privacy

**Data Protection:**

- **NFR31:** All task data must remain on local device with no external transmission
- **NFR32:** Task data must be protected by iOS file system encryption when device is locked
- **NFR33:** App must respect iOS app sandboxing for data isolation
- **NFR34:** Exported JSON data must follow standard iOS file sharing security model

**Privacy:**

- **NFR35:** App must collect zero telemetry or analytics in MVP
- **NFR36:** App must not require internet connectivity or external accounts
- **NFR37:** All data remains under user control via iOS device management
