import 'package:core_system/core/modules/home_section.dart';
import 'package:core_system/core/modules/system_module.dart';
import 'package:core_system/core/utility/export.dart';
import 'package:pms_system/core/di/pms_locator.dart';
import 'package:pms_system/features/cycle_reports/view/cycle_reports_view.dart';
import 'package:pms_system/features/cycle_review/view/cycle_review_view.dart';
import 'package:pms_system/features/cycle_review/view/cycle_reviewees_view.dart';
import 'package:pms_system/features/cycles/view/cycles_view.dart';
import 'package:pms_system/features/employee_learning_details/domain/employee_learning_details_repo.dart';
import 'package:pms_system/features/employee_learning_details/view/employee_learning_details_view.dart';
import 'package:pms_system/features/employee_of_month_history/view/employee_of_month_history_view.dart';
import 'package:pms_system/features/employees_learning/view/employees_learning_view.dart';
import 'package:pms_system/features/employees_performance/view/employees_performance_view.dart';
import 'package:pms_system/features/pms_home/widgets/cycles_summary_card.dart';
import 'package:pms_system/features/pms_home/widgets/employee_of_the_month_portrait.dart';
import 'package:pms_system/pms_layout.dart';

class PmsModule implements SystemModule {
  PmsModule() {
    setupPmsLocator();
  }

  @override
  String get id => 'pms_system';

  @override
  String get name => 'PMS System';

  @override
  ActiveSystemEnum get system => ActiveSystemEnum.pms;

  @override
  List<BlocProvider> get providers => [];

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
    Routes.CYCLES: (settings) {
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const CyclesView(),
      );
    },
    Routes.CYCLE_REVIEW: (settings) {
      final cycleId = settings.arguments as int? ?? 0;
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => CycleReviewView(cycleId: cycleId),
      );
    },
    Routes.CYCLE_REPORT: (settings) {
      final cycleId = settings.arguments as int? ?? 0;
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => CycleReportsView(cycleId: cycleId, cycleName: ''),
      );
    },
    Routes.EMPLOYEES_LEARNING: (settings) {
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const EmployeesLearningView(),
      );
    },
    Routes.EMPLOYEES_PERFORMANCE: (settings) {
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const EmployeesPerformanceView(),
      );
    },
    Routes.EMPLOYEE_OF_MONTH_HISTORY: (settings) {
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const EmployeeOfMonthHistoryView(),
      );
    },
    Routes.CYCLE_REVIEWEES: (settings) {
      final cycleId = settings.arguments as int? ?? 0;
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => CycleRevieweesView(cycleId: cycleId),
      );
    },
    Routes.EMPLOYEE_LEARNING_DETAILS: (settings) {
      final args = settings.arguments as Map<String, dynamic>?;
      final employeeId = args?['employeeId'] as int? ?? 0;
      final employeeName = args?['employeeName'] as String?;
      return MaterialPageRoute(
        builder: (_) => EmployeeLearningDetailsView(
          employeeId: employeeId,
          repo: pmsSl<EmployeeLearningDetailsRepo>(),
          employeeName: employeeName,
        ),
      );
    },
  };

  @override
  List<HomeSection> get homeSections => [
    HomeSection(
      id: 'pms',
      order: 21,
      builder: (context) {
        if (UserBloc.activeSystems.contains(ActiveSystemEnum.pms)) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const CyclesSummaryCard(),
              SizedBox(height: 16.h),
              const EmployeeOfTheMonthPortraitCard(),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    ),
  ];
}
