import 'package:core_system/core/utility/export.dart';
import 'package:project_management/features/projects_progress/domain/repositories/projects_progress_repo.dart';

/// Prototype: simulated portfolio progress breakdown — no API.
class ProjectProgressRepoImpl implements ProjectProgressRepo {
  final Network network;

  ProjectProgressRepoImpl({required this.network});

  @override
  Future<dynamic> getProjectProgress() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return Response(
      requestOptions: RequestOptions(path: 'projectProgress'),
      statusCode: 200,
      data: <String, dynamic>{
        'data': [
          // Arabic names align with LightColor.statusColors for pie charts that use them.
          {'name': 'متقدم', 'hexColor': '#1565C0', 'percentage': 46, 'count': 12},
          {'name': 'متأخر', 'hexColor': '#DC6803', 'percentage': 27, 'count': 5},
          {'name': 'مكتمل', 'hexColor': '#00897B', 'percentage': 27, 'count': 8},
        ],
      },
    );
  }
}
