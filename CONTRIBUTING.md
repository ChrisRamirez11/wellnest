# Contributing to TaskNest

Thanks for taking the time to contribute. This guide covers how to report
issues, propose changes and get a pull request merged.

## Before you start

- Search existing issues and pull requests to avoid duplicates.
- For larger changes, open an issue first so we can agree on the approach.

## Development setup

1. Install Flutter 3.44+ with Dart 3.12.
2. Fetch dependencies:

   ```sh
   flutter pub get
   ```

3. If you change Isar collections (`RoutineModel`, `DateModel`) or the ARB
   files, regenerate code:

   ```sh
   dart run build_runner build --delete-conflicting-outputs
   flutter gen-l10n
   ```

4. Run the app on an Android or iOS device/emulator:

   ```sh
   flutter run
   ```

## Before opening a pull request

Run the full verification suite and make sure it passes:

```sh
dart format --set-exit-if-changed .
flutter analyze
flutter test
```

Never weaken, skip or delete tests or lint rules to make the suite pass.

## Code guidelines

- Follow the existing feature-first layout:
  `lib/feature/<feature>/{data,business,presentation}`. Shared code goes in
  `lib/core/`.
- Use Riverpod 2 (`ChangeNotifierProvider`); do not introduce a second
  state-management approach.
- Keep business logic out of widgets. Widgets render state and forward events.
- Prefer `final`, immutable models and `const` constructors.
- Put user-facing strings in `lib/l10n/app_en.arb`; do not hardcode UI text.
- Do not edit generated files (`*.g.dart`, `*.freezed.dart`, generated l10n).
- Use the project logger or `debugPrint`, never `print`.
- After an `await`, check `mounted` before using `BuildContext`. Dispose
  controllers, streams and focus nodes.
- Add packages with `flutter pub add`, not by editing `pubspec.yaml` by hand.

## Tests

- Add a test for every behavior change.
- Unit tests for logic, `testWidgets` for UI behavior.
- Name test files `<file>_test.dart` and mirror the `lib/` structure under
  `test/`.
- Prefer fakes over mocks. No real network or real time in tests.

## Commit and pull request style

- Keep changes focused; one topic per pull request.
- Write descriptive commit messages in the imperative mood
  (for example `add retry action to reminder scheduling`).
- Describe what changed, why, and how you verified it in the PR description.
- Link the issue the pull request closes, if any.

## Reporting bugs

Include:

- A short description of the problem and what you expected.
- Steps to reproduce.
- Flutter and Dart versions (`flutter --version`).
- Platform and device.
- Relevant logs or screenshots.

## Questions

Open a GitHub issue in the repository.

## License

By contributing, you agree that your contributions are licensed under the
[MIT License](LICENSE).
