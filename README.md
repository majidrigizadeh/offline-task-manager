# Offline Task Manager (Flutter technical assignment)

An offline-first task manager. Every task change and its history event are
written to SQLite in one transaction. Write failures roll back completely,
and rapid or concurrent taps cannot produce duplicate history events.

- Architecture & decisions: [DESIGN.md](DESIGN.md)
- AI usage and the mistakes caught: [AI_WORKFLOW.md](AI_WORKFLOW.md)
- Rules the AI assistant followed: [CLAUDE.md](CLAUDE.md), with the raw running log in [notes/ai_log.md](notes/ai_log.md)

## Time box

| | |
|---|---|
| Start | 2026-11-12 00:18 PST (recorded with `date` before any work) |
| End | 2026-11-12 00:45 PST (recorded with `date` after the final format/analyze/test run; the docs commit follows immediately) |

Both values come from the system clock. Commit timestamps in `git log`
fall within this window, so the elapsed time is ~27 minutes of
wall-clock time on this machine.

## Features

| Feature | Status | How it was verified |
|---|---|---|
| Create / edit task (shared form, title required, priority, optional description) | Done | Form cubit tests, end-to-end widget test |
| Unchanged save writes nothing (including `null` vs blank description) | Done | Repository + form cubit + widget tests |
| Complete / reopen with history | Done | Repository + widget tests |
| Delete with confirmation; history deleted with the task (cascade) | Done | Repository test |
| Search by title (debounced, latest query wins, `%`/`_` matched literally) | Done | Repository + cubit tests |
| Filter by priority and by completion, combinable with search | Done | Repository + cubit tests |
| Search and filters preserved after mutations | Done | Cubit test |
| Paged task list (20 per page, loads the next page on scroll, retry on failure; loaded pages kept across mutations) | Done | Repository (real SQLite) + cubit + widget tests |
| Activity timeline bottom sheet (chronological, readable timestamps, old → new priority) | Done | Widget test (created / completed / reopened rows) |
| Loading, empty, error states | Done | Code review only (no dedicated test) |
| Atomic task + activity writes | Done | Repository tests |
| `FAIL_WRITES` simulation with full rollback, error message, retry | Done | Repository, cubit and widget tests |
| No duplicate complete/reopen events under rapid or concurrent calls | Done | Repository tests (including a second SQLite connection) |
| Data survives restart | Done | Repository test (close + reopen the database file) |
| Schema versioning + migration strategy | Done (v1, no upgrades yet) | Schema dumped to `drift_schemas/`; no migration test because v1 is the only version |

## Requirements

- Flutter **3.47.9** (stable) / Dart **3.13.7**. Developed and tested with these versions; `pubspec.yaml` requires Dart `^3.13.7`.
- **Supported targets: Android, iOS and macOS.** iOS and macOS builds need a full Xcode install; Android needs the Android SDK.
- No platform-specific code is required: `path_provider` resolves the database location on each platform, and `sqlite3` 3.x bundles native SQLite for all three through build hooks.
- Windows, Linux and web aren't supported targets. Web in particular would need Drift's wasm/web-worker setup, which is out of scope.

## Setup & run

```bash
flutter pub get
# Generated code is committed; regenerate after changing any annotated class:
dart run build_runner build --delete-conflicting-outputs

flutter devices          # find the device id
flutter run -d macos     # or an iOS simulator / Android emulator id
```

### Simulate write failures

```bash
flutter run -d <device> --dart-define=FAIL_WRITES=true
```

Every write then fails *inside* its transaction, right after the first
statement, and is rolled back. The list reloads from the database, so it keeps
showing the stored data, and a SnackBar shows the error with a **Retry**
action. The form keeps the user's input and offers **Retry save**.

To see a retry succeed, turn off the **Fail writes** switch in the app bar and
press Retry. The switch only appears in debug builds or when `FAIL_WRITES=true`
was passed. `FAIL_WRITES` is read in exactly one place:
`lib/core/config/write_failure_config.dart`.

## Tests

```bash
flutter test            # 51 tests
dart format .
flutter analyze
```

