import 'package:ats_system/shared/ats_exports.dart';
import 'package:ats_system/shared/ats_prototype_data.dart';
import 'package:core_system/core/utility/export.dart';

/// Prototype: simulated job requisitions — no API.
abstract class JobsRepo {
  static Future<JobsModel> getJobs(SearchEngine data) async {
    await Future.delayed(const Duration(milliseconds: 220));
    return buildPrototypeJobsModel();
  }
}
