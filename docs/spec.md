# TaskNest — Spec

## Goal
TaskNest is a small, offline-first habit tracker for people who want to build daily routines without accounts, ads or cloud services. Everything lives on the device.

## Scope v1
- Create, edit and delete routines (task, amount or timed).
- Daily tracking: check a task, increment an amount or run a countdown timer.
- Calendar/heatmap view with per-day progress and a daily routine list.
- Local reminders per routine and morning/night notifications.
- First-run onboarding with default routine suggestions and start/end-of-day times.
- Minimal settings: notifications and About.

## Out of scope (for now)
- Accounts, authentication, cloud sync or remote backup.
- AI coach/chat.
- Monetization (paywall, premium, ads).
- Feedback/community screens.
- Languages other than English.

## Technical decisions
- Stack / framework + version: Flutter 3.44+ / Dart 3.12, package `task_nest`.
- State management / architecture: Riverpod 2 (`ChangeNotifierProvider`) with feature-first `lib/feature/<feature>/{data,domain,business,presentation}` layering and `dartz` use cases.
- Backend / data: none; Isar Community local database (`RoutineModelSchema`, `DateModelSchema`) plus `shared_preferences` for small flags.
- Auth: none.
- Hosting / distribution: local builds only.

## Data model (rough)
- `RoutineModel`: id, name, weekly days, created date, type (task/amount/timed), target count/duration, color, alarm time, optional end date.
- `DateModel`: one entry per tracked day with the routine snapshots for that day and the completed count.

## Constraints
- Must work fully offline; no environment variables or external services.
- Android and iOS portrait, local notifications and exact alarms.
- English-only UI.

## Done criteria
- The app starts and completes onboarding with no network access.
- Routines can be created, edited, deleted and completed day by day.
- Timed routines play sound/vibration and can be paused/resumed.
- `dart format --set-exit-if-changed .`, `flutter analyze` and `flutter test` pass.
