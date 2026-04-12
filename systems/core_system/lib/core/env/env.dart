import 'package:envied/envied.dart';

part 'env.g.dart';

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

  @EnviedField(
    varName: 'STRATEGY_BASE_URL_DEV',
    obfuscate: true,
    defaultValue: 'https://strategy-api-bsc-ar.nawahtech.com/api/',
  )
  static final String strategyBaseUrlDev = _Env.strategyBaseUrlDev;

  // Currently unused — uncomment when needed
  // @EnviedField(varName: 'AUTH_BASE_URL_DEV', obfuscate: true)
  // static final String authBaseUrlDev = _Env.authBaseUrlDev;

  @EnviedField(varName: 'ATS_BASE_URL_DEV', obfuscate: true)
  static final String atsBaseUrlDev = _Env.atsBaseUrlDev;

  @EnviedField(varName: 'PMS_BASE_URL_DEV', obfuscate: true)
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
