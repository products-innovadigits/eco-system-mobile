# [SOP-state-management] - Bloc & HydratedBloc
**Version:** 1.0 | **Owner:** <TBD> | **Last Updated:** 2025-10-20 | **Coverage:** Full (Evidence)

**Purpose**
Establish consistent state management using Bloc and HydratedBloc, including persistent storage.

**Scope**
Global app bootstrap in `lib/main.dart` and provider wiring in `systems/core_system/lib/core/config/providers.dart`.

**Definitions**
- Bloc: Business logic component pattern for state.
- HydratedBloc: Bloc with automatic state persistence.

## Tools & Dependencies (Evidence)
- `pubspec.yaml` dependency: `hydrated_bloc`
- `lib/main.dart` initializes `HydratedBloc.storage`
- `systems/core_system/lib/core/config/providers.dart` registers app blocs

## Step-by-Step Procedure
1) Storage init: In `main()`, ensure `HydratedBloc.storage = await HydratedStorage.build(...)` is executed before running the app.
2) Register blocs: Add new blocs to `ProviderList.providers` via `BlocProvider`.
3) Use blocs in UI: Wrap app in `MultiBlocProvider` and consume via `BlocBuilder`/`BlocListener` as evidenced in `lib/main.dart`.
4) Persist state: For hydrated blocs, extend `HydratedBloc` and implement `toJson`/`fromJson`.

## Checklist
- [ ] Hydrated storage initializes before `runApp`
- [ ] All required blocs are registered in `ProviderList.providers`
- [ ] UI reads state via `BlocBuilder`/`BlocListener`

## Definition of Done (DoD)
- App state persists across restarts where implemented; no missing providers at runtime.

## Rollback
- Revert recent bloc additions in `providers.dart` and corresponding UI changes if regressions occur.

## Evidence Sources (Repo Links)
- `pubspec.yaml`
- `lib/main.dart`
- `systems/core_system/lib/core/config/providers.dart`

## Changelog
- 1.0 — 2025-10-20 — Initial document


