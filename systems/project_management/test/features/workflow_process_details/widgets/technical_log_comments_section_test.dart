import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/workflow_process_details/model/history_model.dart';
import 'package:project_management/features/workflow_process_details/widgets/tabs/technical_log_tab/technical_log_tab_comments_section.dart';

void main() {
  const base =
      'https://194.163.168.5:448/FileServer/Project/ProjectStepComment';

  testWidgets('shows one chip per attached file, named without the upload '
      'timestamp', (tester) async {
    final comment = StepCommentModel.fromJson({
      'id': 191,
      'text': 'تست',
      'filePath': '$base/1791890025 - 20260719_125826.jpg',
      'filePaths': [
        '$base/1791890025 - 20260719_125826.jpg',
        '$base/1791890765 - test.xlsx',
      ],
      'createdBy': 'أحمد العمري',
      'createdAt': '2026-10-13T11:13:45.7898649+00:00',
    });

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        child: MaterialApp(
          home: Scaffold(
            body: TechnicalLogTabCommentsSection(comments: [comment]),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('20260719_125826.jpg'), findsOneWidget);
    expect(find.text('test.xlsx'), findsOneWidget);
    expect(find.byIcon(Icons.image), findsOneWidget);
    expect(find.byIcon(Icons.table_chart), findsOneWidget);
  });

  group('formatCommentTime', () {
    test('formats the API time (7 fraction digits) in local time', () {
      const createdAt = '2026-10-13T11:13:45.7898649+00:00';
      final local = DateTime.parse(createdAt).toLocal();
      final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
      final period = local.hour >= 12 ? 'PM' : 'AM';
      final minute = local.minute.toString().padLeft(2, '0');

      expect(
        TechnicalLogTabCommentsSection.formatCommentTime(createdAt),
        '${local.day.toString().padLeft(2, '0')}/'
        '${local.month.toString().padLeft(2, '0')}/${local.year}'
        ' - $hour:$minute $period',
      );
    });

    test('is empty instead of a made-up time when unreadable', () {
      expect(TechnicalLogTabCommentsSection.formatCommentTime(null), '');
      expect(TechnicalLogTabCommentsSection.formatCommentTime('oops'), '');
    });
  });
}
