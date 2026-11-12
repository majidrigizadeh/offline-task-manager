# AI workflow

Everything below comes from [notes/ai_log.md](notes/ai_log.md), which was
written *during* the work: an entry was added whenever an AI suggestion was
rejected, corrected or found wrong. That log also records where the AI log
itself had to be corrected.

## Tools

- **Claude Code** (model Claude Opus 5.5), running in the VS Code extension. It did the planning, wrote the code, tests and docs, and ran the commands (codegen, analyze, tests, git).
- **The human** wrote the brief, reviewed and amended the plan, chose the git and retry approaches, set the commit-message format, and approved each git step until granting standing approval for milestone commits.
- **[CLAUDE.md](CLAUDE.md)** is the AI's instruction file. It was written **before any feature code** (second commit) and updated as rules changed: the commit format, the locking note, and the rule that timestamps come from `date`.

## How the work was split

1. **Plan mode.** Claude inspected the repo and toolchain and asked two blocking questions (git workflow; how Retry can succeed under `FAIL_WRITES`). It proposed a plan, which the human sent back with 8 concrete corrections (log entry 1) before approving.
2. **Small milestones.** Each one was followed by codegen, `flutter analyze` and a commit: template → CLAUDE.md → deps/skeleton → database → domain/models/mappers → data source + repository → **repository tests** → cubits/DI → **cubit tests** → UI + end-to-end widget test → docs.
3. **Risky logic first.** Repository tests were written right after the data source, before any cubit or UI depended on it.

## Important prompts

- The assignment brief itself, pasted as the first message and used as the spec. It asked for an inspect-and-plan step before any code.
- The human's plan review, condensed: *"Write CLAUDE.md first… move the repository tests up to phase 4… keep a running AI log from minute one… the Future.wait test proves less than it looks: Drift serializes transactions on a single connection… '0 rows affected' is ambiguous… normalize description before diffing… guard after the first write, always… add a time checkpoint and a cut list."*
- *"First commit the default Flutter files, then CLAUDE.md, then your changes"* led to rebuilding the pristine template in the scratchpad so that commit 1 really is untouched `flutter create` output.
- *"Remove the unnecessary line breaks and Co-Authored-By from all commits and use this pattern for all future commits"* led to rewriting history with the same trees and dates.

## Where the AI was wrong or incomplete

**1. Concurrency tests that proved less than claimed (log entries 5, 6).**
The plan said a test using two SQLite connections on one file would show
that the conditional `UPDATE … WHERE completed = 0` matters. Claude wrote
that test and named it accordingly. A deliberate **mutation test** (swap in a
naive read-check-write, run the tests, restore from backup) showed it still
passed. Claude replaced it with a deterministic version (connection B holds an
open write transaction), and the naive version *passed that too*.
Instrumentation showed connection A didn't even start until B committed, and
reading Drift's source explained why: native transactions begin with
`BEGIN IMMEDIATE`. The AI's locking model ("the UPDATE must be the first
statement so busy_timeout applies") was wrong. The comment and test name were
corrected. The test was kept because it really does guard `busy_timeout` (it
fails with "database is locked" without it). DESIGN.md now says plainly that
no test isolates the conditional UPDATE on this backend. The AI log also
contained a sentence claiming the mutation check had failed the naive version
*before the check was run*. It was annotated as wrong, not silently edited.

**2. A latest-query-wins test that couldn't fail (entry 8).**
The search race test used the queries "al" and "alp", which match exactly the
same tasks, so a stale overwrite was invisible. The mutation check (remove the
request-id guard) caught it. The older query is now "a", which also matches
"beta", and both race tests fail without the guard.

**3. Invented configuration and wrong assumptions (entries 2, 3, 7, 9).**
- `build.yaml` used a drift_dev option, `data_class_name_suffix`, that doesn't exist. It was caught by grepping drift_dev's option list before codegen.
- `sqlite3_flutter_libs` was in the plan, but sqlite3 3.x bundles SQLite through build hooks. This was caught by reading the package README.
- AI log entries were stamped with *estimated* times that were later than the real clock. This was caught by comparing them with `date` and the commit times.
- A widget-test finder used the wrong generic type. This was caught by the failing test.

## What was reviewed and verified, and by whom

- **Human:** the plan (8 corrections, entry 1), the git history and commit messages (entry 4), the git identity, and the choice of how Retry can succeed.
- **Machine checks run by Claude:** `flutter analyze` (clean), `flutter test` (36 passing), mutation checks on the duplicate-event, busy_timeout and latest-query-wins tests, and reading drift/sqlite3 source and docs in the pub cache.
- **Not verified:** a real app launch. The machine has no Xcode (`flutter build macos` fails), so the UI was exercised only through the end-to-end widget test.
