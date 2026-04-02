import 'package:core_system/core/utility/export.dart';

import '../shared/ats_exports.dart';

/// Prototype: simulated filter tags — no API.
abstract class FiltrationRepo {
  static Future<TagsModel> getTags() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return TagsModel.fromJson({
      'data': [
        {'value': 'remote', 'label': 'Remote friendly'},
        {'value': 'senior', 'label': 'Senior level'},
        {'value': 'design', 'label': 'Design'},
        {'value': 'flutter', 'label': 'Flutter'},
      ],
    });
  }
}
