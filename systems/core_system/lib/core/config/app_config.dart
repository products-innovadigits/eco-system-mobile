import 'package:core_system/core/core/enums.dart';
import 'package:core_system/core/env/env.dart';

class AppConfig {
  static const String _strategyBaseUrlFallback =
      'https://strategy-api-bsc-ar.nawahtech.com/api/';

  static const String _projectManagementBaseUrlFallback =
      'https://194.163.168.5:447/api/';

  /// [Env.strategyBaseUrlDev] wins when set; empty or template placeholder
  /// hosts fall back so local `.env` mistakes do not break login.
  static String _resolvedStrategyBaseUrl() {
    final raw = Env.strategyBaseUrlDev.trim();
    if (raw.isEmpty) return _strategyBaseUrlFallback;
    final uri = Uri.tryParse(raw);
    final host = uri?.host.toLowerCase() ?? '';
    if (host == 'placeholder.example.com' ||
        host.endsWith('.placeholder.example.com')) {
      return _strategyBaseUrlFallback;
    }
    return raw;
  }

  static final String strategyBaseUrl = _resolvedStrategyBaseUrl();
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
    // final target = system ?? activeSystem;
    // switch (target.value) {
    //   case 'strategy':
    //     return strategyBaseUrl;
    //   case 'ats':
    //     return atsBaseUrl;
    //   case 'pms':
    //     return pmsBaseUrl;
    //   case 'project_management':
    //     return projectManagementBaseUrl;
    //   default:
    //     return strategyBaseUrl;
    // }
    return strategyBaseUrl; // Default to strategy for now, since other systems are not fully implemented
  }

  // Currently unused — uncomment when needed
  // static final String domain = Env.domainDev;
  // static final String authBaseUrl = Env.authBaseUrlDev;
  // static final String apiKey = Env.apiKey;
  // static final String googleMapsBaseUrl = Env.googleMapsBaseUrl;
}
