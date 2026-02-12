# Story 1.1: Initialize Xcode Project with Core Data

Status: review

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a developer,
I want to create a new Xcode SwiftUI project with Core Data support,
So that the technical foundation is ready for building the task management app.

## Acceptance Criteria

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

## Tasks / Subtasks

- [x] Create new Xcode iOS App project with SwiftUI + Core Data (AC: All)
  - [x] Open Xcode → File → New → Project → iOS → App
  - [x] Configure: Product Name: Cmpe492, Interface: SwiftUI, Language: Swift, Storage: Core Data
  - [x] Set iOS Deployment Target to 15.0
  - [x] Verify project structure includes Cmpe492App.swift, ContentView.swift, Persistence.swift, Cmpe492.xcdatamodeld
- [x] Verify project builds and runs successfully (AC: build without errors)
  - [x] Build the project (Cmd+B)
  - [x] Run in Simulator (iPhone 14 or newer)
  - [x] Confirm no build errors or warnings
  - [x] Confirm Core Data stack initializes without crashes
- [x] Initialize Git repository with Xcode .gitignore (AC: Git repository initialized)
  - [x] Run `git init` in project directory (repository was already initialized)
  - [x] Create .gitignore for Xcode (added comprehensive Xcode entries to existing .gitignore)
  - [x] Add initial commit: "Initial Xcode SwiftUI project with Core Data" (commit 1febee7)
  - [x] Verify .xcodeproj, DerivedData, and build artifacts are ignored

## Dev Notes

### Architecture Patterns and Constraints

**Technical Stack (CRITICAL - From Architecture Document):**
- **Language:** Swift 5.5+ (modern concurrency with async/await supported)
- **UI Framework:** SwiftUI (declarative UI, iOS 15+)
- **Persistence:** Core Data with SQLite backing store
- **Architecture Pattern:** MVVM (Model-View-ViewModel)
- **Minimum Deployment Target:** iOS 15.0
- **Primary Device:** iPhone (portrait primary, landscape supported)
- **Development Tool:** Xcode 13+ with SwiftUI live previews

**Project Initialization Steps (From Architecture):**
1. File → New → Project → iOS → App
2. Configuration:
   - Product Name: **Cmpe492**
   - Interface: **SwiftUI** (not UIKit)
   - Language: **Swift**
   - Storage: **Core Data** (MUST enable during creation)
   - iOS Deployment Target: **15.0**
3. Initial project structure should include:
   - `Cmpe492App.swift` - App entry point (@main)
   - `ContentView.swift` - Initial view (will be replaced with TodayView later)
   - `Persistence.swift` - Core Data stack (NSPersistentContainer)
   - `Cmpe492.xcdatamodeld` - Core Data model file
   - `Assets.xcassets/` - Asset catalog
   - `Preview Content/` - SwiftUI preview assets

**Core Data Foundation:**
- NSPersistentContainer will be auto-generated in Persistence.swift
- Container name should match "Cmpe492"
- ViewContext should have `automaticallyMergesChangesFromParent = true` for real-time updates
- This story establishes the foundation - schema design happens in Story 1.2

**Performance Requirements (From NFRs):**
- App launch must complete within 1 second on modern iOS devices (iPhone 12+)
- This means Core Data stack initialization must be fast (no heavy setup)
- Memory footprint must remain under 100MB during typical usage
- Core Data persistence must be optimized from day one

**Native iOS Excellence Principle:**
- Use ONLY Apple's native SwiftUI and Core Data APIs
- NO third-party libraries or frameworks in MVP
- Follow iOS Human Interface Guidelines strictly
- The app must feel indistinguishable from Apple-built apps (Notes, Reminders, Mail)

### Project Structure Notes

**Standard Xcode Generated Structure:**
```
Cmpe492/
├── Cmpe492App.swift           # App entry point with @main
├── ContentView.swift           # Default view (temporary - will become TodayView)
├── Cmpe492.xcdatamodeld       # Core Data schema (empty initially)
├── Persistence.swift           # Core Data stack setup
├── Assets.xcassets/            # Images, colors, app icon
├── Preview Content/            # Sample data for SwiftUI previews
│   └── Preview Assets.xcassets
└── Info.plist                  # App configuration
```

**Future MVVM Structure (Story 1.3+):**
This will be organized later into:
```
Cmpe492/
├── App/
│   └── Cmpe492App.swift
├── Models/           # Core Data entities (Story 1.2+)
├── Views/            # SwiftUI views (Story 1.4+)
├── ViewModels/       # Business logic (Story 1.3+)
├── Components/       # Reusable UI components
├── Services/         # Data services, export
├── Utilities/        # Helpers, design tokens
└── Resources/        # Assets, data models
```

**⚠️ DO NOT over-engineer in this story:** Just create the standard Xcode project. MVVM restructuring happens in Story 1.3.

**Alignment with Unified Project Structure:**
- Standard Xcode structure is the correct starting point for iOS native apps
- Follows Apple's conventions which aligns with "Native iOS Excellence"
- No conflicts with typical project structure - this IS the standard for iOS

**Version Control Setup:**
- Initialize Git immediately after project creation
- Use standard Xcode .gitignore template (ignores build artifacts, DerivedData, .xcuserdata)
- Commit message: "Initial Xcode SwiftUI project with Core Data"
- Essential files to commit:
  - `*.swift` source files
  - `Cmpe492.xcdatamodeld` directory
  - `Assets.xcassets` (excluding generated contents.json if large)
  - `Info.plist`
  - `.gitignore`
