import '../../../config/api_names.dart';
import '../../../network/network_layer.dart';

abstract class ProjectCategoriesProgressRepo {
  static Future<dynamic> getProjectCategoriesProgress() async {
    return await Network()
        .request(ApiNames.ProjectCategoriesProgress, method: ServerMethods.GET);
  }


}
