import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '../../.env', requireEnvFile: false)
abstract class Env {
  @EnviedField(varName: 'DOMAIN_PRO', obfuscate: true)
  static final String domainPro = _Env.domainPro;

  @EnviedField(varName: 'DOMAIN_DEV', obfuscate: true)
  static final String domainDev = _Env.domainDev;

  @EnviedField(varName: 'BASE_URL_PRO', obfuscate: true)
  static final String baseUrlPro = _Env.baseUrlPro;

  @EnviedField(varName: 'STRATEGY_BASE_URL_DEV', obfuscate: true)
  static final String strategyBaseUrlDev = _Env.strategyBaseUrlDev;

  @EnviedField(varName: 'AUTH_BASE_URL_DEV', obfuscate: true)
  static final String authBaseUrlDev = _Env.authBaseUrlDev;

  @EnviedField(varName: 'ATS_BASE_URL_DEV', obfuscate: true)
  static final String atsBaseUrlDev = _Env.atsBaseUrlDev;

  @EnviedField(varName: 'GOOGLE_MAPS_BASE_URL', obfuscate: true)
  static final String googleMapsBaseUrl = _Env.googleMapsBaseUrl;

  @EnviedField(varName: 'SHARED_PREFERENCES_NAME', obfuscate: true)
  static final String sharedPreferencesName = _Env.sharedPreferencesName;

  @EnviedField(varName: 'API_KEY', defaultValue: '', obfuscate: true)
  static final String apiKey = _Env.apiKey;
}
