import '../../../config/api_names.dart';
import '../../../network/network_layer.dart';

abstract class ProjectProgressRepo {
  static Future<dynamic> getProjectProgress() async {
    return await Network()
        .request(ApiNames.ProjectProgress, method: ServerMethods.GET);
  }
}
