# TaskNest

TaskNest is a small, offline-first task and habit tracker built with Flutter.
The main branch contains a cleaned-up, local-only app: routines, a calendar
heatmap, local reminders and onboarding, with no accounts, ads or cloud
services.

This `technical-challenge` branch is the fork used for the Flutter technical
challenge. It keeps the local app intact and adds the one challenge requirement
the base app did not cover: **an initial load of tasks from a public API, with
network errors visible to the user**.

## How to run

Requirements: Flutter 3.44+ with Dart 3.12. Android or iOS, portrait only.

```sh
flutter pub get
flutter run
```

On first launch the onboarding runs. Tapping **Finish** stores the routines you
selected and then fetches the sample task list from
`https://jsonplaceholder.typicode.com/todos`. The app works offline: if the
request fails, the tasks still come from the local database and the network
error is shown in a SnackBar on the home screen.

If you change the Isar collections (`RoutineModel`, `DateModel`), regenerate
their code before running:

```sh
dart run build_runner build --delete-conflicting-outputs
```

Verify everything:

```sh
dart format --set-exit-if-changed .
flutter analyze
flutter test
```

## How the challenge is covered

| # | Requirement | Implementation |
|---|---|---|
| 1 | Task list, create form with validation, change state | `RoutinesScreen` lists routines (active and ended), `CreateRoutineScreen` validates name, week days and target before saving, and today's routines are completed from the home calendar (`SmallRoutineTile`): tap a task, increment an amount or run a timer. |
| 2 | Local storage, works offline | Isar Community collections `RoutineModel` and `DateModel` plus `shared_preferences` for small flags. Every screen reads from the local database. |
| 3 | Initial load from a public API with visible network errors | `RoutineRemoteDatasourceImpl` GETs JSONPlaceholder `/todos`; `RoutineRepositoryImpl.seedFromApi` maps each todo to a task routine and stores it locally; `SeedFromApi` is called when onboarding finishes; `RoutineProvider.apiSeedError` drives a SnackBar shown by the home screen. |
| 4 | Clear architecture and dependency injection | Feature-first Clean-ish layers (`data` / `business` / `presentation`), repositories returned as `Either<Failure, T>`, use cases per operation, Riverpod providers that receive their repository through the constructor. |
| 5 | At least three tests | 17 tests: datasource mapping and HTTP failures, repository seeding and failure mapping, use case forwarding, onboarding widget flow and the existing utility tests. |
| 6 | README with run steps, decisions, next steps and AI usage | This document. |

Honest note: the base app models recurring routines rather than a flat task
entity, and its list groups routines by active/ended instead of offering a
literal "pending / in progress / done" filter. The API import maps
`completed` to the routine's `finished` flag and creates daily task routines;
a dedicated three-state task model is listed under next steps.

## The API seed, and why it lives in this fork

The original project depended on Supabase for auth and backup, an AI coach and
AdMob. Those features were removed step by step (commits `step 1.x` to
`step 3.x`) because they are out of scope for an offline habit tracker and their
services no longer work. The result is the clean base app.

Requirement 3 of the challenge asks for an initial network load, which by
definition needs an external service. Keeping it in its own fork keeps the
clean app dependency-free while this branch documents and implements exactly
the challenge behaviour:

1. `RoutineRemoteDatasourceImpl.fetchTodos()` calls
   `GET https://jsonplaceholder.typicode.com/todos` using an injectable
   `http.Client`.
2. Each todo becomes a `RoutineEntity`: `title` → `name`, `completed` →
   `finished`, type `task`, daily recurrence, blue colour, target count 1.
3. `RoutineRepositoryImpl.seedFromApi()` persists the mapped routines through
   the existing Isar datasource and returns `NetworkFailure` when the request
   fails or the payload is invalid.
4. `SeedFromApi` is the use case; the onboarding **Finish** handler awaits it
   after saving the user's selected routines.
5. A failure never blocks navigation. `RoutineProvider` exposes
   `apiSeedError`, and `Skeleton` shows it once in a SnackBar on the home
   screen.

Seeding supplements the routines chosen during onboarding. It runs on every
completed onboarding, so repeating onboarding would import the tasks again;
de-duplication is part of next steps.

## Architecture decisions

- **Feature-first folders**: `lib/feature/<feature>/{data,business,presentation}`
  and `lib/core/` for shared code.
- **Riverpod 2** with `ChangeNotifierProvider` as the only state management
  approach. Widgets render state and forward events; logic lives in providers
  and use cases.
- **Clean-ish layering**: datasources → repositories → use cases →
  providers → widgets. `dartz` `Either<Failure, T>` makes failures explicit.
- **Isar Community** for routines and dates; the API seed writes through the
  same local datasource as the rest of the app, so the UI never talks to the
  network directly.
- **HTTP**: `package:http` behind `RoutineRemoteDatasource`, with the client
  injected so tests use `MockClient` and never touch the network.
- **Localization**: all user-facing strings go through `l10n`, including the
  API error message.
- **Errors**: `ServerException`/`CacheException` in the data layer are mapped
  to `NetworkFailure`/`CacheFailure` for the presentation layer.

## Tests

```sh
flutter test
```

- `test/feature/routines/data/datasources/remote/routine_remote_datasource_test.dart`:
  todo mapping, HTTP status errors, transport errors and invalid payloads with
  a fake HTTP client.
- `test/feature/routines/data/repositories/routine_repository_impl_test.dart`:
  seeding persists locally, network failures map to `NetworkFailure`, write
  failures map to `CacheFailure`.
- `test/feature/routines/business/usecases/seed_from_api_test.dart`: the use
  case forwards results and failures.
- `test/feature/onboarding/presentation/screens/onboarding_seed_test.dart`:
  finishing onboarding calls the seed use case, and a network error is
  recorded without blocking navigation.
- `test/core/utils_test.dart`: the original utility tests.

## What I would do with more time

- Add a dedicated `Task` entity with an explicit pending / in progress / done
  state and a filter in the list, keeping recurring routines separate.
- De-duplicate imported tasks (for example by remote id) and make seeding a
  one-time, idempotent sync.
- Replace the one-shot SnackBar with a retry action or a persistent banner,
  plus request timeouts and pull-to-refresh.
- Add background sync, conflict resolution and pagination for larger lists.
- Cover the whole app with widget tests for the create form, state changes and
  the home-screen error path, and add CI running format, analyze and tests.

## How I used AI

- **What I asked for**: first a plan to strip the original project back to a
  simple offline habit tracker (remove Supabase auth and backup, the AI coach,
  ads, paywall and feedback screens), then a plan and implementation for
  challenge requirement 3 on a dedicated fork, with a commit per step and a
  rewritten README.
- **What I accepted**: the feature-first layering and `Either` error handling
  already used by the project; a remote datasource behind an interface; a
  `seedFromApi` repository method plus use case; mapping todos to daily task
  routines; a non-blocking error shown on the home screen; and the proposed
  test set using fakes and `MockClient`.
- **What I corrected or verified**: added the Android `INTERNET` permission so
  release builds can reach the API; changed `RoutineProvider` to accept a
  `RoutineRepository` so it can be tested with a fake instead of Isar;
  regenerated the l10n files with `flutter gen-l10n` instead of editing
  generated code; used the in-memory async `shared_preferences` platform for
  the widget test; and ran `dart format`, `flutter analyze` and `flutter test`
  after every step (all green, 17 tests).
- **What I adjusted**: the widget test asserts the seeding call and the
  recorded network error rather than mocking the entire home shell just to
  assert the SnackBar, because that would have required far more test
  scaffolding than value.
