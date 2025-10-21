# [SOP-navigation] - Navigation
**Version:** 1.0 | **Owner:** <TBD> | **Last Updated:** 2025-10-20 | **Coverage:** Full (Evidence)

**Purpose**
Provide consistent navigation via named routes using a centralized router.

**Scope**
Applies to `lib/main.dart`, `systems/core_system/lib/core/navigation/routes.dart`, and `lib/navigation/custom_navigation.dart`.

**Definitions**
- Named Route: A string constant mapped to a screen.
- Router: `AppRouter.onGenerateRoute` switch mapping.

## Tools & Dependencies (Evidence)
- `systems/core_system/lib/core/navigation/routes.dart`
- `lib/navigation/custom_navigation.dart`
- `lib/main.dart` (MaterialApp with `onGenerateRoute`)

## Step-by-Step Procedure
1) Define a route in `routes.dart` as a `static const`.
2) Add a `case` in `AppRouter.onGenerateRoute` to return a `MaterialPageRoute`.
3) Set `initialRoute` and `onGenerateRoute` in `MaterialApp` (already set in `main.dart`).
4) Navigate using: `Navigator.of(context).pushNamed(Routes.<ROUTE_NAME>, arguments: ...)`.

## Checklist
- [ ] Route constant exists in `routes.dart`
- [ ] Case added in `AppRouter.onGenerateRoute`
- [ ] `initialRoute` remains valid

## Definition of Done (DoD)
- New route navigates successfully and returns to previous screen via back navigation.

## Rollback
- Remove the route case and constant; rebuild to verify router compiles.

## Evidence Sources (Repo Links)
- `systems/core_system/lib/core/navigation/routes.dart`
- `lib/navigation/custom_navigation.dart`
- `lib/main.dart`

## Changelog
- 1.0 — 2025-10-20 — Initial document



