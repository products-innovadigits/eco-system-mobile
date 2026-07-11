import 'package:core_system/core/config/app_config.dart';
import 'package:core_system/core/modules/home_section.dart';
import 'package:core_system/core/modules/system_module.dart';
import 'package:project_management/core/di/project_management_locator.dart';
import 'package:project_management/core/utility/project_management_exports.dart';
import 'package:project_management/project_management_layout.dart';

/// Project Management System module implementation.
///
/// Registers all Bloc providers required by the Project Management module.
class ProjectManagementModule implements SystemModule {
  ProjectManagementModule() {
    setupProjectManagementLocator();
  }

  @override
  String get id => 'project_management';

  @override
  String get name => 'Project Management System';

  @override
  ActiveSystemEnum get system => ActiveSystemEnum.projectManagement;

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
    Routes.PROJECT_MANAGEMENT_LAYOUT: (settings) {
      final args =
          settings.arguments as ProjectManagementLayoutArgs? ??
          const ProjectManagementLayoutArgs(showSwitcher: true);
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => ProjectManagementLayout(
          index: args.index,
          showSwitcher: args.showSwitcher,
        ),
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
    Routes.AI_ASSISTANT: (settings) =>
        MaterialPageRoute(builder: (_) => const AiAssistantView()),
    Routes.AI_ASSISTANT_ALL_RESULTS: (settings) => MaterialPageRoute(
      builder: (_) => AiAssistantAllResultsView(
        args: settings.arguments as AiAssistantAllResultsArgs,
      ),
    ),
  };

  @override
  List<HomeSection> get homeSections => [
    HomeSection(
      id: 'project_management',
      order: 20,
      builder: (context) {
        if (AppConfig.activeSystem == ActiveSystemEnum.projectManagement) {
          return const ProjectManagementSection();
        }
        return const SizedBox.shrink();
      },
    ),
  ];
}
