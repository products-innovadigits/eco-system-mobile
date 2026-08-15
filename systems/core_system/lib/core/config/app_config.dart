import 'package:core_system/core/core/enums.dart';
import 'package:core_system/core/env/env.dart';
import 'package:core_system/core/systems/active_system.dart';

/// Environment configuration. Which system is *selected* lives in
/// [ActiveSystem]; this class only knows where each system's API is.
class AppConfig {
  /// Used when a system has no origin configured in `.env`; an empty base URL
  /// would otherwise turn every request into a relative one.
  static const String fallbackBaseUrl = 'https://api-src.nawahtech.com/api/';

  static final String strategyBaseUrl = Env.strategyBaseUrlDev;
  static final String atsBaseUrl = Env.atsBaseUrlDev;
  static final String pmsBaseUrl = Env.pmsBaseUrlDev;
  static final String projectManagementBaseUrl =
      Env.projectManagementBaseUrlDev.isNotEmpty
          ? Env.projectManagementBaseUrlDev
          : fallbackBaseUrl;

  /// Resolves the base URL for a given system, defaulting to the system this
  /// session is signed in to.
  static String getBaseUrl([ActiveSystemEnum? system]) {
    final target = system ?? ActiveSystem.signedInTo;
    final resolved = switch (target.value) {
      'ats' => atsBaseUrl,
      'pms' => pmsBaseUrl,
      'project_management' => projectManagementBaseUrl,
      _ => strategyBaseUrl,
    };
    return resolved.isNotEmpty ? resolved : fallbackBaseUrl;
  }

  // Currently unused — uncomment when needed
  // static final String domain = Env.domainDev;
  // static final String authBaseUrl = Env.authBaseUrlDev;
  // static final String apiKey = Env.apiKey;
  // static final String googleMapsBaseUrl = Env.googleMapsBaseUrl;
}