- Files to exclude (via .gitignore):
  - `DerivedData/`
  - `*.xcuserdata`
  - `*.xcworkspace/xcuserdata/`
  - Build artifacts

### References

**Source: PRD (Product Requirements Document)**
- [Source: _bmad-output/planning-artifacts/prd.md#Mobile-App-Specific-Requirements]
  - iOS 15+ target confirmed
  - Native SwiftUI required (no cross-platform frameworks)
  - Core Data for local-first persistence
  - Zero external dependencies in MVP

- [Source: _bmad-output/planning-artifacts/prd.md#Technical-Success]
  - Local-first data persistence (Core Data) fully functional
  - Data model supports future sync capability (UUID-based, proper timestamps)
  - Clean separation of concerns (MVVM architecture)

**Source: Architecture Document**
- [Source: _bmad-output/planning-artifacts/architecture.md#Starter-Template-Evaluation]
  - Detailed Xcode project initialization steps
  - Standard iOS App template with SwiftUI + Core Data
  - Command-line Git initialization guidance
  - Project structure documentation

- [Source: _bmad-output/planning-artifacts/architecture.md#Architectural-Decisions-Provided-by-iOS-Xcode]
  - Swift 5.5+ with modern concurrency support
  - SwiftUI native components
  - Core Data framework fully integrated
  - Xcode build system and testing framework

**Source: UX Design Specification**
- [Source: _bmad-output/planning-artifacts/ux-design-specification.md#Design-System-Choice]
  - Apple Human Interface Guidelines + Native SwiftUI Components
  - Native-first approach with zero external dependencies
  - SwiftUI List, TextField, TabView, Button components

**Source: Epics Document**
- [Source: _bmad-output/planning-artifacts/epics.md#Story-1.1-Initialize-Xcode-Project-with-Core-Data]
  - Complete acceptance criteria
  - Xcode 13+ requirement
  - Standard project structure specification
  - Git repository initialization requirement

**Source: Architecture Requirements (from Epics)**
- [Source: _bmad-output/planning-artifacts/epics.md#Starter-Template-&-Project-Initialization]
  - Use standard Xcode SwiftUI + Core Data app template
  - Enable Core Data support during project creation
  - Configure SwiftUI as UI framework
  - Set iOS 15+ as minimum deployment target
  - Configure Swift 5.5+ as language version

## Dev Agent Record

### Agent Model Used

Claude Sonnet 4.5 (via Cursor)

### Debug Log References

No debugging required - standard Xcode project initialization completed successfully.

### Completion Notes List

✅ **Story 1.1 Implementation Complete**

**Implemented:**
1. Created new Xcode iOS App project with SwiftUI + Core Data support
   - Product Name: Cmpe492
   - Interface: SwiftUI (declarative UI framework)
   - Language: Swift 5.5+
   - Storage: Core Data enabled during project creation
   - iOS Deployment Target: 15.0
   - Generated standard project structure with all required files

2. Verified project builds and runs successfully
   - Build completed without errors or warnings
   - App launched successfully in iOS Simulator
   - Core Data stack initializes correctly via PersistenceController
   - No crashes or initialization errors

3. Initialized Git version control
   - Git repository was already initialized (existing repo)
   - Added comprehensive Xcode .gitignore entries to existing .gitignore
   - Removed user-specific state file (UserInterfaceState.xcuserstate) from tracking
   - Created initial commit: "Initial Xcode SwiftUI project with Core Data" (commit 1febee7)
   - Verified proper ignore patterns for build artifacts and user-specific files

**Technical Foundation Established:**
- SwiftUI + Core Data template provides NSPersistentContainer boilerplate
- Standard Xcode project structure ready for MVVM architecture (Story 1.3)
- Core Data model file (Cmpe492.xcdatamodeld) ready for schema design (Story 1.2)
- Version control properly configured with platform-appropriate ignores

**Next Story:** 1.2 - Design Core Data Task Entity Schema

### File List

**Created/Modified Files:**
- `.gitignore` - Added comprehensive Xcode ignore patterns (xcuserdata, DerivedData, build/, etc.)
- `Cmpe492/Cmpe492.xcodeproj/project.pbxproj` - Xcode project configuration file
- `Cmpe492/Cmpe492/Cmpe492App.swift` - App entry point with @main
- `Cmpe492/Cmpe492/ContentView.swift` - Default SwiftUI view (will be replaced with TodayView in Story 1.4)
- `Cmpe492/Cmpe492/Persistence.swift` - Core Data stack with NSPersistentContainer
- `Cmpe492/Cmpe492/Cmpe492.xcdatamodeld/` - Core Data model file (empty schema, to be populated in Story 1.2)
- `Cmpe492/Cmpe492/Assets.xcassets/` - Asset catalog for images, colors, app icon
- `Cmpe492/Cmpe492/Preview Content/` - SwiftUI preview assets

**Removed from Git Tracking:**
- `Cmpe492/Cmpe492.xcodeproj/project.xcworkspace/xcuserdata/mcan.xcuserdatad/UserInterfaceState.xcuserstate` - User-specific state file (now properly ignored)
