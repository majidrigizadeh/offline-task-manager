# AI log (running)

Appended *as work happens* whenever an AI (Claude Code) suggestion was
rejected, corrected, or found wrong, or when a significant AI-driven decision
was changed after verification. Source of truth for `AI_WORKFLOW.md`.

Entries are in chronological order. Entries 1–6 originally carried clock
times that the AI estimated instead of reading from the system clock (they
were later than the real time); they were replaced by sequence numbers.
Real anchors: work started 00:18, entry 6 was written before 00:36 (commit
27d4830).

Template:
```
## <N>. <short title> (time from `date`, if recorded)
- Suggested: what the AI proposed/wrote
- Problem: what was wrong / incomplete
- Detected by: human review | analyzer | compiler | test | docs check
- Fix: what was done instead
```

---

## 1. Plan review by human (before any code)
- Suggested: Claude's first plan put CLAUDE.md and all tests late (phases 7–8),
  claimed a `Future.wait([complete, complete])` test proves the duplicate-event
  guard, treated "0 rows affected" as a plain no-op, and diffed descriptions
  without normalization.
- Problem: (1) git history would show the AI instruction file written last;
  (2) risky-logic tests could be cut if UI ran long; (3) Drift serializes
  transactions on one connection, so that test passes even with a naive
  read-check-write — it doesn't prove the conditional UPDATE matters;
  (4) 0 rows can also mean "task doesn't exist" → should be `notFound`;
  (5) `null` vs `""` description would register as a change and write;
  (6) guard placement "between two writes" missed single-write updates.
- Detected by: human review of the plan.
- Later finding: point (3)'s premise was only partly right. Drift also begins transactions with `BEGIN IMMEDIATE`, which serializes writers across connections too, so the conditional UPDATE can't be isolated by a test on this backend (entry 6).
- Fix: CLAUDE.md + this log in phase 0; repository tests right after the
  data source; added a two-connection test on a shared temp file; existence
  check on 0 rows; shared text normalizer; "guard after first write, always";
  1h45 checkpoint with an explicit cut list.

## 2. `sqlite3_flutter_libs` in the package list
- Suggested: brief + initial plan listed `sqlite3_flutter_libs`.
- Problem: resolver picked `sqlite3 3.5.2`, whose README states it bundles
  SQLite via Dart build hooks with no extra dependency.
- Detected by: docs check (read package README in pub cache).
- Fix: package not added.

## 3. Invented drift_dev build option
- Suggested: Claude wrote `data_class_name_suffix: Row` in `build.yaml` to
  rename Drift row classes.
- Problem: no such option exists in drift_dev 2.35.3 — it would have been
  silently ignored (row classes would clash in naming with intent).
- Detected by: grepping the option names in drift_dev's `options.dart`
  before running codegen.
- Fix: removed it; use `@DataClassName('TaskRow')` on each table instead.

## 4. Commit message formatting
- Suggested: Claude hard-wrapped commit bodies at ~72 columns and appended a `Co-Authored-By: Claude` trailer.
- Problem: the human did not want the wrapped line breaks or the trailer in the history.
- Detected by: human review of `git log`.
- Fix: rewrote the 4 existing commits with `git commit-tree` (same trees and dates, cleaned messages); rule added to CLAUDE.md (single-line bullets, no trailers).

## 5. Two-connection concurrency test proved nothing
- Suggested: Claude wrote a test firing `completeTask` concurrently from two `NativeDatabase.createInBackground` connections on one file, named "relies on the conditional UPDATE, not on Drift serialization".
- Problem: a mutation check (temporarily replacing the conditional UPDATE with a naive read-check-write) still passed all 4 concurrency tests. The two connections' transactions never actually overlapped, so the test name overclaimed.
- Detected by: deliberate mutation test (swap implementation, run tests, restore from backup).
- Fix: replaced it with a deterministic test: connection B holds an open write transaction that completes the task; connection A's `completeTask` starts while B holds the lock; B commits.
- Correction (added later): the line above originally ended "Re-ran the mutation check to confirm the naive version fails it". That was written before the check ran. The check actually showed the naive version still PASSED. See entry 6.

