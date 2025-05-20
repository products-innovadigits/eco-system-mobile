import 'package:eco_system/features/ats/model/tags_model.dart';
import 'package:eco_system/utility/export.dart';

abstract class FiltrationRepo {
  static Future<TagsModel> getTags() async {
    return await Network().request(
      ApiNames.tags,
      method: ServerMethods.GET,
      model: TagsModel(),
    );
  }
}
