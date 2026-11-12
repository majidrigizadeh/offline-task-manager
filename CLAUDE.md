# CLAUDE.md — AI assistant instructions for this repository

Offline task manager (Flutter; targets Android, iOS and macOS). Feature-first
Clean Architecture, Cubit state management, Drift/SQLite persistence. Code must
work on all three targets: no desktop-only or mobile-only APIs, and UI must fit
phone screens as well as desktop windows. This file is the contract
AI assistants must follow when changing code here. Keep it current: when a
rule changes, update this file in the same change.

## Git — hard rules
- **Never modify the git staging area automatically.** No `git add`, `git rm`,
  `git commit`, `git stash` without explicit approval for that specific action.
- **Never** run `git reset`, `git checkout`, `git restore`, `git clean`,
  `git rebase`, force pushes, or squash commits.
- Read-only git (`status`, `log`, `diff`, `show`) is always fine.
- Commit message format: Conventional Commit subject, blank line, then body
  where each bullet/paragraph is a **single line** (no hard wrapping).
  **No `Co-Authored-By` or other trailers.**

## AI log — mandatory
Whenever an AI suggestion is **rejected, corrected, or found wrong** (by a
human, a compiler error, analyzer, or a failing test), append an entry to
`notes/ai_log.md` *immediately*, using its template. Never write entries
after the fact from memory, and never invent entries. Timestamps must come
from running `date`, never be estimated. `AI_WORKFLOW.md` is derived only
from that log.

## Architecture
```
lib/app/        composition root: App widget, router, DI (get_it + injectable)
lib/core/       cross-feature infra: database, config, error, utils
lib/features/<feature>/{domain,data,presentation}
```
- Dependencies point inward: presentation → domain ← data.
- **Domain** is pure Dart. Allowed import: `freezed_annotation` (annotation
  only). No Flutter, Drift, injectable, get_it, or uuid imports in domain.
- **Data** implements domain repository contracts. All SQL/Drift code lives in
  `data/datasources`. Repository implementations translate data-layer
  exceptions into domain `TaskFailure`s and map models → entities.
- **Presentation** talks to use cases only. Never import data/ or core/database
  from presentation.
- Cubits contain no queries and no persistence details.
- No business logic in widgets.

## Naming
- Files `snake_case.dart`; one public type per file (small enums/helpers may share).
- Entities: `XxxEntity`. Data models: `XxxModel`. Drift row classes: `XxxRow`.
- Use cases: verb phrase class with `call()` (e.g. `CompleteTask`).
- Cubits: `XxxCubit` + `XxxState` in `presentation/cubit` and `presentation/states`.
- Mappers: extension `XxxMapper` in `data/mappers/xxx_mapper.dart`.

## Dependency injection
- get_it + injectable codegen. Entry: `lib/app/di/injection.dart`.
- Shared infra (database, config, data source, repository) → `@lazySingleton`.
- Use cases are registered in `lib/app/di/tasks_module.dart` (an `@module`) so
  the domain layer stays free of injectable annotations.
- Cubits → `@injectable` (factory). Cubits needing runtime args use `@factoryParam`.
- `getIt` is only accessed in `main.dart` and `lib/app/router/`. Everything
  else uses constructor injection.

## State management
- flutter_bloc Cubits only (no GetX, no setState for business state).
- States are Freezed classes. Prefer `BlocSelector`/`buildWhen` to limit rebuilds.
- **No optimistic updates.** After a mutation (success or failure) the list is
  reloaded from the database using the *current* query/filters.
- Cubits cancel timers/subscriptions in `close()`. Widgets dispose their
  `TextEditingController`s.

## Models, mapping, serialization
- Domain entities and data models are separate Freezed classes.
- JSON via json_serializable only (no hand-written `toJson`/`fromJson`).
- Mapping lives **only** in extension methods in `data/mappers/`.
  Never map inside cubits, widgets, or repository bodies beyond calling
  `.toEntity()` / `.toModel()`.
- Parsing enums from stored/external strings must be safe (no `byName` throw
  leaking out); see `enum_parsing` helpers in the mappers.

## Error handling
- Repositories **throw** a sealed `TaskFailure` (`writeFailed`, `notFound`,
  `unexpected`) instead of returning Either/Result. Cubits catch `TaskFailure`.
- Mutations return `Future<bool>`: `true` = state changed, `false` = no-op.

## Database rules (CRITICAL)
- Every task mutation and its activity event happen in **one**
  `db.transaction`.
- The failure-simulation guard (`WriteFailureConfig.throwIfEnabled()`) is called
  **inside the transaction, right after the first write**, always — even for
  single-write operations — so rollback is exercised.
- No-op mutations write **nothing** (no row update, no activity).
- complete/reopen use a single conditional
  `UPDATE ... WHERE completed = <opposite>` as the check-and-set (never a
  separate read-then-write); 0 rows affected → check existence → no-op
  (`false`) or `TaskFailure.notFound`. Note: Drift's native transactions
  begin with `BEGIN IMMEDIATE`; keep `PRAGMA busy_timeout` in `beforeOpen`.
- Text normalization (`core/utils/text_normalizer.dart`) is applied both in the
  form cubit and in the data source before diffing.
- Activities are deleted with their task via `ON DELETE CASCADE`
  (foreign keys enabled in `beforeOpen`).
- Schema changes: bump `schemaVersion`, add a step in
  `core/database/migrations/migrations.dart`, dump the schema
  (`dart run drift_dev schema dump lib/core/database/app_database.dart drift_schemas/`).
  Never edit an existing migration step.

## Commands
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # after changing any @freezed/@injectable/Drift/JSON class
dart format .
flutter analyze
flutter test
flutter devices                                            # list device ids
flutter run -d <device>                                    # macos, an iOS simulator, or an Android emulator/device
flutter run -d <device> --dart-define=FAIL_WRITES=true     # simulate write failures
```

## Testing
- Database behavior is tested against real SQLite (`NativeDatabase.memory()`
  or a temp file), not mocks.
- Cubit tests use `bloc_test` with hand-written fakes (`test/helpers/`); use cases are real.
- Each test creates its own database; tests must be independent.
- Never claim a test passes without running it.
