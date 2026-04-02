import 'package:core_system/core/utility/export.dart';
import 'package:project_management/features/project_report/domain/repositories/project_report_repo.dart';

/// Prototype: simulated project report payload — no API.
class ProjectReportRepoImpl implements ProjectReportRepo {
  final Network network;

  ProjectReportRepoImpl({required this.network});

  @override
  Future<dynamic> getProjectReport(int id) async {
    await Future.delayed(const Duration(milliseconds: 240));
    return Response(
      requestOptions: RequestOptions(path: 'report/$id'),
      statusCode: 200,
      data: <String, dynamic>{
        'succeeded': true,
        'data': {
          'details': {
            'projectName': 'Customer experience platform',
            'managerName': 'Demo PM',
            'startDate': '2026-01-15T00:00:00.000',
            'endDate': '2026-11-30T00:00:00.000',
            'approvedBudget': 420000,
            'departmentName': 'Technology',
            'categoryName': 'Strategic',
            'description': 'Prototype report body for marketing demos.',
            'statusAr': 'متقدم',
          },
          'progress': {
            'averageProgress': 68,
            'bars': [
              {'key': 'p1', 'label': 'Delivery', 'background': '#1565C0', 'value': 72},
              {'key': 'p2', 'label': 'Budget', 'background': '#00897B', 'value': 64},
            ],
          },
          'status': 'InProgress',
          'statusAr': 'متقدم',
          'statusEn': 'In progress',
          'daysLeft': 120,
          'risksCount': 2,
          'activitiesCount': 14,
          'outputsCount': 5,
          'pdfFileUrl': null,
        },
      },
    );
  }
}
