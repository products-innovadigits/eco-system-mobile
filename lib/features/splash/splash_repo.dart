import 'package:core_package/core/utility/export.dart';

abstract class SplashRepo {
  static Future<List<String>> fetchSystems() async {
    final res = await Network().request(
      ApiNames.activeSystems,
      method: ServerMethods.GET,
    );
    if (res is Response && res.data != null) {
      final data = res.data['data'];
      if (data is List) {
        return List<String>.from(data);
      }
    }
    return [];
  }
}