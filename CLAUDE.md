# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

Core Flutter commands:
- `flutter pub get` - Install dependencies (run after checkout or pubspec changes)
- `flutter run -d chrome` - Run on web for quick testing
- `flutter run` - Run on default device (mobile/desktop)
- `flutter test` - Execute unit and widget tests in `test/`
- `flutter test integration_test` - Run end-to-end tests (slower but comprehensive)
- `flutter analyze` - Lint code using `flutter_lints` configuration
- `dart format .` - Format code following Flutter conventions

Database generation (when modifying Drift schema):
- `dart run build_runner build --delete-conflicting-outputs` - Regenerate Drift database files

## Architecture Overview

This is a gamified daily quest/habit tracker Flutter app targeting mobile, desktop, and web platforms. The app uses a medieval/fantasy theme with quest-like task management.

### Core Structure
- **Main Entry**: `lib/main.dart` - App initialization with landscape orientation lock and background audio
- **Hub Screen**: `lib/main_hub_screen.dart` - Central navigation hub showing quest progress and owned decorations
- **Quest Screens**: `lib/home_screen.dart` (daily), `lib/weekly_screens.dart`, `lib/streak_screens.dart`
- **Shared UI**: `lib/widgets.dart` - Reusable components like quest cards and navigation
- **Models**: `lib/models.dart` - Domain objects (Quest, QuestStatus, CharacterState)
- **Constants**: `lib/constants.dart` - Color palette, UI metrics, initial quest data

### Data Layer
- **Database**: Drift ORM with SQLite backend
  - `lib/services/drift_database.dart` - Schema definitions (Quests, WeeklyQuests, StreakQuests, OwnedItems, Badges, AppStates)
  - `lib/services/database_service.dart` - Business logic layer with CRUD operations and game mechanics
  - Platform-specific connections via conditional imports (`drift_connection_web.dart`/`drift_connection_native.dart`)
- **Current Schema Version**: 7 (includes migration logic for schema upgrades)

### Key Features
- **Quest System**: Daily/weekly/streak quests with progress tracking
- **Level System**: XP-based progression (base 100 XP + 25 per level, 50 XP per quest completion)
- **Badge System**: Achievements for completing multiple quests
- **Decoration System**: Collectible items (stars, flowers, butterflies, bows) for customization
- **Sticker System**: Placeable decorations on screens with persistence
- **Background Audio**: Game-style background music (disabled in tests and web)

### Services
- `DatabaseService` - Singleton for all data operations, handles daily/weekly resets
- `BackgroundAudioService` - Manages background music playback
- `GeminiService` - AI integration for generating quest icons/rewards (Firebase Cloud Functions)

### Testing Strategy
- Unit/widget tests in `test/` directory
- Integration tests in `integration_test/` for full app flows
- Automated test detection to disable audio and other platform features

### Platform Considerations
- **Orientation**: Locked to landscape mode
- **Web Support**: Full compatibility with conditional imports for Drift
- **Audio**: Native platforms only (disabled on web and in tests)

## Code Style Guidelines

- Follow `flutter_lints` rules from `analysis_options.yaml`
- Use two-space indentation
- `UpperCamelCase` for classes, `lowerCamelCase` for methods/variables, `snake_case` for files
- Import order: Dart SDK, packages, then relative paths
- Korean commit messages are acceptable (e.g., "레벨 업 시스템 구현")
- Prefer focused widgets over large monolithic components

## Asset Management

- Runtime assets in `assets/` directory
- Declare all assets in `pubspec.yaml` under `flutter.assets`
- Icon generation via `flutter_launcher_icons` package
- Reference design assets for maintaining visual consistency

## Database Schema Notes

When modifying the Drift database:
1. Update table definitions in `drift_database.dart`
2. Increment `schemaVersion` in `AppDatabase`
3. Add migration logic in `onUpgrade` method
4. Run `dart run build_runner build --delete-conflicting-outputs`
5. Test migration paths thoroughly

## Common Patterns

- **State Management**: StatefulWidget with database callbacks
- **Data Flow**: Database → Service Layer → UI with async/await
- **Error Handling**: Try-catch with fallback states
- **Quest Progress**: Progress/target tracking with completion states
- **Persistence**: Key-value storage in AppStates table for app-wide settings