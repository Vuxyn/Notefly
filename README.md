# Notefly

Notefly is a personal floating overlay notes application built for Android. It keeps your quick notes always accessible on top of other applications, eliminating the need to switch contexts when writing down ideas or checklist items.

The user experience is inspired by overlay bubbles, allowing drag-and-drop movement anywhere on the screen and tapping to show the full notes panel.

## Features

- Floating bubble overlay that stays on top of other apps
- Draggable bubble with active note counter badge
- Collapsible notes panel to list, add, and toggle notes
- Persistence using Hive local database
- Filter tabs for All, Active, and Completed notes

## Tech Stack

- Language: Dart
- Framework: Flutter (Stable channel)
- Platform: Android (Min SDK 23, Target SDK 34)
- State Management: Provider
- Storage: Hive

## Getting Started

### Prerequisites

- Flutter SDK (stable channel)
- Android SDK and command-line tools
- Android Device or Emulator running Android 6.0 (API level 23) or higher

### Setup and Running

1. Clone the repository.
2. Run package retrieval:
   ```bash
   flutter pub get
   ```
3. Run code generation for Hive adapters (when models are added):
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
4. Run the application on a connected device:
   ```bash
   flutter run
   ```

## Architecture

The project follows a clean layered architecture:

- UI Layer: Flutter widgets and screens (strictly presentation)
- Provider Layer: Business logic and state management
- Data Layer: Repository pattern accessing Hive database storage
- Overlay Layer: System-level window overlay entry points

## License

This project is licensed under the MIT License. See the LICENSE file for details.
