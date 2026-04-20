import 'package:core_system/core/core/enums.dart';
import 'package:core_system/core/env/env.dart';

class AppConfig {
  static const String _projectManagementBaseUrlFallback =
      'https://194.163.168.5:447/api/';

  /// Matches [Env.atsBaseUrlDev] default; used if `.env` / secret sets an empty string.
  static const String _atsBaseUrlFallback =
      'https://ats.innoeg.com/api/v1/';

  /// When `PMS_BASE_URL_DEV` is unset or placeholder-only; override via `.env` / CI secret.
  static const String _pmsBaseUrlFallback =
      'https://pms-dev.nawahtech.com/api/v2/';

  static final String strategyBaseUrl = Env.strategyBaseUrlDev;
  static final String atsBaseUrl = Env.atsBaseUrlDev.isNotEmpty
      ? Env.atsBaseUrlDev
      : _atsBaseUrlFallback;
  static final String projectManagementBaseUrl =
      Env.projectManagementBaseUrlDev.isNotEmpty
          ? Env.projectManagementBaseUrlDev
          : _projectManagementBaseUrlFallback;

  /// PMS host from `PMS_BASE_URL_DEV`. If unset or placeholder, uses
  /// [_pmsBaseUrlFallback] (not project management — different API host).
  static String get pmsBaseUrl {
    final raw = Env.pmsBaseUrlDev.trim();
    if (raw.isEmpty || raw.contains('example.com')) {
      return _pmsBaseUrlFallback;
    }
    return raw;
  }

  /// Project Management file/download URLs use the API host origin without the `/api/` path segment.
  static String get projectManagementOrigin {
    final uri = Uri.parse(projectManagementBaseUrl);
    return Uri(
      scheme: uri.scheme,
      host: uri.host,
      port: uri.hasPort ? uri.port : null,
    ).toString();
  }

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
