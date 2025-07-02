import 'package:core_package/core/utility/export.dart';

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

class MainPageArgs {
  final int index;
  final List<String> systems;

  MainPageArgs({
    required this.index,
    required this.systems,
  });
}
