# Repository Guidelines

## Project Structure & Module Organization
This is a Flutter app. Core app code lives in `lib/`, with features grouped by area:
- `lib/main.dart`: app entry point.
- `lib/models/`: data models.
- `lib/screens/`: UI screens/pages.
- `lib/services/`: data access and business logic.
- `lib/theme/`: theming and styling.

Platform-specific scaffolding is in `android/`, `ios/`, `web/`, `macos/`, `windows/`, and `linux/`. Shared assets are in `assets/` (currently `assets/data.json`).

## Build, Test, and Development Commands
Run these from the repo root:
- `flutter pub get`: install dependencies.
- `flutter run`: run the app on a connected device/emulator.
- `flutter analyze`: static analysis using `analysis_options.yaml`.
- `flutter test`: run tests (create tests first; see below).
- `flutter build apk` or `flutter build ios`: build release artifacts for mobile.

## Coding Style & Naming Conventions
Follow Dart/Flutter conventions with 2-space indentation. Keep files lower_snake_case (e.g., `schedule_service.dart`), classes in PascalCase, and variables/functions in lowerCamelCase. Lint rules come from `package:flutter_lints` via `analysis_options.yaml`. Format code with `dart format .` before commits.

## Testing Guidelines
No `test/` directory is present yet. When adding tests, place them under `test/` and name files with the `_test.dart` suffix (e.g., `test/schedule_service_test.dart`). Use `flutter_test` (already in `dev_dependencies`). There are no defined coverage requirements yet.

## Commit & Pull Request Guidelines
Commit history shows short, imperative messages (e.g., “Create README”, “Avance: Reporte de horarios”). Keep messages concise and descriptive; Spanish or English is acceptable, but be consistent within a series.

Pull requests should include:
- A brief summary of changes and rationale.
- Linked issues or task IDs when applicable.
- UI screenshots or screen recordings for visual changes.
- Notes on how to test (commands or device info).

## Configuration & Assets
Dependencies are managed in `pubspec.yaml`. If you add assets, also register them under the `flutter/assets` section in `pubspec.yaml` and keep paths in sync with the filesystem.
