---
name: widget-test
description: >
  Add or update Flutter widget tests in this repository using the existing test layout,
  Riverpod provider overrides, generated localization, shared theme setup, and FVM test
  commands. Use when a task asks for widget tests, UI regression coverage, test coverage for
  a screen/component, or when implementation work changes visible Flutter behavior.
allowed-tools: Bash Read Grep Glob Edit Write
model: claude-sonnet-4-6
---

# Flutter Template Widget Tests

Use this skill when adding focused widget coverage for a screen, shared component, or UI state in
this Flutter template.

## Read First
- `AGENTS.md`
- `docs/PROJECT_OVERVIEW.md`
- `docs/PROJECT_GUIDELINES.md`
- Nearby tests under `test/`
- The widget, provider, and state files being covered

## When To Add Widget Tests
- A shared widget gets new behavior, styling states, callbacks, or accessibility expectations.
- A feature screen adds meaningful loading, empty, error, or success states.
- A bug fix changes what the user sees or can tap.
- A regression would be cheap to catch with a `pumpWidget` test.

Do not add broad snapshot-style tests that only restate the widget tree. Prefer behavior and
contract checks: visible text, enabled/disabled states, callbacks, navigation events, empty/error
rendering, and provider-driven state transitions.

## Test Location
- Shared UI: `test/common/<widget_name>_test.dart`
- Feature UI: `test/features/<feature>/<feature>_page_content_test.dart`
- Provider-heavy feature states may also need focused provider tests; keep them near the feature
  test folder unless the repo already has a stronger local pattern.

## Harness Pattern
Call `Configuration.setup(flavor: Flavor.develop)` at the top of `main()` before any test runs —
existing tests in `test/common/` do this and widgets that read configuration fail without it.

Build the smallest wrapper that gives the widget the dependencies it expects:

```dart
Widget buildSubject({
  List<Override> overrides = const [],
}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.getThemeData(brightness: Brightness.light),
      home: const Scaffold(
        body: SubjectWidget(),
      ),
    ),
  );
}
```

Adapt imports to the current code. If the existing nearby tests use `patrolWidgetTest`,
`pumpWidgetAndSettle`, or another helper, reuse that style instead of creating a parallel harness.

## Riverpod Guidance
- Wrap provider-dependent widgets in `ProviderScope`.
- Override IO, auth, storage, and notifier providers rather than hitting real services.
- Keep overrides explicit in each test group so state does not leak between tests.
- For one-off event flows, assert the visible side effect when possible. If navigation/snackbars
  are difficult to observe directly, test the notifier event separately and keep the page listener
  thin.

## Route And Localization Guidance
- If the widget uses `context.router`, prefer an AutoRoute-aware harness or test the lower-level
  content widget instead of the route page.
- If the widget reads `context.locale`, include generated localization delegates.
- Add localization keys in `assets/localization/app_en.arb` and run `make gen` before relying on
  generated getters.

## Workflow
1. Read the widget and the closest existing tests.
2. Pick the smallest test subject that still covers the behavior.
3. Add or update test files under `test/`.
4. Use `tester.pumpWidget(...)`, `tester.pump()`, and `tester.pumpAndSettle()` intentionally;
   avoid arbitrary waits.
5. Assert user-observable behavior with `find`, callback counters, and provider state.
6. Run the narrow test file first:
   ```bash
   fvm flutter test test/path/to/file_test.dart
   ```
7. Run the full test suite when the change touches shared UI or state:
   ```bash
   fvm flutter test
   ```

## Completion Criteria
- Tests are deterministic and isolated.
- No real network, Firebase, storage, or platform side effects run during widget tests.
- Test names describe behavior, not implementation details.
- `fvm flutter test` or the relevant narrowed test command passes.
