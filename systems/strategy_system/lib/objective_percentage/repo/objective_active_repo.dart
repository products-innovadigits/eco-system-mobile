import 'package:core_system/core/utility/export.dart';

/// Prototype: simulated aggregate percentages — no API.
abstract class ObjectiveActiveRepo {
  static Future<dynamic> getObjectivePercentage() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return Response(
      requestOptions: RequestOptions(path: ApiNames.objectActivePercentage),
      statusCode: 200,
      data: <String, dynamic>{
        'data': <String, dynamic>{'totalPercentage': 76.5},
      },
    );
  }

  static Future<dynamic> getObjectActiveCategorized() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return Response(
      requestOptions: RequestOptions(path: ApiNames.objectActiveCategorized),
      statusCode: 200,
      data: <String, dynamic>{
        'data': [
          // Arabic keys match LightColor.statusColors (pie + legend).
          {'categoryName': 'متقدم', 'value': 45.0, 'count': 13},
          {'categoryName': 'متأخر', 'value': 28.0, 'count': 5},
          {'categoryName': 'مكتمل', 'value': 27.0, 'count': 11},
        ],
      },
    );
  }
}
