# AGENTS.md — Flutter

Project spec: `docs/spec.md` (what the project is). Read it before planning or coding.

## Verify (run all, in order, before calling any step done)
1. `dart format --set-exit-if-changed .`
2. `flutter analyze`
3. `flutter test`

If the step touches annotated code (freezed, json_serializable, riverpod_generator, drift, isar...): run `dart run build_runner build --delete-conflicting-outputs` first.
Do not run `flutter run` or release builds (long-running). Ask the user.

## Project-specific
- State management: Riverpod 2 (`ChangeNotifierProvider`) plus feature use cases.
- Routing: named routes from `lib/main.dart`.
- Backend / data layer: offline only; Isar Community (`RoutineModelSchema`, `DateModelSchema`) + `shared_preferences`.
- Min SDK / platforms: Flutter default min SDK; Android + iOS, portrait.

## Structure
- `lib/feature/<feature>/{data,business,presentation}`
- `lib/core/` for shared code (theme, notifications, preferences, utils)
- `test/` mirrors `lib/`

## Conventions
- Null safety always. Prefer `final`, immutable models, `const` constructors.
- No business logic in widgets. Widgets render state and forward events.
- Do not introduce a second state-management approach. Use Riverpod.
- Add packages with `flutter pub add`, never by hand-editing pubspec, and only if the plan says so.
- Never edit generated files (`*.g.dart`, `*.freezed.dart`, `*.gr.dart`, generated l10n).
- No `print`; use the project logger or `debugPrint` for local diagnostics.
- After an `await`, check `mounted` before using `BuildContext`. Dispose controllers, streams and focus nodes.
- User-facing strings go through l10n (arb), not hardcoded. English only.

## Tests
- Unit tests for logic, widget tests (`testWidgets`) for UI behavior. Name: `<file>_test.dart`.
- Prefer fakes over mocks. No real network or real time.

## Lessons (add a rule here every time the agent fails the same way twice)
- (empty)
