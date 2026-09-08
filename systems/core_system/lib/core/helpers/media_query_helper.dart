import 'package:core_system/core/utility/export.dart';

abstract class MediaQueryHelper {
  /// The app's current media query, read through the global navigator.
  ///
  /// Uses `getInheritedWidgetOfExactType` rather than `MediaQuery.of`: the
  /// latter would register the *navigator element* as a dependent of a
  /// MediaQuery far above it. Nothing wants that dependency — the widget
  /// asking is not the navigator — and it makes every rotation rebuild the
  /// whole app, which can break the framework's descendant invariant.
  static MediaQueryData get instance {
    final BuildContext? context = CustomNavigator.navigatorState.currentContext;
    final MediaQueryData? data = context
        ?.getInheritedWidgetOfExactType<MediaQuery>()
        ?.data;
    return data ??
        MediaQueryData.fromView(
          WidgetsBinding.instance.platformDispatcher.views.first,
        );
  }

  static bool get isLandscape =>
      appMediaQuerySize.width > appMediaQuerySize.height;

  static Size get appMediaQuerySize => instance.size;
  static double get width => appMediaQuerySize.width;
  static double get height => appMediaQuerySize.height;

  static EdgeInsets get appMediaQueryPadding => instance.padding;
  static double get topPadding => appMediaQueryPadding.top;

  static EdgeInsets get appMediaQueryViewPadding => instance.viewPadding;

  static EdgeInsets get appMediaQueryViewInsets => instance.viewInsets;
}
