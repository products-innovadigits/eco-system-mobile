## SOP Index for this Repository

### Relevance Matrix

| Capability (auto-detected) | Evidence (file paths) | Status | Notes |
| --- | --- | --- | --- |
| Environment configuration (.env) | `pubspec.yaml` (assets includes .env), `lib/main.dart` (dotenv.load), `systems/core_system/lib/core/config/app_config.dart` | Detected | Uses `flutter_dotenv`; keys read in `AppConfig` |
| Architecture/modules | `pubspec.yaml` (path deps to `systems/*`), `lib/navigation/custom_navigation.dart`, `systems/*` | Detected | Multi-module: `core_system`, `ats_system`, `strategy_system`, `pms_system` |
| State management | `pubspec.yaml` (hydrated_bloc), `systems/core_system/lib/core/config/providers.dart`, `lib/main.dart` | Detected | Bloc + HydratedBloc storage initialized |
| Navigation (named routes) | `systems/core_system/lib/core/navigation/routes.dart`, `lib/navigation/custom_navigation.dart`, `lib/main.dart` | Detected | Custom `AppRouter.onGenerateRoute` with named routes |
| i18n/localization | `assets/langs/{en,ar}.json`, `systems/core_system/lib/core/helpers/translation/translations.dart`, `lib/main.dart` | Detected | Custom translations with delegate and supported locales en/ar |
| Networking (Dio) | `systems/core_system/lib/core/network/network_layer.dart`, `network_logger.dart`, `app_config.dart` | Detected | Dio with interceptors; base URLs from dotenv |
| Firebase (core, messaging, analytics, crashlytics) | `lib/main.dart`, `lib/firebase_options.dart`, `android/app/build.gradle`, `android/app/google-services.json` (present), `firebase.json` | Detected | Initialize in release, FCM + analytics + crashlytics gradle plugins |
| Android build & signing | `android/app/build.gradle`, `android/app/src/main/AndroidManifest.xml`, `android/key.properties` | Detected | Plugins, compileSdk 35, signing via `key.properties` |
| iOS setup | `ios/Podfile` | Detected | Platform 14.0, permissions defines for `permission_handler` |
| Release tooling / Distribution | `android/fastlane/Fastfile` | Detected | Lane `distribute_ci` uploads to Firebase App Distribution |
| Observability/Crash reporting | `android/app/build.gradle` (Crashlytics), App Center deps | Detected | Firebase Crashlytics; AppCenter analytics/crashes libs |
| CI/CD | Not found in repo root (no `.github/workflows/`, `codemagic.yaml`) | Not Detected | TODO: Confirm CI provider and pipelines |
| Testing | No test files detected | Not Detected | TODO: Add unit/widget tests |
| Theming | `systems/core_system/core/bloc/theme_cubit.dart` referenced | Detected | Theme controlled via `ThemeCubit` |
| Secrets handling | `.env` in assets, `key.properties` (local) | Detected | Use placeholders; do not commit secrets |

### Generated SOPs

| SOP File | Title | One-line Purpose | Coverage | Owner | Last Updated |
| --- | --- | --- | --- | --- | --- |
| `SOP-environment.md` | Environment & Dotenv | Load and manage runtime env config | Full (Evidence) | <TBD> | 2025-10-20 |
| `SOP-architecture.md` | Architecture & Modules | Organize modules, routes, and cross-system wiring | Full (Evidence) | <TBD> | 2025-10-20 |
| `SOP-state-management.md` | Bloc & HydratedBloc | Initialize and use state management | Full (Evidence) | <TBD> | 2025-10-20 |
| `SOP-navigation.md` | Navigation | Use named routes and router | Full (Evidence) | <TBD> | 2025-10-20 |
| `SOP-i18n.md` | Localization | Manage languages via JSON and delegate | Full (Evidence) | <TBD> | 2025-10-20 |
| `SOP-networking.md` | Networking | Perform HTTP via Dio and config | Full (Evidence) | <TBD> | 2025-10-20 |
| `SOP-firebase.md` | Firebase Setup | Initialize Firebase, FCM, analytics, crashlytics | Full (Evidence) | <TBD> | 2025-10-20 |
| `SOP-android-build.md` | Android Build | Configure Gradle, signing, manifest | Full (Evidence) | <TBD> | 2025-10-20 |
| `SOP-ios-setup.md` | iOS Setup | Configure Podfile and permissions | Full (Evidence) | <TBD> | 2025-10-20 |
| `SOP-release.md` | Release & Distribution | Distribute via Fastlane to Firebase | Full (Evidence) | <TBD> | 2025-10-20 |
| `SOP-observability.md` | Observability | Crash reporting and analytics | Full (Evidence) | <TBD> | 2025-10-20 |

### TODO Stubs (Capabilities not detected)

- CI/CD: TODO — Provide CI provider and workflows; add config under `.github/` or equivalent.
- Testing: TODO — Add unit/widget/integration tests and instructions.

### Output Summary

- Files created/updated:
  - `docs/sops/README.md`
  - SOP files to be added under `docs/sops/` (see table above)
- Skipped capabilities: CI/CD and Testing — no evidence in repo
- Key TODOs: Confirm CI provider; add tests; designate SOP owners
- Key evidence links:
  - `pubspec.yaml`
  - `lib/main.dart`
  - `lib/firebase_options.dart`
  - `systems/core_system/lib/core/config/providers.dart`
  - `systems/core_system/lib/core/navigation/routes.dart`
  - `lib/navigation/custom_navigation.dart`
  - `systems/core_system/lib/core/helpers/translation/translations.dart`
  - `systems/core_system/lib/core/network/network_layer.dart`
  - `systems/core_system/lib/core/config/app_config.dart`
  - `android/app/build.gradle`
  - `android/app/src/main/AndroidManifest.xml`
  - `ios/Podfile`
  - `android/fastlane/Fastfile`
  - `firebase.json`



