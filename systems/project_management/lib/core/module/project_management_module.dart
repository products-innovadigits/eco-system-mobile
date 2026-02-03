import 'package:core_system/core/modules/home_section.dart';
import 'package:core_system/core/modules/system_module.dart';
import 'package:project_management/core/di/project_management_locator.dart';
import 'package:project_management/core/utility/pms_exports.dart';
import 'package:project_management/pms_layout.dart';

/// PMS System module implementation.
///
/// Registers all Bloc providers required by the PMS (Project Management System) module.
class ProjectManagementModule implements SystemModule {
  ProjectManagementModule() {
    setupPmsLocator();
  }

  @override
  String get id => 'project_management';

  @override
  String get name => 'PMS System';

  @override
  ActiveSystemEnum get system => ActiveSystemEnum.pms;

  @override
  List<BlocProvider> get providers => [
    // Projects Filtration Bloc - used for filtering projects
    BlocProvider<ProjectsFiltrationBloc>(
      create: (_) => ProjectsFiltrationBloc(repo: projectManagementSl()),
    ),
    // Latest Request Filtration Cubit - used for filtering requests
    BlocProvider<LatestRequestFiltrationCubit>(
      create: (_) => LatestRequestFiltrationCubit(repo: projectManagementSl()),
    ),
    BlocProvider<StageDocsBloc>(
      create: (_) => StageDocsBloc(repo: projectManagementSl()),
    ),
    BlocProvider<ProjectsProgressCubit>(
      create: (_) => ProjectsProgressCubit(repo: projectManagementSl()),
    ),
    BlocProvider<ProjectCategoriesProgressCubit>(
      create: (_) =>
          ProjectCategoriesProgressCubit(repo: projectManagementSl()),
    ),
  ];

  @override
  Map<String, RouteFactory> get routes => {
    Routes.PMS_LAYOUT: (settings) {
      final args =
          settings.arguments as PmsLayoutArgs? ??
          const PmsLayoutArgs(showSwitcher: true);
      return MaterialPageRoute(
        settings: settings,
        builder: (_) =>
            PmsLayout(index: args.index, showSwitcher: args.showSwitcher),
      );
    },
    Routes.PROJECTS: (settings) =>
        MaterialPageRoute(builder: (_) => const ProjectsView()),
    Routes.PROJECT_DETAILS: (settings) => MaterialPageRoute(
      builder: (_) => ProjectDetailsView(id: settings.arguments as int),
    ),
    Routes.PROJECT_REPORT: (settings) => MaterialPageRoute(
      builder: (_) => ProjectReportView(projectId: settings.arguments as int),
    ),
    Routes.WORKFLOW_PROCESS_DETAILS: (settings) {
      final args = settings.arguments as WorkflowProcessDetailsArgs?;
      return MaterialPageRoute(
        builder: (_) => WorkflowProcessDetailsView(
          processId: args?.processId ?? 0,
          projectId: args?.projectId ?? 0,
          processName: args?.processName ?? '',
          // projectName: args?.projectName ?? '',
          // stageName: args?.stageName ?? '',
          // projectManagerName: args?.projectManagerName ?? '',
          // projectBudget: args?.projectBudget.toDouble() ?? 0,
          // projectStartDate: args?.projectStartDate ?? DateTime.now(),
          // projectEndDate: args?.projectEndDate ?? DateTime.now(),
        ),
      );
    },
    Routes.LATEST_REQUEST: (settings) =>
        MaterialPageRoute(builder: (_) => const LatestRequestView()),
  };

  @override
  List<HomeSection> get homeSections => [
    HomeSection(
      id: 'project_management',
      order: 20,
      builder: (context) {
        if (UserBloc.activeSystems.contains(ActiveSystemEnum.pms)) {
          return const ProjectManagementSection();
        }
        return const SizedBox.shrink();
      },
    ),
  ];
}
