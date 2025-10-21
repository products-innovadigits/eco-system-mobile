# [SOP-android-build] - Android Build & Configuration
**Version:** 1.0 | **Owner:** <TBD> | **Last Updated:** 2025-10-20 | **Coverage:** Full (Evidence)

**Purpose**
Document Android build setup, signing, and required manifest permissions/configs.

**Scope**
`android/app/build.gradle`, `android/app/src/main/AndroidManifest.xml`, `android/key.properties`.

**Definitions**
- Signing config: Release keystore configuration from `key.properties`.

## Tools & Dependencies (Evidence)
- `android/app/build.gradle` (plugins, compileSdk 35, signing, BoM, dependencies)
- `android/app/src/main/AndroidManifest.xml` (permissions, activities, metadata)
- `android/key.properties` (referenced, not committed)

## Step-by-Step Procedure
1) Configure signing:
   - Create `android/key.properties` with placeholders:
     - `storeFile=<KEYSTORE_PATH>`
     - `storePassword=<KEYSTORE_PASSWORD>`
     - `keyAlias=<KEY_ALIAS>`
     - `keyPassword=<KEY_PASSWORD>`
   - Ensure `signingConfigs.release` references `key.properties`.
2) Build settings:
   - Ensure `compileSdk=35`, `minSdk=23`, `targetSdk=35` as in Gradle file.
   - Keep `multiDexEnabled true` if needed.
3) Firebase & services:
   - Plugins: `com.google.gms.google-services`, `com.google.firebase.crashlytics`.
   - Dependencies include Firebase BoM, analytics, crashlytics, messaging.
4) Manifest requirements:
   - Required permissions for internet, location, storage, notifications as listed.
   - Metadata for FCM default channel/icon and Maps API key `com.google.android.geo.API_KEY` with `<GOOGLE_MAPS_API_KEY>` placeholder.
5) Build commands:
   - Debug: `flutter build apk --debug`
   - Release: `flutter build apk --release --no-shrink`

## Checklist
- [ ] `key.properties` exists and is referenced in `build.gradle`
- [ ] `google-services.json` in `android/app/`
- [ ] Manifest contains required permissions and metadata
- [ ] Release build assembles successfully

## Definition of Done (DoD)
- Signed release APK/AAB generated without Gradle or manifest errors.

## Rollback
- Revert recent Gradle or Manifest changes; ensure BoM versions and plugins align.

## Evidence Sources (Repo Links)
- `android/app/build.gradle`
- `android/app/src/main/AndroidManifest.xml`
- `android/key.properties`

## Changelog
- 1.0 — 2025-10-20 — Initial document