- `test/features/tasks/data/task_repository_impl_test.dart` (31 tests). Runs against **real SQLite** (in-memory, plus temp files for the restart and two-connection cases) and covers atomicity, rollback for every mutation, no-op saves, duplicate prevention (including the required `Future.wait` test), priority history, not-found handling, combined filters, cascade delete, restart, and paging through `GetTasks` (pages concatenate without gaps or overlap, including `created_at` ties; filters apply before paging; exact-full last page; out-of-range offset).
- `test/features/tasks/presentation/task_list_cubit_test.dart` (15 tests). Latest query wins, debouncing, filters kept across mutations, pending-tap guard, failure + retry, timer disposal, and paging: first page, load more until the end, mutations reload all loaded rows, filter change resets to page one, a stale next page is dropped, no load-more while a search debounces, failed next page + retry, shifted rows trigger a full reload.
- `test/features/tasks/presentation/task_form_cubit_test.dart` (3 tests). Validation, unchanged edit not written, failure keeps input + retry.
- `test/app_flow_test.dart` (2 tests). Drives the real app (DI, router, cubits, repository) on in-memory SQLite: create → complete → history → simulated failure → retry → unchanged edit; and, on a phone-sized screen, scrolling through 45 tasks (3 pages) and completing the last one without the list dropping back to page one.

Several tests were also checked by **mutation**: the guarded code was
temporarily broken to confirm the test fails, then restored. Details are in
[AI_WORKFLOW.md](AI_WORKFLOW.md).

Last run: `flutter analyze` → *No issues found*; `flutter test` → *51 passed*.

## Packages

| Package | Version | Why |
|---|---|---|
| flutter_bloc / bloc | 9.1.1 / 9.2.1 | Cubit state management (required by the brief) |
| freezed + freezed_annotation | 4.0.1 / 3.1.0 | Immutable entities, models and states with value equality |
| json_serializable + json_annotation | 6.15.2 / 4.12.0 | Generated JSON for data models (DTOs shaped for future sync) |
| get_it + injectable (+ injectable_generator) | 9.3.0 / 3.0.0 / 3.1.3 | DI container with generated registrations |
| drift + drift_dev | 2.35.4 / 2.35.3 | Type-safe SQLite, real transactions, schema versioning |
| sqlite3 (transitive) | 3.5.2 | Bundles native SQLite through Dart build hooks, so **`sqlite3_flutter_libs` isn't needed** |
| path_provider + path | 2.1.6 / 1.9.1 | Location of the database file |
| uuid | 4.6.0 | Client-generated IDs (sync-friendly) |
| intl | 0.20.3 | Timestamp formatting in the timeline |
| build_runner | 2.16.1 | Code generation |
| bloc_test | 10.0.0 | Cubit testing |

Packages that were considered but not added:

- **equatable**: Freezed already provides value equality.
- **rxdart**: a plain `Timer` plus a request id covers debouncing.
- **go_router**: two routes don't justify it.
- **mocktail**: added at first, then removed because it was unused. Fakes made controlling query timing simpler.

## Known limitations

- **The app wasn't launched during this session.** The machine has only the Xcode Command Line Tools, and `flutter build macos` fails with "Xcode not installed". UI behaviour is verified by the end-to-end widget test, not by hand. Still to check manually on a machine with Xcode: the window launches, layout looks right, the database persists in the real app-support directory, and the `FAIL_WRITES` launch flag works.
- Only priority changes create a history event. Title and description edits are saved but not recorded, because the brief defines just four event types.
- Deleting a task hard-deletes its history (see DESIGN.md §7; sync implications in §8).
- The search is case-insensitive for ASCII only (SQLite `LIKE` default).
- Paging uses LIMIT/OFFSET, not a keyset cursor. That's fine for a single-user local database: every in-app change reloads the loaded window from offset 0, and a next page that overlaps rows already shown triggers a full reload. After a mutation the cubit re-reads every loaded row, so a very long scroll makes each reload proportionally larger.
- The timeline is fetched once when the sheet opens and doesn't live-update.

## Unfinished / cut

Nothing from the planned scope was cut. The plan's cut list (timeline polish,
the 20-call interleaving test, form cubit tests, the debug switch) wasn't
needed because the 1h45 checkpoint was never reached. The only unverified item
is the real app launch described above.
