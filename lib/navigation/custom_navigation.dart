import 'package:ats_system/candidates/bloc/candidates_bloc.dart';
import 'package:ats_system/candidates/view/screens/candidates_view.dart';
import 'package:ats_system/jobs/view/screens/jobs_view.dart';
import 'package:ats_system/profile/view/screens/profile_view.dart';
import 'package:ats_system/talent_pool/view/screens/talent_pool_view.dart';
import 'package:core_system/core/components/system_switcher.dart';
import 'package:core_system/core/utility/export.dart';
import 'package:eco_system/features/auth/login/view/login.dart';
import 'package:eco_system/features/auth/otp/view/otp_view.dart';
import 'package:eco_system/features/intro/view/intro_view.dart';
import 'package:eco_system/features/intro/view/onboarding.dart';
import 'package:eco_system/features/main_page/view/main_page.dart';
import 'package:eco_system/features/splash/splash.dart';
import 'package:pms_system/pms_layout.dart';
import 'package:pms_system/project_details/view/project_details_view.dart';
import 'package:pms_system/projects/view/projects_view.dart';
import 'package:pms_system/workflow_process_details/view/workflow_process_details_view.dart';
import 'package:strategy_system/bsc/view/bsc_view.dart';
import 'package:strategy_system/objective_details/view/objective_details_view.dart';
import 'package:strategy_system/objectives/view/objectives_view.dart';
import 'package:strategy_system/okr/view/okr_view.dart';
import 'package:strategy_system/strategic_axes/view/strategic_axes_view.dart';
import 'package:strategy_system/strategy_layout.dart';

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.SPLASH:
        return MaterialPageRoute(builder: (_) => const Splash());

      case Routes.BOARDING:
        return MaterialPageRoute(builder: (_) => const OnBoarding());

      case Routes.INTRO:
        return MaterialPageRoute(builder: (_) => const IntroView());

      case Routes.LOGIN:
        return MaterialPageRoute(builder: (_) => const LoginView());

      case Routes.OTP:
        return MaterialPageRoute(builder: (_) => const OtpView());

      case Routes.MAIN_PAGE:
        return MaterialPageRoute(builder: (_) => const MainPage());

      case Routes.SYSTEM_SWITCHER:
        return MaterialPageRoute(
          builder: (_) => SystemsSwitcher(
            systemEnum:
                settings.arguments as ActiveSystemEnum? ??
                ActiveSystemEnum.strategy,
          ),
        );

      /// Strategy Routes ===========================================
      case Routes.STRATEGY_LAYOUT:
        final args = settings.arguments as MainPageArgs?;
        return MaterialPageRoute(
          builder: (_) => StrategyLayout(index: args?.index ?? 0),
        );

      case Routes.OBJECTIVES:
        return MaterialPageRoute(builder: (_) => const ObjectivesView());

      case Routes.BSC:
        return MaterialPageRoute(builder: (_) => const BscView());

      case Routes.OKR:
        return MaterialPageRoute(builder: (_) => const OkrView());

      case Routes.STRATEGIC_AXES:
        return MaterialPageRoute(builder: (_) => const StrategicAxesView());

      case Routes.OBJECTIVE_DETAILS:
        return MaterialPageRoute(
          builder: (_) => ObjectiveDetailsView(id: settings.arguments as int),
        );

      /// PMS Routes ===========================================
      case Routes.PMS_LAYOUT:
        final args = settings.arguments as MainPageArgs?;
        return MaterialPageRoute(
          builder: (_) => PmsLayout(index: args?.index ?? 0),
        );

      case Routes.PROJECTS:
        return MaterialPageRoute(builder: (_) => const ProjectsView());

      case Routes.PROJECT_DETAILS:
        return MaterialPageRoute(
          builder: (_) => ProjectDetailsView(id: settings.arguments as int),
        );

      case Routes.WORKFLOW_PROCESS_DETAILS:
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

      /// ATS Routes ===========================================
      case Routes.JOBS:
        return MaterialPageRoute(builder: (_) => const JobsView());

      case Routes.TALENT_POOL:
        return MaterialPageRoute(builder: (_) => const TalentPoolView());

      case Routes.PROFILE:
        final args = settings.arguments as ProfileViewArgs?;
        return MaterialPageRoute(
          builder: (_) => ProfileView(
            isTalent: args?.isTalent ?? false,
            candidateId: args?.candidateId ?? 0,
          ),
        );

      case Routes.CANDIDATES:
        final args = settings.arguments as InitCandidates?;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => CandidatesBloc()..add(args ?? InitCandidates()),
            child: Candidates(),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text("404 - Page Not Found"))),
        );
    }
  }
}
