import 'package:ats_package/candidates/bloc/candidates_bloc.dart';
import 'package:ats_package/candidates/view/screens/candidates_view.dart';
import 'package:ats_package/jobs/view/screens/jobs_view.dart';
import 'package:ats_package/profile/view/screens/profile_view.dart';
import 'package:ats_package/talent_pool/view/screens/talent_pool_view.dart';
import 'package:core_package/core/utility/export.dart';
import 'package:eco_system/features/auth/login/view/login.dart';
import 'package:eco_system/features/auth/otp/view/otp_view.dart';
import 'package:eco_system/features/intro/view/intro_view.dart';
import 'package:eco_system/features/intro/view/onboarding.dart';
import 'package:eco_system/features/main_page.dart';
import 'package:eco_system/features/splash/splash.dart';
import 'package:pms_package/project_details/view/project_details_view.dart';
import 'package:pms_package/projects/view/projects_view.dart';
import 'package:strategy_package/bsc/view/bsc_view.dart';
import 'package:strategy_package/objective_details/view/objective_details_view.dart';
import 'package:strategy_package/objectives/view/objectives_view.dart';

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
        final args = settings.arguments as MainPageArgs?;
        return MaterialPageRoute(
          builder: (_) => MainPage(index: args?.index ?? 0),
        );

      /// Strategy Routes ===========================================
      case Routes.OBJECTIVES:
        return MaterialPageRoute(builder: (_) => const ObjectivesView());

      case Routes.BSC:
        return MaterialPageRoute(builder: (_) => const BscView());

      case Routes.OBJECTIVE_DETAILS:
        return MaterialPageRoute(
          builder: (_) => ObjectiveDetailsView(id: settings.arguments as int),
        );

      /// PMS Routes ===========================================
      case Routes.PROJECTS:
        return MaterialPageRoute(builder: (_) => const ProjectsView());

      case Routes.PROJECT_DETAILS:
        return MaterialPageRoute(
          builder: (_) => ProjectDetailsView(id: settings.arguments as int),
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
