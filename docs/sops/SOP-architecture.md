# [SOP-architecture] - Architecture & Modules
**Version:** 1.0 | **Owner:** <TBD> | **Last Updated:** 2025-10-20 | **Coverage:** Full (Evidence)

**Purpose**
Define the module structure and cross-system wiring to keep a consistent architecture.

**Scope**
Applies to main app under `lib/` and the systems: `systems/core_system`, `systems/ats_system`, `systems/strategy_system`, `systems/pms_system`.

**Definitions**
- Module: A system packaged under `systems/*` consumed via `path` dependencies.
- Router: Centralized on-generate route table mapping.
- Providers: Bloc providers bootstrapped at app start.

## Tools & Dependencies (Evidence)
- `pubspec.yaml` (path dependencies to systems/*)
- `lib/navigation/custom_navigation.dart` (AppRouter)
- `systems/core_system/lib/core/navigation/routes.dart` (route names)
- `systems/core_system/lib/core/config/providers.dart` (Bloc providers)

## Step-by-Step Procedure
1) Add or update a module under `systems/<module_name>` and expose its public API.
2) Wire the module into the app via `pubspec.yaml` `dependencies` using `path: systems/<module_name>`.
3) Register new blocs/providers in `systems/core_system/lib/core/config/providers.dart` within `ProviderList.providers` as needed.
4) Add new routes:
   - Define a route constant in `systems/core_system/lib/core/navigation/routes.dart`.
   - Handle it in `lib/navigation/custom_navigation.dart` inside `AppRouter.onGenerateRoute`.
5) Use `MultiBlocProvider` in `lib/main.dart` to supply providers from `ProviderList.providers`.

## Checklist
- [ ] Module path dependency added in `pubspec.yaml`
- [ ] Providers listed in `ProviderList.providers`
- [ ] Route constant defined in `routes.dart`
- [ ] Route case handled in `AppRouter.onGenerateRoute`

## Definition of Done (DoD)
- App compiles and navigates to new module screens using named routes.
- Required blocs are available via the provider list.

## Rollback
- Remove the module `path` dependency from `pubspec.yaml` and revert route/provider changes if build or runtime fails.

## Evidence Sources (Repo Links)
- `pubspec.yaml`
- `lib/navigation/custom_navigation.dart`
- `systems/core_system/lib/core/navigation/routes.dart`
- `systems/core_system/lib/core/config/providers.dart`

## Changelog
- 1.0 — 2025-10-20 — Initial document


