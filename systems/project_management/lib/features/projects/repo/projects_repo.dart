import 'package:project_management/core/utility/pms_exports.dart';


abstract class ProjectsRepo {
  Future<ProjectsModel> getProjects(SearchEngine data);
  Future<CustomFieldsModel> getProjectPriorityLevel();
  Future<ProjectsFiltersModel> getProjectFilterOptions();
  Future<Response> getProjectSortingOptions();
}

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
  Future<Response> getProjectSortingOptions() async {
    final res = await network.requestOrThrow(
      ApiNames.projectSortingOptions,
      method: ServerMethods.GET,
    );
    return res as Response;
  }
}
