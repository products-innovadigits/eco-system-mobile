# [SOP-environment] - Environment & Dotenv
**Version:** 1.0 | **Owner:** <TBD> | **Last Updated:** 2025-10-20 | **Coverage:** Full (Evidence)

**Purpose**
Ensure consistent runtime configuration via `.env` and access through `AppConfig` without exposing secrets.

**Scope**
Flutter app runtime configuration for modules under `lib/` and `systems/*` using `flutter_dotenv`.

**Prerequisites**
- Flutter SDK and Dart SDK compatible with `environment` in `pubspec.yaml`.
- Access to environment values (use placeholders such as `<STRATEGY_BASE_URL_DEV>`).

**Definitions**
- Dotenv: Loading key-value pairs from a `.env` file bundled as an asset.
- AppConfig: Wrapper reading environment keys via `flutter_dotenv`.

## Tools & Dependencies (Evidence)
- `pubspec.yaml` assets include `.env` and dependency `flutter_dotenv` is imported in code
- `lib/main.dart` loads `.env` at startup
- `systems/core_system/lib/core/config/app_config.dart` reads env keys via `dotenv`

## Step-by-Step Procedure
1) Place environment variables in `.env` at repo root. Example keys:
   - `DOMAIN_DEV=<DOMAIN_DEV>`
   - `STRATEGY_BASE_URL_DEV=<STRATEGY_BASE_URL_DEV>`
   - `ATS_BASE_URL_DEV=<ATS_BASE_URL_DEV>`
   - `AUTH_BASE_URL_DEV=<AUTH_BASE_URL_DEV>`
   - `API_KEY=<API_KEY>`
   - `GOOGLE_MAPS_BASE_URL=<GOOGLE_MAPS_BASE_URL>`
2) Ensure `.env` is included as an asset in `pubspec.yaml` under `flutter/assets`.
3) Verify application loads env early in `main()`:
   - `await dotenv.load(fileName: ".env");`
4) Access env values through `AppConfig` static fields:
   - `AppConfig.strategyBaseUrl`, `AppConfig.atsBaseUrl`, etc.
5) Do not hardcode secrets. For any platform-specific secrets, use placeholders in code and platform configs.

## Checklist
- [ ] `.env` exists with required keys (placeholders ok for dev)
- [ ] `pubspec.yaml` lists `.env` in assets
- [ ] `lib/main.dart` calls `dotenv.load`
- [ ] Network base URLs resolve from `AppConfig`

## Definition of Done (DoD)
- App boots with `.env` loaded; network requests use base URLs from `AppConfig`.
- No hardcoded secrets in repo; values are referenced via `dotenv`.

## Rollback
- Restore a previously working `.env` backup or revert changes via VCS to last known working commit that included valid `.env` and `pubspec.yaml` assets list.

## Evidence Sources (Repo Links)
- `pubspec.yaml`
- `lib/main.dart`
- `systems/core_system/lib/core/config/app_config.dart`

## Changelog
- 1.0 — 2025-10-20 — Initial document



