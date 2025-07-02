
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String domain = dotenv.env['DOMAIN_DEV'] ?? "";
  static String baseUrl = dotenv.env['BASE_URL_DEV'] ?? "";
  static String apiKey = dotenv.env['API_KEY'] ?? "";
  static String googleMapsBaseUrl = dotenv.env['GOOGLE_MAPS_BASE_URL'] ?? "";
}
