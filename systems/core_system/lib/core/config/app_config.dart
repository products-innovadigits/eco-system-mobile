import 'package:core_system/core/core/enums.dart';
import 'package:core_system/core/env/env.dart';

class AppConfig {
  static const String _projectManagementBaseUrlFallback =
      'https://194.163.168.5:447/api/';

  static final String strategyBaseUrl = Env.strategyBaseUrlDev;
  static final String atsBaseUrl = Env.atsBaseUrlDev;
  static final String pmsBaseUrl = Env.pmsBaseUrlDev;
  static final String projectManagementBaseUrl =
      Env.projectManagementBaseUrlDev.isNotEmpty
          ? Env.projectManagementBaseUrlDev
          : _projectManagementBaseUrlFallback;

  /// The system the user selected at login. Defaults to strategy.
  static ActiveSystemEnum activeSystem = ActiveSystemEnum.strategy;

  /// Resolves the base URL for a given system.
  /// Falls back to [activeSystem] when no explicit system is provided.
  static String getBaseUrl([ActiveSystemEnum? system]) {
    final target = system ?? activeSystem;
    switch (target.value) {
      case 'strategy':
        return strategyBaseUrl;
      case 'ats':
        return atsBaseUrl;
      case 'pms':
        return pmsBaseUrl;
      case 'project_management':
        return projectManagementBaseUrl;
      default:
        return strategyBaseUrl;
    }
  }

  // Currently unused — uncomment when needed
  // static final String domain = Env.domainDev;
  // static final String authBaseUrl = Env.authBaseUrlDev;
  // static final String apiKey = Env.apiKey;
  // static final String googleMapsBaseUrl = Env.googleMapsBaseUrl;
}
