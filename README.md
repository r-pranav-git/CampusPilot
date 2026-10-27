# CampusPilot — Student Productivity & Placement Companion

CampusPilot is a Flutter mobile app concept for students who want to manage academic tasks, placement applications, interview preparation, and skill development in one place.

## Features
- Dashboard with task and application summaries
- Add, complete, and delete academic tasks
- Track placement applications and their stages
- Track interview preparation goals
- Skill progress tracker
- Local persistence using `shared_preferences`
- Responsive Material 3 UI with bottom navigation

## Tech stack
- Flutter / Dart
- Material 3
- `shared_preferences` for local persistence

## Run locally
1. Install Flutter and set up an Android emulator.
2. Create a project:
   ```bash
   flutter create campuspilot
   cd campuspilot
   ```
3. Replace the generated `pubspec.yaml` with this bundle's `pubspec.yaml`.
4. Copy the `lib/` directory from this bundle into the project.
5. Run:
   ```bash
   flutter pub get
   flutter run
   ```

## Notes
This version stores data locally on the device. It does not yet include Firebase authentication or cloud sync. Those can be added as a future enhancement. Do not describe cloud sync as implemented until it has been built and tested.
