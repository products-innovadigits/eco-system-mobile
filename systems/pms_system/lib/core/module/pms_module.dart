import 'package:core_system/core/modules/home_section.dart';
import 'package:core_system/core/modules/system_module.dart';
import 'package:core_system/core/utility/export.dart'; // BlocProvider
import 'package:pms_system/features/latest_request/bloc/filtration/latest_request_filtration_cubit.dart';
import 'package:pms_system/features/latest_request/view/latest_request_view.dart';
import 'package:pms_system/features/project_categories_progress/view/project_category_progress_section.dart';
import 'package:pms_system/features/project_details/view/project_details_view.dart';
import 'package:pms_system/features/project_report/view/project_report_view.dart';
import 'package:pms_system/features/projects/bloc/filtration/projects_filtration_bloc.dart';
import 'package:pms_system/features/projects/view/projects_view.dart';
import 'package:pms_system/features/projects_progress/view/project_management_section.dart';
import 'package:pms_system/features/workflow_process_details/view/workflow_process_details_view.dart';
import 'package:pms_system/pms_layout.dart';

/// PMS System module implementation.
///
/// Registers all Bloc providers required by the PMS (Project Management System) module.
class PmsModule implements SystemModule {
  @override
  String get id => 'pms_system';

  @override
  String get name => 'PMS System';

  @override
  ActiveSystemEnum get system => ActiveSystemEnum.pms;

  @override
  List<BlocProvider> get providers => [
    // Projects Filtration Bloc - used for filtering projects
    BlocProvider<ProjectsFiltrationBloc>(
      create: (_) => ProjectsFiltrationBloc(),
    ),
    // Latest Request Filtration Cubit - used for filtering requests
    BlocProvider<LatestRequestFiltrationCubit>(
      create: (_) => LatestRequestFiltrationCubit(),
    ),
  ];

  @override
  Map<String, RouteFactory> get routes => {
    Routes.PMS_LAYOUT: (settings) {
      final args = settings.arguments as PmsLayoutArgs? ??
          const PmsLayoutArgs(showSwitcher: true);
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => PmsLayout(
          index: args.index,
          showSwitcher: args.showSwitcher,
        ),
      );
    },
    Routes.PROJECTS: (settings) => MaterialPageRoute(builder: (_) => const ProjectsView()),
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
          projectName: args?.projectName ?? '',
          stageName: args?.stageName ?? '',
          projectManagerName: args?.projectManagerName ?? '',
          projectBudget: args?.projectBudget.toDouble() ?? 0,
          projectStartDate: args?.projectStartDate ?? DateTime.now(),
          projectEndDate: args?.projectEndDate ?? DateTime.now(),
        ),
      );
    },
    Routes.LATEST_REQUEST: (settings) => MaterialPageRoute(builder: (_) => const LatestRequestView()),
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
    HomeSection(
      id: 'project_category_progress',
      order: 21,
      builder: (context) {
        if (UserBloc.activeSystems.contains(ActiveSystemEnum.pms)) {
          return const ProjectCategoryProgressSection();
        }
        return const SizedBox.shrink();
      },
    ),
  ];
}
