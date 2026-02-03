import 'package:get_it/get_it.dart';
import 'package:project_management/core/utility/pms_exports.dart';

final GetIt projectManagementSl = GetIt.asNewInstance();

void setupPmsLocator() {
  // Network
  if (!projectManagementSl.isRegistered<Network>()) {
    projectManagementSl.registerLazySingleton<Network>(() => Network());
  }

  // Repositories
  if (!projectManagementSl.isRegistered<LatestRequestRepo>()) {
    projectManagementSl.registerLazySingleton<LatestRequestRepo>(
      () => LatestRequestRepoImpl(network: projectManagementSl()),
    );
  }
  if (!projectManagementSl.isRegistered<ProjectCategoriesProgressRepo>()) {
    projectManagementSl.registerLazySingleton<ProjectCategoriesProgressRepo>(
      () => ProjectCategoriesProgressRepoImpl(network: projectManagementSl()),
    );
  }
  if (!projectManagementSl.isRegistered<ProjectDetailsRepo>()) {
    projectManagementSl.registerLazySingleton<ProjectDetailsRepo>(
      () => ProjectDetailsRepoImpl(network: projectManagementSl()),
    );
  }
  if (!projectManagementSl.isRegistered<ProjectReportRepo>()) {
    projectManagementSl.registerLazySingleton<ProjectReportRepo>(
      () => ProjectReportRepoImpl(network: projectManagementSl()),
    );
  }
  if (!projectManagementSl.isRegistered<ProjectsRepo>()) {
    projectManagementSl.registerLazySingleton<ProjectsRepo>(
      () => ProjectsRepoImpl(network: projectManagementSl()),
    );
  }
  if (!projectManagementSl.isRegistered<ProjectProgressRepo>()) {
    projectManagementSl.registerLazySingleton<ProjectProgressRepo>(
      () => ProjectProgressRepoImpl(network: projectManagementSl()),
    );
  }
  if (!projectManagementSl.isRegistered<ProcessDetailsRepo>()) {
    projectManagementSl.registerLazySingleton<ProcessDetailsRepo>(
      () => ProcessDetailsRepoImpl(network: projectManagementSl()),
    );
  }
}
