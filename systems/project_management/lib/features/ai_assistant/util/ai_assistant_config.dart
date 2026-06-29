import 'package:flutter/foundation.dart';

/// Runtime configuration for Project AI `/projects/query`.
///
/// **Local backend:** `http://127.0.0.1:8000`
///
/// **Physical device / external access via cloudflared:**
/// ```bash
/// cloudflared tunnel --url http://127.0.0.1:8000
/// ```
/// Then run Flutter with the printed HTTPS URL (trailing slash required):
/// ```bash
/// flutter run --dart-define=PROJECT_AI_BASE_URL=https://your-subdomain.trycloudflare.com/
/// ```
///
/// This URL is dev-only configuration — never used as a hardcoded production endpoint.
class AiAssistantConfig {
  /// Simulator / desktop default when no override is set.
  static const String localBackendBaseUrl = 'https://jake-testimony-fails-syntax.trycloudflare.com/';

  /// Dev override — set to the cloudflared HTTPS origin, e.g.
  /// `https://xxxx.trycloudflare.com/`
  static const String _dartDefineBaseUrl = String.fromEnvironment(
    'PROJECT_AI_BASE_URL',
  );

  /// Override JSON `debug` body flag in non-release builds.
  /// Default `true` in debug/profile; `--dart-define=PROJECT_AI_DEBUG_BODY=false` to disable.
  static const bool _dartDefineDebugBody = bool.fromEnvironment(
    'PROJECT_AI_DEBUG_BODY',
    defaultValue: true,
  );

  /// Resolved POST origin (always ends with `/`).
  static String get queryBaseUrl {
    final fromDefine = _dartDefineBaseUrl.trim();
    if (fromDefine.isNotEmpty) {
      return _ensureTrailingSlash(fromDefine);
    }
    return localBackendBaseUrl;
  }

  /// Full POST URL: `<base>/projects/query`
  static String get queryUrl => '${queryBaseUrl}projects/query';

  /// `debug` in request body: off in release; configurable in dev via dart-define.
  static bool get projectsQueryDebugBody {
    if (kReleaseMode) return false;
    return _dartDefineDebugBody;
  }

  static String _ensureTrailingSlash(String url) {
    return url.endsWith('/') ? url : '$url/';
  }
}
