import 'package:core_package/core/utility/export.dart';

import '../shared/ats_exports.dart';

abstract class FiltrationRepo {
  static Future<TagsModel> getTags() async {
    return await Network().request(
      ApiNames.tags,
      method: ServerMethods.GET,
      model: TagsModel(),
      systemType: 'ats',
    );
  }
}
