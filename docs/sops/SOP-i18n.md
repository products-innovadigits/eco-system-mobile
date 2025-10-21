# [SOP-i18n] - Localization
**Version:** 1.0 | **Owner:** <TBD> | **Last Updated:** 2025-10-20 | **Coverage:** Full (Evidence)

**Purpose**
Provide a consistent process for maintaining translations and supported locales.

**Scope**
Custom i18n using JSON assets under `assets/langs/` and a `LocalizationsDelegate`.

**Definitions**
- Translations: Runtime loader for JSON strings.

## Tools & Dependencies (Evidence)
- `assets/langs/en.json`, `assets/langs/ar.json`
- `systems/core_system/lib/core/helpers/translation/translations.dart`
- `lib/main.dart` sets delegates and supported locales

## Step-by-Step Procedure
1) Add or update keys in `assets/langs/en.json` and `assets/langs/ar.json`.
2) Ensure the keys are loaded by `Translations.load` using the `languageCode` file naming.
3) In `MaterialApp`, ensure `localizationsDelegates` includes `TranslationsDelegate()` and `supportedLocales` reflects available languages.
4) To switch language, emit on `mainAppBloc.langStream` (as used in `lib/main.dart`).

## Checklist
- [ ] JSON files updated for all supported locales
- [ ] Delegate and supportedLocales configured in `main.dart`
- [ ] Missing keys return fallback string pattern

## Definition of Done (DoD)
- UI reflects updated translations for all supported locales without runtime errors.

## Rollback
- Revert changes to JSON files and rebuild; confirm strings display as before.

## Evidence Sources (Repo Links)
- `assets/langs/en.json`
- `assets/langs/ar.json`
- `systems/core_system/lib/core/helpers/translation/translations.dart`
- `lib/main.dart`

## Changelog
- 1.0 — 2025-10-20 — Initial document


