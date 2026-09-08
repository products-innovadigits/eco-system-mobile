import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/project_details/model/project_timeline_model.dart';
import 'package:project_management/features/project_details/widgets/tabs/timeline_tab/project_timeline_fullscreen_view.dart';

/// Mirrors the app's own app bar: it resolves its height through the *global
/// navigator* context, which makes the Navigator element a dependent of an
/// inherited widget far above it.
class _NavContextAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<NavigatorState> navKey;

  const _NavContextAppBar({required this.navKey});

  @override
  Size get preferredSize {
    final BuildContext ctx = navKey.currentContext!;
    final bool isLandscape =
        MediaQuery.of(ctx).orientation == Orientation.landscape;
    return Size(double.infinity, isLandscape ? 44 : 55);
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

void main() {
  testWidgets('rotating while the full screen timeline is open does not '
      'break inherited dependencies', (tester) async {
    final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();
    final DateTime start = DateTime(2025, 1, 1);
    final DateTime end = DateTime(2026, 12, 5);

    addTearDown(tester.view.reset);
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        child: MaterialApp(
          navigatorKey: navKey,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(1)),
            child: child ?? const SizedBox.shrink(),
          ),
          home: Builder(
            builder: (context) => Scaffold(
              appBar: _NavContextAppBar(navKey: navKey),
              body: const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    navKey.currentState!.push(
      MaterialPageRoute<void>(
        builder: (_) => ProjectTimelineFullscreenView(
          projectStart: start,
          projectEnd: end,
          milestones: [
            MilestoneModel(id: 1, name: 'M1', startDate: start, endDate: end),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Rotate to landscape, as the full screen view asks the platform to do.
    tester.view.physicalSize = const Size(2400, 1080);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull, reason: 'rotating into landscape');

    // And back again on the way out.
    navKey.currentState!.pop();
    await tester.pumpAndSettle();
    tester.view.physicalSize = const Size(1080, 2400);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 500));
    expect(tester.takeException(), isNull, reason: 'rotating back to portrait');
  });
}
