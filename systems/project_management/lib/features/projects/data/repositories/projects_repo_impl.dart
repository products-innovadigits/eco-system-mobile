import 'package:core_system/core/config/api_names.dart';
import 'package:core_system/core/model/custom_field_model.dart';
import 'package:core_system/core/model/search_engine.dart';
import 'package:core_system/core/network/network_layer.dart';
import 'package:project_management/features/projects/domain/repositories/projects_repo.dart';
import 'package:project_management/features/projects/model/project_sorting_options_model.dart';
import 'package:project_management/features/projects/model/projects_filters_model.dart';
import 'package:project_management/features/projects/model/projects_model.dart';

class ProjectsRepoImpl implements ProjectsRepo {
  final Network network;

  ProjectsRepoImpl({required this.network});

  @override
  Future<ProjectsModel> getProjects(SearchEngine data) async {
    final res = await network.requestOrThrow(
      ApiNames.projects,
      query: data.query,
      method: ServerMethods.POST,
      model: ProjectsModel(),
    );
    return res as ProjectsModel;
  }

  @override
  Future<CustomFieldsModel> getProjectPriorityLevel() async {
    final res = await network.requestOrThrow(
      ApiNames.projectPriorityLevels,
      model: CustomFieldsModel(),
      method: ServerMethods.GET,
    );
    return res as CustomFieldsModel;
  }

  @override
  Future<ProjectsFiltersModel> getProjectFilterOptions() async {
    final res = await network.requestOrThrow(
      ApiNames.projectFilterOptions,
      model: ProjectsFiltersModel(),
      method: ServerMethods.GET,
    );
    return res as ProjectsFiltersModel;
  }

  @override
  Future<ProjectSortingOptionsModel> getProjectSortingOptions() async {
    final res = await network.requestOrThrow(
      ApiNames.projectSortingOptions,
      method: ServerMethods.GET,
      model: ProjectSortingOptionsModel(),
    );
    return res as ProjectSortingOptionsModel;
  }
}
