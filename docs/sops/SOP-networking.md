# [SOP-networking] - Networking (Dio)
**Version:** 1.0 | **Owner:** <TBD> | **Last Updated:** 2025-10-20 | **Coverage:** Full (Evidence)

**Purpose**
Standardize HTTP requests via Dio, base URLs from env, and consistent headers.

**Scope**
Network layer in `systems/core_system/lib/core/network/` and config from `AppConfig`.

**Definitions**
- Dio: HTTP client used for requests and interceptors.

## Tools & Dependencies (Evidence)
- `systems/core_system/lib/core/network/network_layer.dart`
- `systems/core_system/lib/core/network/network_logger.dart`
- `systems/core_system/lib/core/config/app_config.dart`

## Step-by-Step Procedure
1) Use `Network().request(...)` to perform HTTP calls.
2) Provide `endpoint`, optional `body`, `query`, `header`, and `method` from `ServerMethods`.
3) Set `systemTypeEnum` to select between base URLs (strategy vs ats) sourced from `AppConfig`.
4) Authentication: Token is read from `SecureStorageHelper().getToken()` and added as `Authorization: Bearer <TOKEN>` for strategy system.
5) Logging: Requests and responses are logged via `NetworkLogger` interceptor.
6) SSL: The HTTP client adapter ignores bad certificates (as configured in code). Do not rely on this in production; align with backend certificates.

## Checklist
- [ ] Base URLs resolved from `AppConfig`
- [ ] Token available in secure storage when required
- [ ] Errors handled via `ApiErrorHandler.getMessage`

## Definition of Done (DoD)
- Network requests succeed with correct headers and base URL; logs appear as expected.

## Rollback
- Revert recent changes to `network_layer.dart` or headers if regressions occur.

## Evidence Sources (Repo Links)
- `systems/core_system/lib/core/network/network_layer.dart`
- `systems/core_system/lib/core/network/network_logger.dart`
- `systems/core_system/lib/core/config/app_config.dart`

## Changelog
- 1.0 — 2025-10-20 — Initial document


