# PLAN — WellNest → TaskNest (local habit tracker)

Decisions locked with the user:
1. Keep onboarding.
2. Keep local notifications.
3. English only (drop es/fr/ja and the language selector).
4. Keep the timed routine with sound/vibration.
5. Keep a minimal About screen; delete Feedback.
6. Rename from now on: pubspec `task_nest`, display `TaskNest`, id `com.chris.tasknest`.

Goal: an offline-first habit tracker with no accounts, no remote sync, no AI and no monetization.
Out of scope (handled later in a fork): the technical challenge items (public API seed, pending/in-progress/done filters, README, etc.).

## Steps

- [x] 0.1 Document scope, add baseline unit tests and format the codebase.
- [x] 1.1 Remove monetization and ads (Adapty, paywall, premium, AdMob, app-open ad).
- [x] 1.2 Remove AI Coach, Axio/Rive and the nav entry point.
- [x] 1.3 Remove Supabase auth and remote backup/restore.
- [x] 1.4 Remove Feedback/community; keep a minimal About.
- [x] 2.1 Simplify shell/navigation and settings to local options only.
- [ ] 2.2 Clean onboarding (no paywall, English-only copy).
- [ ] 2.3 Keep timer sound/vibration; drop unused interaction deps only.
- [ ] 3.1 Prune dependencies, assets, constants and preferences.
- [ ] 3.2 Prune l10n to English only and delete dead code.
- [ ] 3.3 Rename app/package to TaskNest and update docs.

## Verify (each step)
1. `dart format --set-exit-if-changed .`
2. `flutter analyze`
3. `flutter test`

Regenerate with `dart run build_runner build --delete-conflicting-outputs` if annotated/Isar code changes.
