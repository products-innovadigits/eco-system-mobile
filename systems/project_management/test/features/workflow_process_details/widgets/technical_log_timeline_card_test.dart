import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/workflow_process_details/model/history_model.dart';
import 'package:project_management/features/workflow_process_details/widgets/tabs/technical_log_tab/technical_log_timeline_card.dart';

void main() {
  Future<void> pumpCard(WidgetTester tester, HistoryItemModel item) {
    return tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        child: MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: TechnicalLogTimelineCard(item: item),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('shows the step, group, employee and comments', (tester) async {
    await pumpCard(
      tester,
      HistoryItemModel.fromJson({
        'name': 'طلب مشروع QOED',
        'responsaiblUser': {'fullName': 'سيف بن عبدالله العبدلي'},
        'stepGroup': {'groupName': 'مرحلة التحضير'},
        'stepComments': [
          {'text': 'تست', 'createdBy': 'أحمد العمري'},
        ],
        'lastChangeTime': '2026-10-13T14:09:28.1060451+03:00',
      }),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('طلب مشروع QOED'), findsOneWidget);
    expect(find.text('مرحلة التحضير'), findsOneWidget);
    expect(find.text('سيف بن عبدالله العبدلي'), findsOneWidget);
    expect(find.text('تست'), findsOneWidget);
    expect(find.text('13'), findsOneWidget, reason: 'the day badge');
  });

  testWidgets('shows no made-up date when the change time is missing', (
    tester,
  ) async {
    await pumpCard(tester, HistoryItemModel.fromJson({'name': 'Step'}));

    expect(tester.takeException(), isNull);
    // FormattersHelper falls back to these for a missing date.
    expect(find.text('17'), findsNothing);
    expect(find.text('ابريل'), findsNothing);
  });
}
