# Repository Guidelines
## Project Structure & Module Organization
Daily Quest Helper is a Flutter app targeting mobile, desktop, and web. Core UI and state live in `lib/`, with feature screens split across files such as `home_screen.dart`, `main_hub_screen.dart`, and shared widgets in `widgets.dart`. Domain models and custom painters stay with their consumers to keep paint logic discoverable. Services for Drift persistence, Gemini calls, and audio control reside in `lib/services/`. Runtime assets, sprites, and audio loops belong in `assets/` and must be declared in `pubspec.yaml`. Unit and widget specs live in `test/`, end-to-end flows in `integration_test/`, while `cloud_function/` holds companion Firebase Functions code and `design2/` stores reference designs.

## Build, Test & Development Commands
- `flutter pub get` - install dependencies before running.
- `flutter run -d chrome` - web smoke test; swap device id as needed.
- `flutter test` - run unit/widget suites in `test/`.
- `flutter test integration_test` - execute e2e coverage; slower but required pre-release.
- `dart run build_runner build --delete-conflicting-outputs` - refresh Drift generated files.
- `flutter analyze` - lint with `flutter_lints`.

## Coding Style & Naming Conventions
Follow `flutter_lints` defaults from `analysis_options.yaml`. Use two-space indentation, `UpperCamelCase` for classes, `lowerCamelCase` for members, and `snake_case` for files. Order imports as Dart SDK, packages, then relative paths. Prefer focused widgets; share logic via `lib/services/` or new helpers instead of globals. Run `dart format .` and re-check `flutter analyze` before pushing.

## Testing Guidelines
Name specs `*_test.dart` mirroring the target file. Favor widget tests with stubbed services; keep randomness out. Use `integration_test/` for flows spanning multiple screens. Run `flutter test` pre-push; add the integration suite before a release or schema change. Log flaky behavior instead of silently rerunning.

## Commit & Pull Request Guidelines
Commit summaries stay short (<72 chars) and may be Korean (`레벨 업 시스템 구현`). Add extra detail on following lines when needed. Reference issues (`#123`), mention affected screens, and attach screenshots for UI work. PRs should list scope, tests you ran, and request a second review when touching `lib/services/` or Drift schema files.
