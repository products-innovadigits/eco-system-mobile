# [SOP-ios-setup] - iOS Setup
**Version:** 1.0 | **Owner:** <TBD> | **Last Updated:** 2025-10-20 | **Coverage:** Full (Evidence)

**Purpose**
Configure iOS platform settings, CocoaPods, and permissions per repository configuration.

**Scope**
`ios/Podfile` and build settings for permissions/macros.

**Definitions**
- CocoaPods: Dependency manager for iOS.

## Tools & Dependencies (Evidence)
- `ios/Podfile` sets platform `14.0`, uses frameworks/modular headers, and configures permission macros.

## Step-by-Step Procedure
1) Ensure iOS platform target is `14.0` in `Podfile`.
2) Keep `use_frameworks!` and `use_modular_headers!` as configured.
3) Permission macros: Confirm `GCC_PREPROCESSOR_DEFINITIONS` includes
   - `PERMISSION_CAMERA=1`
   - `PERMISSION_PHOTOS=1`
   - `PERMISSION_NOTIFICATIONS=1`
   - `PERMISSION_MEDIA_LIBRARY=1`
4) Install pods:
   - From repo root: `flutter pub get`
   - Then: `cd ios && pod install`

## Checklist
- [ ] Pod install completes successfully
- [ ] Build settings include required permission macros

## Definition of Done (DoD)
- iOS app builds and runs on simulator/device without missing permission macro errors.

## Rollback
- Re-run `pod install` after reverting Podfile changes; clean build folder in Xcode.

## Evidence Sources (Repo Links)
- `ios/Podfile`

## Changelog
- 1.0 — 2025-10-20 — Initial document


