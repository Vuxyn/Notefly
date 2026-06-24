# Notefly: Project Context

> Read this file before doing anything. This is the single source of truth for
> the Notefly project: app identity, tech stack, architecture, conventions,
> and progress tracking all live here.

---

## App Identity

| Key          | Value                  |
|--------------|------------------------|
| App name     | Notefly                |
| Package name | `com.vuxyn.notefly`    |
| Platform     | Android only           |
| Min SDK      | 23 (Android 6.0)       |
| Target SDK   | 34 (Android 14)        |

---

## Problem Statement

A personal floating overlay notes app for Android. Built to keep quick notes
always accessible on top of any app: no switching, no context loss.
UX reference: U-Dictionary floating bubble.

---

## Tech Stack

- **Language**: Dart
- **Framework**: Flutter (stable channel)
- **Platform**: Android only

### Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_overlay_window: ^0.4.2   # floating bubble overlay
  hive: ^2.2.3                     # local NoSQL storage
  hive_flutter: ^1.1.0             # Flutter integration for Hive
  uuid: ^4.3.3                     # unique ID per note
  provider: ^6.1.2                 # state management

dev_dependencies:
  flutter_test:
    sdk: flutter
  hive_generator: ^2.0.1           # generates Hive adapters
  build_runner: ^2.4.9             # code generation runner
```

### Android Permissions

| Permission            | Purpose                                      |
|-----------------------|----------------------------------------------|
| `SYSTEM_ALERT_WINDOW` | Draw floating bubble on top of all apps      |
| `FOREGROUND_SERVICE`  | Keep bubble alive when app is in background  |

---

## Architecture

```
Notefly
├── Floating Bubble (always-on-top overlay)
│   ├── Draggable anywhere on screen
│   └── Badge counter (number of active notes)
│
└── Notes Panel (shown when bubble is tapped)
    ├── Note list with checkboxes (done / undone)
    ├── Input field to add a new note
    └── Filter tabs: All / Active / Done
```

### Layer Breakdown

```
UI Layer        -> widgets, screens (no business logic)
Provider Layer  -> state management, business logic
Data Layer      -> repository pattern, Hive storage
Overlay Layer   -> flutter_overlay_window entry point
```

### Data Flow

```
User action
  -> UI widget
    -> NoteProvider (business logic)
      -> NoteRepository (data access)
        -> Hive box (persistence)
```

---

## Data Model

### Note

| Field       | Type       | Description                  |
|-------------|------------|------------------------------|
| `id`        | `String`   | UUID: unique per note       |
| `content`   | `String`   | Note text content            |
| `isDone`    | `bool`     | Completion status            |
| `createdAt` | `DateTime` | Timestamp when note was created |

- Stored in Hive box: `'note_box'`
- Hive TypeId: `0`

---

## Folder Structure

```
notefly/
├── android/                        # Android-specific config
│   └── app/
│       └── src/main/
│           └── AndroidManifest.xml
├── lib/
│   ├── main.dart                   # app entry point + Hive init
│   ├── app.dart                    # MaterialApp setup
│   ├── core/
│   │   └── constants.dart          # app-wide constants
│   ├── data/
│   │   ├── models/
│   │   │   ├── note.dart           # Note model
│   │   │   └── note.g.dart         # generated Hive adapter (gitignored)
│   │   └── repositories/
│   │       └── note_repository.dart
│   ├── providers/
│   │   └── note_provider.dart
│   ├── overlay/
│   │   └── floating_bubble.dart    # overlay entry point
│   └── ui/
│       ├── screens/
│       │   └── notes_panel.dart
│       └── widgets/
│           ├── note_item.dart
│           └── filter_tabs.dart
├── test/
│   └── data/
│       └── note_repository_test.dart
├── .github/
│   ├── workflows/
│   │   ├── ci.yml
│   │   └── release.yml
│   ├── ISSUE_TEMPLATE/
│   │   ├── bug_report.md
│   │   └── feature_request.md
│   └── pull_request_template.md
├── .gitignore
├── AGENT.md
├── CHANGELOG.md
├── CONTRIBUTING.md
├── LICENSE                         # MIT
├── README.md
├── CONTEXT.md                      # this file
└── pubspec.yaml
```

---

## Naming Conventions

| Context          | Convention    | Example                                      |
|------------------|---------------|----------------------------------------------|
| Classes          | `PascalCase`  | `NoteRepository`, `FloatingBubble`           |
| Variables        | `camelCase`   | `noteList`, `isDone`                         |
| Constants        | `camelCase`   | `const maxNoteLength = 500`                  |
| Private members  | `_camelCase`  | `_notes`, `_loadNotes()`                     |
| Files            | `snake_case`  | `note_repository.dart`                       |
| Folders          | `snake_case`  | `data/`, `widgets/`, `providers/`            |
| Enums            | `PascalCase` type, `camelCase` values | `enum NoteFilter { all, active, done }` |
| Hive box names   | `snake_case` string | `'note_box'`                          |
| Provider classes | suffix `Provider` | `NoteProvider`                           |

---

## Code Style

- Max line length: **80 characters**
- Always use `const` where possible
- Prefer `final` over `var`
- No magic numbers: extract to named constants
- No commented-out code in commits
- One widget per file
- Prefer `StatelessWidget` unless local state is strictly needed
- Use `Future<void>` for async methods that return nothing
- Always `await` futures: no fire-and-forget unless explicitly intentional
- Handle errors with `try/catch`: never swallow exceptions silently

### Import Order

```dart
// 1. Dart SDK
import 'dart:async';

