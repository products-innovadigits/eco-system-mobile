import 'package:core_system/core/model/custom_field_model.dart';
import 'package:core_system/core/model/search_engine.dart';
import 'package:core_system/core/network/network_layer.dart';
import 'package:project_management/features/projects/domain/repositories/projects_repo.dart';
import 'package:project_management/features/projects/model/project_sorting_options_model.dart';
import 'package:project_management/features/projects/model/projects_filters_model.dart';
import 'package:project_management/features/projects/model/projects_model.dart';

/// Prototype: simulated project portfolio — no API.
class ProjectsRepoImpl implements ProjectsRepo {
  final Network network;

  ProjectsRepoImpl({required this.network});

  Map<String, dynamic> _projectItem(
    int id,
    String title, {
    required String status,
    required String statusEn,
    required String statusAr,
    required double progressRation,
    required String description,
    required String riskLevelName,
    required int budget,
    required int outputCount,
    required String projectCategoryName,
  }) =>
      {
        'id': id,
        'title': title,
        'name': title,
        'description': description,
        'startDate': '2026-01-15T00:00:00.000',
        'endDate': '2026-11-30T00:00:00.000',
        'progressRation': progressRation,
        'status': status,
        'statusEn': statusEn,
        'statusAr': statusAr,
        'managerName': 'Demo PM',
        'projectCategoryName': projectCategoryName,
        'periortyLevelName': 'High',
        'riskLevelName': riskLevelName,
        'budget': budget,
        'outputCount': outputCount,
      };

  @override
  Future<ProjectsModel> getProjects(SearchEngine data) async {
    await Future.delayed(const Duration(milliseconds: 220));
    return ProjectsModel.fromJson({
      'succeeded': true,
      'data': {
        'items': [
          _projectItem(
            1001,
            'Customer experience platform',
            status: 'InProgress',
            statusEn: 'In progress',
            statusAr: 'متقدم',
            progressRation: 0.68,
            description:
                'Unified CX roadmap — delivery on track for Q3 milestones.',
            riskLevelName: 'Medium',
            budget: 420000,
            outputCount: 5,
            projectCategoryName: 'Strategic',
          ),
          _projectItem(
            1002,
            'Data hub initiative',
            status: 'Delayed',
            statusEn: 'Delayed',
            statusAr: 'متأخر',
            progressRation: 0.38,
            description:
                'Enterprise data lake — scope refinement and vendor delays.',
            riskLevelName: 'Elevated',
            budget: 890000,
            outputCount: 8,
            projectCategoryName: 'Operational',
          ),
          _projectItem(
            1003,
            'Sustainability reporting',
            status: 'Completed',
            statusEn: 'Completed',
            statusAr: 'مكتمل',
            progressRation: 1.0,
            description:
                'ESG dashboards and annual disclosure pack — closed successfully.',
            riskLevelName: 'Low',
            budget: 195000,
            outputCount: 4,
            projectCategoryName: 'Strategic',
          ),
        ],
        'currentPage': 1,
        'pageSize': 20,
        'totalPages': 1,
        'nextPage': null,
        'previousPage': null,
        'isLastPage': true,
        'totalCount': 3,
      },
    });
  }

  @override
  Future<CustomFieldsModel> getProjectPriorityLevel() async {
    await Future.delayed(const Duration(milliseconds: 120));
    return CustomFieldsModel.fromJson({
      'status_code': 200,
      'data': [
        {'id': 1, 'name': 'Low'},
        {'id': 2, 'name': 'Medium'},
        {'id': 3, 'name': 'High'},
      ],
    });
  }

  @override
  Future<ProjectsFiltersModel> getProjectFilterOptions() async {
    await Future.delayed(const Duration(milliseconds: 120));
    return ProjectsFiltersModel.fromJson({
      'succeeded': true,
      'data': {
        'categories': [
          {'id': 1, 'name': 'Strategic'},
          {'id': 2, 'name': 'Operational'},
        ],
        'priorities': [
          {'id': 1, 'name': 'P1'},
          {'id': 2, 'name': 'P2'},
        ],
        'risks': [
          {'id': 1, 'name': 'Low'},
          {'id': 2, 'name': 'Elevated'},
        ],
        'statuses': [
          {'item1': 'قيد التنفيذ', 'item2': 'InProgress', 'item3': 1},
          {'item1': 'متأخر', 'item2': 'Delayed', 'item3': 2},
          {'item1': 'قادم', 'item2': 'Upcoming', 'item3': 3},
          {'item1': 'مكتمل', 'item2': 'Completed', 'item3': 4},
        ],
      },
    });
  }

  @override
  Future<ProjectSortingOptionsModel> getProjectSortingOptions() async {
    await Future.delayed(const Duration(milliseconds: 120));
    return ProjectSortingOptionsModel.fromJson({
      'succeeded': true,
      'data': [
        {'id': 1, 'nameAr': 'الأحدث', 'nameEn': 'Newest'},
        {'id': 2, 'nameAr': 'الاسم', 'nameEn': 'Name'},
        {'id': 3, 'nameAr': 'التقدم', 'nameEn': 'Progress'},
      ],
    });
  }
}
