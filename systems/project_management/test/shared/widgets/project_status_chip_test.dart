import 'package:core_system/core/config/colors/light_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/core/utility/project_management_utility.dart';
import 'package:project_management/features/project_details/model/project_details_model.dart';
import 'package:project_management/features/project_report/model/project_report_model.dart';
import 'package:project_management/features/project_report/widgets/custom_info_container_widget.dart';
import 'package:project_management/shared/widgets/project_status_chip.dart';

void main() {
  group('projectStatusKey', () {
    test('maps enum keys and English labels to the same key', () {
      const cases = {
        'Delayed': 'Delayed',
        'InProgress': 'InProgress',
        'In Progress': 'InProgress',
        'in_progress': 'InProgress',
        'Completed': 'Completed',
        ' Upcoming ': 'Upcoming',
      };
      cases.forEach((input, key) {
        expect(ProjectManagementUtility.projectStatusKey(input), key);
      });
    });

    test('keeps unknown values and handles empty input', () {
      expect(ProjectManagementUtility.projectStatusKey('متأخر'), 'متأخر');
      expect(ProjectManagementUtility.projectStatusKey(null), '');
      expect(ProjectManagementUtility.projectStatusKey('  '), '');
    });
  });

  Future<CustomInfoContainerWidget?> chipFor(
    WidgetTester tester,
    String? status,
  ) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        child: MaterialApp(
          home: Scaffold(body: ProjectStatusChip(status: status)),
        ),
      ),
    );
    final finder = find.byType(CustomInfoContainerWidget);
    return finder.evaluate().isEmpty
        ? null
        : tester.widget<CustomInfoContainerWidget>(finder);
  }

  // Status fields exactly as the two endpoints returned them.
  final scenarios = {
    'delayed (project 73)': (
      details: {'statusAr': 'متأخر', 'statusEn': 'Delayed'},
      report: {
        'status': 'Delayed',
        'statusAr': 'متأخر',
        'statusEn': 'Delayed',
        'statusEnum': 'Delayed',
      },
      color: LightColor.warning,
    ),
    'in progress (project 500)': (
      details: {'statusAr': 'قيد التنفيذ', 'statusEn': 'In Progress'},
      report: {
        'status': 'InProgress',
        'statusAr': 'قيد التنفيذ',
        'statusEn': 'In Progress',
        'statusEnum': 'InProgress',
      },
      color: LightColor.secondary,
    ),
    'details sends the English label in status': (
      details: {'status': 'In Progress'},
      report: {'status': 'InProgress'},
      color: LightColor.secondary,
    ),
  };

  scenarios.forEach((name, s) {
    testWidgets('details and report chips match: $name', (tester) async {
      final details = ProjectDetailsDataModel.fromJson(s.details);
      final report = ProjectReportDataModel.fromJson(s.report);

      final detailsChip = await chipFor(tester, details.statusKey);
      final reportChip = await chipFor(tester, report.statusKey);

      expect(detailsChip, isNotNull);
      expect(reportChip, isNotNull);
      expect(detailsChip!.color, s.color);
      expect(reportChip!.color, s.color);
      expect(detailsChip.title, reportChip.title);
    });
  });

  testWidgets('renders nothing without a status', (tester) async {
    expect(await chipFor(tester, null), isNull);
    expect(await chipFor(tester, ''), isNull);
  });
}
