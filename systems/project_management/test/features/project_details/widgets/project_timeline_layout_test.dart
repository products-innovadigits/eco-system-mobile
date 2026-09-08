import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/project_details/model/project_timeline_model.dart';
import 'package:project_management/features/project_details/widgets/tabs/timeline_tab/project_timeline_fullscreen_view.dart';
import 'package:project_management/features/project_details/widgets/tabs/timeline_tab/timeline_grid_body.dart';
import 'package:project_management/features/project_details/widgets/tabs/timeline_tab/timeline_widget.dart';

void main() {
  const double minWeekWidth = 35;

  Future<void> pumpTimeline(
    WidgetTester tester, {
    required double viewportWidth,
    required DateTime start,
    required DateTime end,
  }) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        child: MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: viewportWidth,
              child: ProjectTimeline(
                projectStart: start,
                projectEnd: end,
                milestonesList: [
                  MilestoneModel(
                    id: 1,
                    name: 'M1',
                    startDate: start,
                    endDate: end,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('columns stretch to fill a viewport the project fits in', (
    tester,
  ) async {
    // Jan-Mar is 3 months, padded to the 4-month minimum => 16 week columns.
    await pumpTimeline(
      tester,
      viewportWidth: 800,
      start: DateTime(2025, 1, 1),
      end: DateTime(2025, 3, 5),
    );

    expect(tester.takeException(), isNull);
    final Size grid = tester.getSize(find.byType(TimelineGridBody));
    expect(grid.width, 800, reason: 'the grid fills the viewport');
    expect(grid.width / 16, greaterThan(minWeekWidth));
  });

  testWidgets('columns keep their minimum and the canvas scrolls when the '
      'project is too long to fit', (tester) async {
    // Jan 2025 - Dec 2026 is 24 months => 96 week columns.
    await pumpTimeline(
      tester,
      viewportWidth: 400,
      start: DateTime(2025, 1, 1),
      end: DateTime(2026, 12, 5),
    );

    expect(tester.takeException(), isNull);
    final Size grid = tester.getSize(find.byType(TimelineGridBody));
    expect(grid.width, 96 * minWeekWidth);
    expect(grid.width, greaterThan(400));

    // The overflow is reachable, not clipped away.
    final scrollView = tester.widget<SingleChildScrollView>(
      find.byType(SingleChildScrollView),
    );
    expect(scrollView.scrollDirection, Axis.horizontal);
  });

  testWidgets('full screen draws the same project with bigger cells', (
    tester,
  ) async {
    final DateTime start = DateTime(2025, 1, 1);
    final DateTime end = DateTime(2026, 12, 5); // 24 months => 96 columns

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        child: MaterialApp(
          home: ProjectTimelineFullscreenView(
            projectStart: start,
            projectEnd: end,
            milestones: [
              MilestoneModel(id: 1, name: 'M1', startDate: start, endDate: end),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    final Size grid = tester.getSize(find.byType(TimelineGridBody));
    expect(grid.width, 96 * kFullscreenWeekWidth);
    // Wider than the same project gets in the portrait tab.
    expect(kFullscreenWeekWidth, greaterThan(minWeekWidth));

    // Leaving the screen restores the orientation after a short delay; let
    // that timer run so it does not outlive the test.
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 500));
  });

  testWidgets('the grid is painted, not one widget per cell', (tester) async {
    await pumpTimeline(
      tester,
      viewportWidth: 400,
      start: DateTime(2025, 1, 1),
      end: DateTime(2026, 12, 5),
    );

    expect(tester.takeException(), isNull);
    // 96 columns x 12 base rows is 1152 cells; the body must stay a single
    // painted node.
    expect(
      find.descendant(
        of: find.byType(TimelineGridBody),
        matching: find.byType(CustomPaint),
      ),
      findsOneWidget,
    );
  });
}
