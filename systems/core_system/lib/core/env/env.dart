import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '../../.env')
abstract class Env {
  @EnviedField(varName: 'DOMAIN_PRO')
  static const String domainPro = _Env.domainPro;

  @EnviedField(varName: 'DOMAIN_DEV')
  static const String domainDev = _Env.domainDev;

  @EnviedField(varName: 'BASE_URL_PRO')
  static const String baseUrlPro = _Env.baseUrlPro;

  @EnviedField(varName: 'STRATEGY_BASE_URL_DEV')
  static const String strategyBaseUrlDev = _Env.strategyBaseUrlDev;

  @EnviedField(varName: 'AUTH_BASE_URL_DEV')
  static const String authBaseUrlDev = _Env.authBaseUrlDev;

  @EnviedField(varName: 'ATS_BASE_URL_DEV')
  static const String atsBaseUrlDev = _Env.atsBaseUrlDev;

  @EnviedField(varName: 'GOOGLE_MAPS_BASE_URL')
  static const String googleMapsBaseUrl = _Env.googleMapsBaseUrl;

  @EnviedField(varName: 'SHARED_PREFERENCES_NAME')
  static const String sharedPreferencesName = _Env.sharedPreferencesName;

  @EnviedField(varName: 'API_KEY', defaultValue: '')
  static const String apiKey = _Env.apiKey;
}
