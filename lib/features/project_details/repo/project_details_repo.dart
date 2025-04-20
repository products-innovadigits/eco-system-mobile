import '../../../config/api_names.dart';
import '../../../network/network_layer.dart';

abstract class ProjectDetailsRepo {
  static Future<dynamic> getProjectDetails(id) async {
    return await Network()
        .request(ApiNames.projectDetails(id), method: ServerMethods.GET);
  }


}
