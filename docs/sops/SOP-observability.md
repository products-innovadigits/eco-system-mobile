# [SOP-observability] - Crash Reporting & Analytics
**Version:** 1.0 | **Owner:** <TBD> | **Last Updated:** 2025-10-20 | **Coverage:** Full (Evidence)

**Purpose**
Outline crash reporting and analytics configuration present in the repository.

**Scope**
Android Firebase Crashlytics and Analytics; Microsoft App Center dependencies referenced.

**Definitions**
- Crashlytics: Firebase crash reporting SDK.
- App Center: Microsoft analytics/crashes SDK for Android.

## Tools & Dependencies (Evidence)
- `android/app/build.gradle` includes Crashlytics plugin, analytics, and App Center dependencies

## Step-by-Step Procedure
1) Ensure Android build applies `com.google.firebase.crashlytics` and includes Firebase BoM.
2) Build the app; Crashlytics automatically initializes with Firebase per `main.dart` initialization.
3) App Center dependencies are included; repository does not show explicit initialization code — integrate if required by product using official SDK docs.

## Checklist
- [ ] Crashlytics plugin applied and artifacts upload on build as configured
- [ ] Analytics library present per BoM
- [ ] Optional App Center SDK configured if used (init code not found in repo)

## Definition of Done (DoD)
- Crashes appear in Firebase Crashlytics dashboard after inducing a test crash in a non-debug build.

## Rollback
- Remove or pin dependency versions in `build.gradle` to previously stable ones.

## Evidence Sources (Repo Links)
- `android/app/build.gradle`

## Changelog
- 1.0 — 2025-10-20 — Initial document



