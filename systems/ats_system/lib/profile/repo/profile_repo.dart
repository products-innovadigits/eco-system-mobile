import 'package:ats_system/shared/ats_prototype_data.dart';
import 'package:core_system/core/utility/export.dart';

/// Prototype: simulated candidate profile — no API.
abstract class ProfileRepo {
  static Future<dynamic> getCandidateDetails(int id) async {
    await Future.delayed(const Duration(milliseconds: 220));
    return Response(
      requestOptions: RequestOptions(path: 'candidate/$id'),
      statusCode: 200,
      data: <String, dynamic>{'data': prototypeCandidateProfile(id)},
    );
  }
}
