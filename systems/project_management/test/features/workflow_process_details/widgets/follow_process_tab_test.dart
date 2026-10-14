import 'package:core_system/core/components/empty_container.dart';
import 'package:core_system/core/widgets/shimmer_cards_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/workflow_process_details/model/process_details_model.dart';
import 'package:project_management/features/workflow_process_details/widgets/tabs/follow_process_tab/follow_process_tab.dart';
import 'package:project_management/features/workflow_process_details/widgets/tabs/follow_process_tab/process_expansion_card_widget.dart';

void main() {
  Future<void> pumpTab(WidgetTester tester, FollowProcessTab tab) {
    return tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        child: MaterialApp(home: Scaffold(body: tab)),
      ),
    );
  }

  group('progressLabel', () {
    test('shows whole numbers without decimals', () {
      expect(ProcessExpansionCardWidget.progressLabel(40), '40%');
      expect(ProcessExpansionCardWidget.progressLabel(100.0), '100%');
    });

    test('keeps one decimal of a fraction', () {
      expect(
        ProcessExpansionCardWidget.progressLabel(33.333333333333336),
        '33.3%',
      );
      expect(ProcessExpansionCardWidget.progressLabel(66.66), '66.7%');
      expect(ProcessExpansionCardWidget.progressLabel(99.96), '100%');
    });
  });

  testWidgets('lists the groups with their progress, first one expanded', (
    tester,
  ) async {
    final groups = GroupStepsModel.fromJson({
      'succeeded': true,
      'data': [
        {
          'groupId': 1,
          'groupName': 'مرحلة التحضير',
          'progress': 33.333333333333336,
          'steps': [
            {'stepName': 'Create request', 'status': 'Approved'},
            {'stepName': 'Review request', 'status': 'Rejected'},
          ],
        },
        {
          'groupId': 2,
          'groupName': 'مرحلة التنفيذ',
          'progress': 0,
          'steps': [
            {'stepName': 'Execute', 'status': 'None'},
          ],
        },
      ],
    }).data!;

    await pumpTab(tester, FollowProcessTab(processList: groups));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('مرحلة التحضير', findRichText: true), findsOneWidget);
    expect(find.text('مرحلة التنفيذ', findRichText: true), findsOneWidget);
    expect(find.text('33.3%'), findsOneWidget);
    expect(find.text('0%'), findsOneWidget);

    // The first group starts expanded, the second collapsed. A collapsed
    // card keeps its steps in the tree, hidden and ignoring touches.
    expect(find.text('Create request').hitTestable(), findsOneWidget);
    expect(find.text('Review request').hitTestable(), findsOneWidget);
    expect(find.text('Execute').hitTestable(), findsNothing);
  });

  testWidgets('shows the API message and retries on a failure', (tester) async {
    var retried = false;
    await pumpTab(
      tester,
      FollowProcessTab(
        processList: const [],
        hasError: true,
        errorMessage: 'Group steps failed',
        onRetry: () => retried = true,
      ),
    );

    expect(find.text('Group steps failed'), findsOneWidget);
    final emptyContainer = tester.widget<EmptyContainer>(
      find.byType(EmptyContainer),
    );
    emptyContainer.onRetry!();
    expect(retried, isTrue);
  });

  testWidgets('shows a shimmer while reloading and the empty state', (
    tester,
  ) async {
    await pumpTab(
      tester,
      const FollowProcessTab(processList: [], isReloading: true),
    );
    expect(find.byType(ShimmerCardsList), findsOneWidget);

    await pumpTab(tester, const FollowProcessTab(processList: []));
    expect(find.byType(EmptyContainer), findsOneWidget);
  });
}