// 2. Flutter
import 'package:flutter/material.dart';

// 3. Third-party
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

// 4. Local
import 'package:notefly/data/models/note.dart';
```

### Comments

- Language: **English**
- Public API -> `///` doc comments
- Inline logic -> `//` single-line comments
- Never explain what the code obviously does

---

## Tools

| Tool               | Purpose                                      |
|--------------------|----------------------------------------------|
| Git                | Version control                              |
| GitHub             | Remote repo + Releases                       |
| Conventional Commits | Commit message standard                    |
| Semantic Versioning | Release versioning (`v1.0.0`)               |
| GitHub Actions     | CI/CD automation                             |
| Android Studio / VS Code | IDE                                  |
| Android device / emulator | Testing target                       |

### GitHub Actions

| Workflow       | Trigger                  | Action                              |
|----------------|--------------------------|-------------------------------------|
| `ci.yml`       | Push to any branch       | `flutter analyze` + `flutter test`  |
| `release.yml`  | Push tag `v*`            | Build APK + upload to Releases      |

---

## Methodology

**Extreme Programming (XP)**

Cycle: **Plan -> Code -> Test -> Commit -> Next**

### Branching Strategy

```
main        <- stable, production-ready (protected)
develop     <- integration branch
feature/*   <- one branch per feature/iteration
```

### Commit Convention

```
feat: add floating bubble drag behavior
fix: resolve note not persisting after app restart
chore: add hive dependency
docs: update README with install steps
test: add note repository unit tests
refactor: extract note item into separate widget
```

### Versioning

```
v1.0.0  -> Fase 4 complete, production release
v0.x.x  -> development milestones
```

---

## Phases & Iterations

### Phase 1 - Foundation
- [x] 1.1 - Repo structure (gitignore, README, LICENSE, CONTRIBUTING, templates)
- [x] 1.2 - Flutter project init (clean boilerplate, folder structure)
- [x] 1.3 - Dependencies & config (pubspec.yaml, AndroidManifest)
- [x] 1.4 - Data layer (Note model + Hive adapter, NoteRepository)
- [x] 1.5 - CI/CD (GitHub Actions ci.yml + release.yml)

**Exit criteria**: project runs with `flutter run`, data model ready

### Phase 2 - Core Feature
- [ ] 2.1 - Floating bubble (overlay, draggable, permission request)
- [ ] 2.2 - Notes panel UI (list, checkbox, add note input)
- [ ] 2.3 - Wire state (NoteProvider + NoteRepository connected to UI)

**Exit criteria**: APK installable, bubble appears, notes can be added and checked

### Phase 3 - Feature Complete
- [ ] 3.1 - Filter tabs (All / Active / Done)
- [ ] 3.2 - Badge counter on bubble
- [ ] 3.3 - Delete note

**Exit criteria**: all planned features working end-to-end

### Phase 4 - Polish
- [ ] 4.1 - Animations (panel open/close, note add)
- [ ] 4.2 - Edge snap for bubble
- [ ] 4.3 - Haptic feedback
- [ ] 4.4 - Dark mode
- [ ] 4.5 - App icon
- [ ] 4.6 - Release v1.0.0

**Exit criteria**: v1.0.0 APK published to GitHub Releases

---

## Progress

- [x] Planning complete
- [x] Phase 1 - Foundation
- [/] Phase 2 - Core Feature
- [ ] Phase 3 - Feature Complete
- [ ] Phase 4 - Polish

**Current**: Phase 2, Iteration 2.1
