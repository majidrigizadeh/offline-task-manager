# AI log (running)

Appended *as work happens* whenever an AI (Claude Code) suggestion was
rejected, corrected, or found wrong, or when a significant AI-driven decision
was changed after verification. Source of truth for `AI_WORKFLOW.md`.

Template:
```
## <HH:MM> — <short title>
- Suggested: what the AI proposed/wrote
- Problem: what was wrong / incomplete
- Detected by: human review | analyzer | compiler | test | docs check
- Fix: what was done instead
```

---

## 00:20 — Plan review by human (before any code)
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
- Fix: CLAUDE.md + this log in phase 0; repository tests right after the
  data source; added a two-connection test on a shared temp file; existence
  check on 0 rows; shared text normalizer; "guard after first write, always";
  1h45 checkpoint with an explicit cut list.

## 00:21 — `sqlite3_flutter_libs` in the package list
- Suggested: brief + initial plan listed `sqlite3_flutter_libs`.
- Problem: resolver picked `sqlite3 3.5.2`, whose README states it bundles
  SQLite via Dart build hooks with no extra dependency.
- Detected by: docs check (read package README in pub cache).
- Fix: package not added.

## 00:24 — Invented drift_dev build option
- Suggested: Claude wrote `data_class_name_suffix: Row` in `build.yaml` to
  rename Drift row classes.
- Problem: no such option exists in drift_dev 2.35.3 — it would have been
  silently ignored (row classes would clash in naming with intent).
- Detected by: grepping the option names in drift_dev's `options.dart`
  before running codegen.
- Fix: removed it; use `@DataClassName('TaskRow')` on each table instead.
