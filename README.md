localization:
1 - go to inside core_system : cd systems/core_system.
2 - run command : flutter pub run easy_localization:generate -S ../../assets/langs -O lib/core/core/app_strings -f keys -o locale_keys.dart

generating image:
1 - flutter pub run build_runner build --delete-conflicting-outputs


debug overlay:
1 - a floating bug button appears over every screen in debug builds; tap it to see the captured requests (method, status, duration, headers, body) and copy any of them.
2 - it is gated by AppConfig.enableDebugOverlay in systems/core_system/lib/core/config/app_config.dart — on in debug, off otherwise.
3 - to force it on in a profile/release build : flutter run --release --dart-define=ENABLE_DEBUG_OVERLAY=true
4 - to force it off in a debug build : flutter run --dart-define=ENABLE_DEBUG_OVERLAY=false
