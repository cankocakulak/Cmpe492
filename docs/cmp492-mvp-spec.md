# Cmpe492 MVP Spec (Consolidated)

Date: 2026-02-14
Scope: MVP + Simple Analytics + JSON Export (Phase 1 + Epic 7)

## Product Goal
A personal, notes-speed task system that prevents abandonment by keeping capture friction near zero, preserving user agency over task lifecycle, and providing light validation that "today wasn't wasted." This is a clarity tool, not a productivity optimizer.

## Core Principles
- Notes app DNA: ultra-fast capture, minimal structure by default.
- Agency over automation: no automatic rollover; user decides what carries forward.
- Single manageable view: primary flows stay on one screen with shallow navigation.
- Progressive disclosure: keep tasks simple unless additional structure is needed.

## MVP Feature Set
- Instant capture (persistent input field, <3s entry).
- Three-view system: Inbox (unscheduled), Today, Upcoming (future).
- Drag-based organization: reorder within view and move across views.
- Task states: Not Started → Active → Completed (tap to advance).
- Completed tasks remain visible in Today.
- Manual scheduling: move to Today, Tomorrow, specific date.
- Deletion via swipe (full swipe to delete).
- Simple analytics: completed today / week / month + basic trend.
- JSON export with share sheet.

Out of scope: categories, recurring tasks, notes, widgets, Siri, notifications, iCloud sync.

## Information Architecture
- Main: Inbox, Today, Upcoming (horizontal swipe + segmented control).
- Secondary: Analytics (separate tab).

## Core Data Model (MVP)
Task
- id: UUID
- text: String
- createdAt: Date
- updatedAt: Date
- scheduledDate: Date? (nil = Inbox)
- completedAt: Date?
- stateRaw: Int16 (0 = notStarted, 1 = active, 2 = completed)
- sortOrder: Double (per-view ordering)

## Interaction Summary
- Capture: type + enter, auto-focus input on open.
- State: tap cycles Not Started → Active → Completed (tap again to reset if needed).
- Drag: reorder within view; drop on segmented header to move to view.
- Quick actions: swipe for delete, Today, Tomorrow, Schedule.
- Date picker: schedule to specific future date.

## Analytics (MVP)
- Completed today, this week, this month.
- Simple trend: compare this week vs last week, this month vs last month.

## Export
- Export JSON of all tasks with ISO-8601 dates.
- Accessible from Analytics via Export button.
- Documented format in `docs/export-format.md`.

## Non-Functional Requirements
- Fast: input and state changes <100ms perceived.
- Smooth: drag operations 60fps.
- Offline-first: Core Data only.
- Reliable: no data loss.
- iOS 15+.
