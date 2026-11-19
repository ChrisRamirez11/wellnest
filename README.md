# TaskNest

**A small, offline-first habit tracker built with Flutter.**

![Flutter](https://img.shields.io/badge/Flutter-3.44%2B-02569B?logo=flutter&logoColor=white)
![Platforms](https://img.shields.io/badge/platforms-Android%20%7C%20iOS-lightgrey)
![License: MIT](https://img.shields.io/badge/license-MIT-yellow.svg)

TaskNest helps you build daily routines without accounts, ads or cloud
services. Everything — routines, daily progress and reminders — lives on your
device.

## Features

- **Three routine types**: simple tasks, amount-based goals and countdown timers.
- **Daily tracking**: check tasks, increment amounts or run a timer for the day.
- **Calendar heatmap**: see your progress over time and open any day's routines.
- **Local reminders**: per-routine alarms plus morning and night notifications.
- **Guided onboarding**: pick default routine suggestions and your day boundaries.
- **100% offline**: no accounts, no ads, no tracking, no backend.
- **English-only UI** with all strings in ARB localization files.

## Screenshots

_Screenshots coming soon._

## Getting started

### Requirements

- Flutter 3.44+ with Dart 3.12
- Android or iOS device/emulator (portrait only)

### Run

```sh
flutter pub get
flutter run
```

On first launch the onboarding runs and lets you pick default routines and your
day boundaries. After that, the home calendar shows each day's routines; tap a
task, increment an amount or start a timer to track it.

### Code generation

Isar collections and localizations are generated. Regenerate after changing
`RoutineModel`, `DateModel` or the ARB files:

```sh
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
```

### Verify

```sh
dart format --set-exit-if-changed .
flutter analyze
flutter test
```

## Project structure

```text
lib/
├── core/                          # Theme, notifications, preferences, shared utils and widgets
├── feature/
│   ├── calendar/                  # Heatmap, daily routine list, countdown page
│   ├── dates/                     # Per-day tracking: data, business, presentation
│   ├── flutter_heatmap_calendar/  # Vendored heatmap widget
│   ├── onboarding/                # First-run flow
│   ├── routines/                  # Routine CRUD, use cases and onboarding defaults
│   ├── settings/                  # Notifications and About
│   └── skeleton/                  # App shell and bottom navigation
├── l10n/                          # English ARB file and generated localizations
└── main.dart                      # Entry point and named routes
```

Each feature follows `data / business / presentation`:

- `data`: models, datasources and repository implementations.
- `business`: entities, repository contracts and use cases.
- `presentation`: screens, widgets and Riverpod providers.

## Architecture

- **Feature-first layout** with shared code under `lib/core/`.
- **Riverpod 2** (`ChangeNotifierProvider`) is the only state management
  approach. Widgets render state and forward events; logic lives in providers
  and use cases.
- **Clean-ish layering**: datasources → repositories → use cases → providers →
  widgets. `dartz`'s `Either<Failure, T>` makes failures explicit.
- **Local storage**: Isar Community (`RoutineModel`, `DateModel`) plus
  `shared_preferences` for small flags.
- **Fully local**: the app makes no network requests; there is no HTTP client
  or remote datasource.
- **Localization**: every user-facing string goes through `l10n`, with the
  English source in `lib/l10n/app_en.arb`.

## Tests

```sh
flutter test
```

`test/core/utils_test.dart` contains the 6 unit tests that cover the shared
utilities: `formatDuration`, `stringToTimeOfDay`, `canUpdateCheckbox` and
`capitalizeFirstLetter`.

## Contributing

Contributions are welcome. Read [CONTRIBUTING.md](CONTRIBUTING.md) for the
workflow, code style and test expectations.

## License

Released under the [MIT License](LICENSE).
