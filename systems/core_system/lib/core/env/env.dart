import 'package:envied/envied.dart';

part 'env.g.dart';

// Resolved relative to **cwd** when running build_runner (use `systems/core_system` as cwd).
// That makes `../../.env` the monorepo root `.env` (same as CI `deploy_apk.yaml`).
@Envied(path: '../../.env', requireEnvFile: false)
abstract class Env {
  // Currently unused — uncomment when needed
  // @EnviedField(varName: 'DOMAIN_PRO', obfuscate: true)
  // static final String domainPro = _Env.domainPro;

  // Currently unused — uncomment when needed
  // @EnviedField(varName: 'DOMAIN_DEV', obfuscate: true)
  // static final String domainDev = _Env.domainDev;

  // Currently unused — uncomment when needed
  // @EnviedField(varName: 'BASE_URL_PRO', obfuscate: true)
  // static final String baseUrlPro = _Env.baseUrlPro;

  @EnviedField(varName: 'STRATEGY_BASE_URL_DEV', obfuscate: true)
  static final String strategyBaseUrlDev = _Env.strategyBaseUrlDev;

  // Currently unused — uncomment when needed
  // @EnviedField(varName: 'AUTH_BASE_URL_DEV', obfuscate: true)
  // static final String authBaseUrlDev = _Env.authBaseUrlDev;

  /// Production ATS API base (override via `ATS_BASE_URL_DEV` in `.env` or CI secrets).
  @EnviedField(
    varName: 'ATS_BASE_URL_DEV',
    obfuscate: true,
    defaultValue: 'https://ats.innoeg.com/api/v1/',
  )
  static final String atsBaseUrlDev = _Env.atsBaseUrlDev;

  /// When empty, [AppConfig] falls back to [projectManagementBaseUrlDev] so local
  /// builds work without a duplicate secret; CI should still set the real PMS host.
  @EnviedField(
    varName: 'PMS_BASE_URL_DEV',
    obfuscate: true,
    defaultValue: '',
  )
  static final String pmsBaseUrlDev = _Env.pmsBaseUrlDev;

  @EnviedField(
    varName: 'PROJECT_MANAGEMENT_BASE_URL_DEV',
    obfuscate: true,
    defaultValue: 'https://194.163.168.5:447/api/',
  )
  static final String projectManagementBaseUrlDev =
      _Env.projectManagementBaseUrlDev;

  // Currently unused — uncomment when needed
  // @EnviedField(varName: 'GOOGLE_MAPS_BASE_URL', obfuscate: true)
  // static final String googleMapsBaseUrl = _Env.googleMapsBaseUrl;

  // Currently unused — uncomment when needed
  // @EnviedField(varName: 'SHARED_PREFERENCES_NAME', obfuscate: true)
  // static final String sharedPreferencesName = _Env.sharedPreferencesName;

  // Currently unused — uncomment when needed
  // @EnviedField(varName: 'API_KEY', defaultValue: '', obfuscate: true)
  // static final String apiKey = _Env.apiKey;
}
