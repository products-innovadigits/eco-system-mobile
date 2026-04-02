import 'package:core_system/core/utility/export.dart';
import 'package:project_management/features/project_details/domain/repositories/project_details_repo.dart';
import 'package:project_management/features/project_details/model/project_details_model.dart';
import 'package:project_management/features/project_management_home/model/kpis_initiatives_progress_model.dart';

/// Prototype: simulated project detail, chart, timeline — no API.
class ProjectDetailsRepoImpl implements ProjectDetailsRepo {
  final Network network;

  ProjectDetailsRepoImpl({required this.network});

  @override
  Future<ProjectDetailsModel> getProjectDetails(int id) async {
    await Future.delayed(const Duration(milliseconds: 220));
    return ProjectDetailsModel.fromJson({
      'succeeded': true,
      'data': {
        'id': id,
        'title': 'Customer experience platform',
        'name': 'Customer experience platform',
        'description':
            'Unified mobile and web journeys with measurable NPS uplift.',
        'startDate': '2026-01-15T00:00:00.000',
        'endDate': '2026-11-30T00:00:00.000',
        'progressRation': 0.68,
        'status': 'InProgress',
        'statusEn': 'In progress',
        'statusAr': 'متقدم',
        'managerName': 'Demo PM',
        'managerId': 'm1',
        'projectCategoryName': 'Strategic',
        'periortyLevelName': 'High',
        'riskLevelName': 'Medium',
        'budget': 420000,
        'outputCount': 5,
        'daysLeft': 120,
      },
    });
  }

  @override
  Future<dynamic> getProjectGeneralProgressSummary(
    int id, {
    ChartTime chartType = ChartTime.monthly,
  }) async {
    await Future.delayed(const Duration(milliseconds: 180));
    return Response(
      requestOptions: RequestOptions(path: 'progress/$id'),
      statusCode: 200,
      data: <String, dynamic>{
        'totalProgress': 68.0,
        'currentMonth': 4,
        'currentYear': 2026,
        'monthProgress': List.generate(
          6,
          (i) => {
            'month': i + 1,
            'year': 2026,
            'progress': 40.0 + i * 5.0,
          },
        ),
        'yearProgress': [
          {'month': null, 'year': 2024, 'progress': 35.0},
          {'month': null, 'year': 2025, 'progress': 52.0},
          {'month': null, 'year': 2026, 'progress': 68.0},
        ],
      },
    );
  }

  @override
  Future<dynamic> projectTimeline(int projectId) async {
    await Future.delayed(const Duration(milliseconds: 180));
    return Response(
      requestOptions: RequestOptions(path: 'timeline/$projectId'),
      statusCode: 200,
      data: <dynamic>[
        {
          'id': 1,
          'name': 'Discovery & design',
          'description': 'Research and UX flows',
          'projectId': projectId,
          'startDate': '2026-01-15T00:00:00.000',
          'endDate': '2026-03-01T00:00:00.000',
        },
        {
          'id': 2,
          'name': 'Build & integrate',
          'description': 'Core platform delivery',
          'projectId': projectId,
          'startDate': '2026-03-01T00:00:00.000',
          'endDate': '2026-08-31T00:00:00.000',
        },
      ],
    );
  }
}
