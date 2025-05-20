import 'package:eco_system/features/ats/candidates/view/screens/candidates_view.dart';
import 'package:eco_system/features/ats/jobs/view/screens/jobs_view.dart';
import 'package:eco_system/features/ats/profile/view/screens/profile_view.dart';
import 'package:eco_system/features/ats/talent_pool/view/screens/talent_pool_view.dart';
import 'package:eco_system/features/auth/login/view/login.dart';
import 'package:eco_system/features/auth/otp/view/otp_view.dart';
import 'package:eco_system/features/intro/view/intro_view.dart';
import 'package:eco_system/features/main_page.dart';
import 'package:eco_system/features/objectives/view/objectives_view.dart';
import 'package:eco_system/features/projects/view/projects_view.dart';
import 'package:eco_system/features/search/view/screens/search_view.dart';
import 'package:eco_system/features/splash/splash.dart';

import '../features/intro/view/onboarding.dart';
import '../features/objective_details/view/objective_details_view.dart';
import '../features/project_details/view/project_details_view.dart';
import '../main.dart';
import '../utility/export.dart';

const begin = Offset(0.0, 1.0);
const end = Offset.zero;
const curve = Curves.bounceInOut;
var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

abstract class CustomNavigator {
  static final GlobalKey<NavigatorState> navigatorState =
      GlobalKey<NavigatorState>();
  static final RouteObserver<PageRoute> routeObserver =
      RouteObserver<PageRoute>();
  static final GlobalKey<ScaffoldMessengerState> scaffoldState =
      GlobalKey<ScaffoldMessengerState>();

  static Route<dynamic> onCreateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.APP:
        return pageRouteBuilder(const MyApp());
      case Routes.SPLASH:
        return pageRouteBuilder(const Splash());
      case Routes.BOARDING:
        return pageRouteBuilder(const OnBoarding());
      case Routes.INTRO:
        return pageRouteBuilder(const IntroView());
      case Routes.LOGIN:
        return pageRouteBuilder(const LoginView());
      case Routes.JOBS:
        return pageRouteBuilder(const JobsView());
      case Routes.TALENT_POOL:
        return pageRouteBuilder(const TalentPoolView());
      case Routes.SEARCH:
        return pageRouteBuilder(SearchView(searchEnum: settings.arguments as SearchEnum));
      case Routes.PROFILE:
        final args = settings.arguments as ProfileViewArgs?;
        return pageRouteBuilder(ProfileView(
            isTalent: args?.isTalent ?? false,
            candidateId: args?.candidateId ?? 0));
      case Routes.CANDIDATES:
        final args = settings.arguments as InitCandidates?;
        return pageRouteBuilder(BlocProvider(
          create: (_) => CandidatesBloc()..add(args ?? InitCandidates()),
          child: Candidates(),
        ));
      case Routes.OTP:
        return pageRouteBuilder(const OtpView());

      case Routes.MAIN_PAGE:
        return pageRouteBuilder(
          MainPage(
              index:
                  settings.arguments != null ? settings.arguments as int : 0),
        );
      case Routes.OBJECTIVES:
        return pageRouteBuilder(const ObjectivesView());

      case Routes.OBJECTIVE_DETAILS:
        return pageRouteBuilder(
            ObjectiveDetailsView(id: settings.arguments as int));

      case Routes.PROJECTS:
        return pageRouteBuilder(const ProjectsView());

      case Routes.PROJECT_DETAILS:
        return pageRouteBuilder(
            ProjectDetailsView(id: settings.arguments as int));

      default:
        return MaterialPageRoute(builder: (_) => const MyApp());
    }
  }

  static pageRouteBuilder(Widget child) => PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => child,
        transitionsBuilder: (
          context,
          animation,
          secondaryAnimation,
          child,
        ) {
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );

  static pop({dynamic result}) {
    if (navigatorState.currentState?.canPop() == true) {
      navigatorState.currentState?.pop(result);
    }
  }

  static push(
    String routeName, {
    arguments,
    bool replace = false,
    bool clean = false,
  }) {
    if (clean) {
      return navigatorState.currentState?.pushNamedAndRemoveUntil(
        routeName,
        (_) => false,
        arguments: arguments,
      );
    } else if (replace) {
      return navigatorState.currentState?.pushReplacementNamed(
        routeName,
        arguments: arguments,
      );
    } else {
      return navigatorState.currentState?.pushNamed(
        routeName,
        arguments: arguments,
      );
    }
  }
}

// ProfileViewArgs
class ProfileViewArgs {
  final bool isTalent;
  final int candidateId;

  ProfileViewArgs({
    required this.isTalent,
    required this.candidateId,
  });
}
