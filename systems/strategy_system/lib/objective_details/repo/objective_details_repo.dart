import 'package:core_system/core/utility/export.dart';

import '../../shared/strategy_prototype_data.dart';

/// Prototype: simulated objective detail, KPIs, initiatives, charts — no API.
abstract class ObjectiveDetailsRepo {
  static Future<dynamic> getObjectDetails(int id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return Response(
      requestOptions: RequestOptions(path: 'objective/$id'),
      statusCode: 200,
      data: <String, dynamic>{
        'data': prototypeObjectiveItem(
          id,
          'Strategic objective #$id',
          (id % 2) + 1,
        ),
      },
    );
  }

  static Future<dynamic> getObjectiveKPIS(int id) async {
    await Future.delayed(const Duration(milliseconds: 180));
    return Response(
      requestOptions: RequestOptions(path: ApiNames.objectiveKPIS),
      statusCode: 200,
      data: <String, dynamic>{
        'data': [
          {
            'indicatorTitle': 'Revenue impact',
            'kpiValue': 82.0,
            'color': '#1565C0',
          },
          {
            'indicatorTitle': 'Customer adoption',
            'kpiValue': 64.0,
            'color': '#00897B',
          },
          {
            'indicatorTitle': 'Delivery confidence',
            'kpiValue': 71.0,
            'color': '#F9A825',
          },
        ],
      },
    );
  }

  static Future<dynamic> getObjectiveInitiatives(int id) async {
    await Future.delayed(const Duration(milliseconds: 180));
    return Response(
      requestOptions: RequestOptions(path: ApiNames.objectiveInitiatives),
      statusCode: 200,
      data: <String, dynamic>{
        'data': [
          {
            'initiativeTitle': 'Pilot with flagship customers',
            'initiativeUpdateLogs': {'newValue': 55.0},
          },
          {
            'initiativeTitle': 'Enablement workshops',
            'initiativeUpdateLogs': {'newValue': 40.0},
          },
        ],
      },
    );
  }

  static Future<dynamic> getObjectiveChartData({
    required int id,
    required String time,
  }) async {
    await Future.delayed(const Duration(milliseconds: 180));
    final isMonth = time.toLowerCase() == 'month';
    final List<Map<String, dynamic>> rows = isMonth
        ? List.generate(6, (i) {
            return {
              'objectValue': 50.0 + i * 4.0,
              'kpisValue': 45.0 + i * 5.0,
              'initiativesValue': 40.0 + i * 3.5,
              'year': 2026,
              'month': i + 1,
            };
          })
        : List.generate(4, (i) {
            return {
              'objectValue': 55.0 + i * 8.0,
              'kpisValue': 50.0 + i * 7.0,
              'initiativesValue': 48.0 + i * 6.0,
              'year': 2023 + i,
              'month': null,
            };
          });
    return Response(
      requestOptions: RequestOptions(path: 'chart/$id/$time'),
      statusCode: 200,
      data: <String, dynamic>{'data': rows},
    );
  }
}