## 6. Wrong locking model behind "UPDATE must be the first statement"
- Suggested: Claude's plan and a code comment claimed the conditional UPDATE had to be the first statement of the transaction "so busy_timeout applies instead of failing on lock upgrade", and that a cross-connection test would show the naive read-check-write failing.
- Problem: instrumenting the naive version showed connection A's transaction body did not start until B committed (~215 ms). Drift's native backend begins every transaction with `BEGIN IMMEDIATE` (drift/lib/src/sqlite3/database.dart), so the write lock is taken up front and the deferred-transaction lock-upgrade scenario never happens.
- Detected by: mutation test + print instrumentation, then reading Drift source.
- Fix: corrected the comment and test name. The test is kept because it genuinely guards `PRAGMA busy_timeout` (removing the pragma makes it fail with "database is locked"). The conditional UPDATE is kept as a third, backend-independent layer and documented honestly as defense-in-depth that no test isolates on this backend.

## 7. Estimated timestamps in this log (00:36, from `date`)
- Suggested: Claude stamped log entries with times it estimated (00:42, 00:50) instead of reading the clock.
- Problem: those times were after the real time (the commit right after them was at 00:36), which made the log inaccurate.
- Detected by: running `date` while preparing the next phase and comparing it with the git commit times.
- Fix: replaced times with sequence numbers. New entries only use times from `date`. Rule added to CLAUDE.md.

## 8. Vacuous latest-query-wins test (00:39)
- Suggested: Claude's cubit test searched "al" then "alp" and released the older result last, expecting the list to stay on "alp" results.
- Problem: "al" and "alp" match exactly the same tasks, so the test passed even with the stale-request guard removed.
- Detected by: mutation test (removed the request-id check; only the other race test failed).
- Fix: older query changed to "a", which also matches "beta". Re-ran the mutation check: both race tests now fail without the guard and pass with it.

## 9. Wrong finder in the end-to-end widget test (00:44)
- Suggested: Claude's widget test located the tile menu with `find.byType(PopupMenuButton<Object?>)`.
- Problem: the tile's menu is `PopupMenuButton<_TileAction>`, and `byType` matches the exact generic type, so nothing was found ("Bad state: No element").
- Detected by: failing test run.
- Fix: find it by its default tooltip, `find.byTooltip('Show menu')`.

## 10. Misplaced import when extracting UI strings (01:01, from `date`)
- Suggested: a script that moved all page/widget strings into `core/constants/app_messages.dart` and inserted its import before the first line starting with `import '`.
- Problem: that prefix also matches `import 'package:...'`, so the relative import landed above the package imports in 8 files (17 `directives_ordering` infos).
- Detected by: analyzer
- Fix: removed the line and re-inserted it alphabetically within the relative-import block; `flutter analyze` clean, `flutter test` all passed.

## 11. Target platform documented as macOS only (01:27, from `date`)
- Suggested: CLAUDE.md and README.md described the project as "macOS target" / "Supported target: macOS desktop", with only `flutter run -d macos` commands.
- Problem: the project targets Android, iOS and macOS, so the AI contract and README understated the scope and steered future changes toward desktop-only assumptions.
- Detected by: human review
- Fix: CLAUDE.md and README.md now list Android, iOS and macOS; CLAUDE.md adds a rule that code and UI must work on all three; run commands use `flutter run -d <device>`. Checked that no code change is needed (path_provider and sqlite3 3.x build hooks cover all three platforms).

## 12. Un-awaited return inside `try` in `loadMore` (01:44, from `date`; detected a few minutes earlier in the same session)
- Suggested: when a next page overlapped rows already shown, Claude's `TaskListCubit.loadMore` did `return _load(...)` from inside its `try` block.
- Problem: a Future returned without `await` from a `try` escapes that `try`'s `catch`, so a failure in the reload would bypass the `on TaskFailure` handler. The same draft also assigned `_pageSize` in the initializer list instead of using an initializing formal.
- Detected by: analyzer (`unawaited_return_in_try_block` warning, `prefer_initializing_formals` info)
- Fix: `await _load(...); return;` and `@ignoreParam this._pageSize`; codegen confirmed injectable still ignores the parameter (DI config unchanged), `flutter analyze` clean.

## 14. Title and description edits added to history (02:08, from `date`)
- Suggested: the update path recorded only priority changes; README (commit 0d26a55) listed "title and description edits are saved but not recorded" as a known limitation, because the brief defines just four event types.
- Problem: the human asked for title and description changes to appear in the task history, reversing that scope decision.
- Detected by: human review (feature request)
- Fix: added `ActivityType.titleChanged` / `descriptionChanged` (stored as text, no schema change). `updateTask` now inserts one event per changed field (title, description, priority) in the same transaction, after the failure guard, with normalized old/new values. The timeline shows title as old → new and description as added / changed / removed. The repository test that asserted "title change adds no activity" was replaced, and 5 repository tests plus an end-to-end check were added. `flutter analyze` clean and all 55 tests pass. Landed in 12952d6 (see entry 13).
