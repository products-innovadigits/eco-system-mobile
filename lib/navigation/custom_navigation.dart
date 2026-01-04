import 'package:core_system/core/utility/export.dart';
import 'package:eco_system/app/modules/modules_registry.dart';
import 'package:eco_system/features/auth/login/view/login.dart';
import 'package:eco_system/features/auth/otp/view/otp_view.dart';
import 'package:eco_system/features/intro/view/intro_view.dart';
import 'package:eco_system/features/intro/view/onboarding.dart';
import 'package:eco_system/features/main_page/view/main_page.dart';
import 'package:eco_system/features/splash/splash.dart';

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    // 1. Check for module-specific routes first
    final moduleRouteFactory = ModulesRegistry.appRoutes[settings.name];
    if (moduleRouteFactory != null) {
      return moduleRouteFactory(settings);
    }

    // 2. Handle core app routes
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
        final systemEnum =
            settings.arguments as ActiveSystemEnum? ??
            ActiveSystemEnum.strategy;

        // Set the current active system
        UserBloc.currentActiveSystem = systemEnum;

        // Redirect to the selected system's layout via ModulesRegistry
        final layoutRoute = ModulesRegistry.getLayoutRoute(systemEnum);
        if (layoutRoute != null) {
          return layoutRoute;
        }
        
        // Fallback or error handling
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text("System not found")),
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
