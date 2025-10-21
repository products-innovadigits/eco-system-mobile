# [SOP-release] - Release & Distribution
**Version:** 1.0 | **Owner:** <TBD> | **Last Updated:** 2025-10-20 | **Coverage:** Full (Evidence)

**Purpose**
Define the release process and Firebase App Distribution lane used by Android.

**Scope**
Android Fastlane lane `distribute_ci` and associated artifacts.

**Definitions**
- Firebase App Distribution: Service to distribute pre-release builds to testers.

## Tools & Dependencies (Evidence)
- `android/fastlane/Fastfile` lane `distribute_ci`
- `android/app/build.gradle` for building release APK

## Step-by-Step Procedure
1) Ensure environment variable `ACTIVE_SYSTEMS` is set if used by the app.
2) From repo root or CI, execute Fastlane lane in `android`:
   - `cd android && bundle exec fastlane distribute_ci`
3) Lane steps (per Fastfile):
   - Runs `flutter build apk --release --no-shrink --dart-define=ACTIVE_SYSTEMS=$ACTIVE_SYSTEMS`
   - Uploads generated `../build/app/outputs/flutter-apk/app-release.apk` to Firebase App Distribution
   - Uses `FIREBASE_TOKEN` env var; optionally `test_email` parameter to add testers
4) Provide placeholders where sensitive values are needed:
   - `FIREBASE_TOKEN=<FIREBASE_TOKEN>`
   - `app: "<FIREBASE_ANDROID_APP_ID>"`

## Checklist
- [ ] `FIREBASE_TOKEN` available in environment
- [ ] Release APK builds successfully
- [ ] Upload to Firebase App Distribution completes

## Definition of Done (DoD)
- Testers in group `nawah-team` (as configured) receive the distribution; optional testers added via parameter.

## Rollback
- Re-run the lane with a previous commit tag; if artifact issues occur, rebuild and re-upload.

## Evidence Sources (Repo Links)
- `android/fastlane/Fastfile`
- `android/app/build.gradle`

## Changelog
- 1.0 — 2025-10-20 — Initial document


