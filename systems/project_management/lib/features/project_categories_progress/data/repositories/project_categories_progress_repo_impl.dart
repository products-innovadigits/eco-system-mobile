import 'package:core_system/core/utility/export.dart';
import 'package:project_management/features/project_categories_progress/domain/repositories/project_categories_progress_repo.dart';

/// Prototype: simulated category progress — no API.
class ProjectCategoriesProgressRepoImpl
    implements ProjectCategoriesProgressRepo {
  final Network network;

  ProjectCategoriesProgressRepoImpl({required this.network});

  @override
  Future<dynamic> getProjectCategoriesProgress() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return Response(
      requestOptions: RequestOptions(path: 'categoriesProgress'),
      statusCode: 200,
      data: <String, dynamic>{
        'data': [
          {'id': 1, 'name': 'Strategic', 'progress': 0.72, 'color': '#1565C0'},
          {'id': 2, 'name': 'Operational', 'progress': 0.58, 'color': '#00897B'},
          {'id': 3, 'name': 'Innovation', 'progress': 0.46, 'color': '#DC6803'},
        ],
      },
    );
  }
}
