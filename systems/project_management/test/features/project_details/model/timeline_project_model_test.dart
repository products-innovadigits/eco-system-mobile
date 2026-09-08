import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/project_details/model/project_timeline_model.dart';
import 'package:project_management/features/project_details/model/timeline_project_model.dart';
import 'package:project_management/features/project_details/widgets/tabs/timeline_tab/timeline_date_utils.dart';

void main() {
  MilestoneModel milestone({
    DateTime? start,
    DateTime? end,
    List<SubActivityModel>? subs,
  }) => MilestoneModel(
    id: 1,
    name: 'M1',
    startDate: start,
    endDate: end,
    subActivities: subs,
  );

  group('TimelineWindow.resolve', () {
    test('falls back to the project bounds when there is no data', () {
      final window = TimelineWindow.resolve(
        projectStart: DateTime(2025, 3, 10),
        projectEnd: DateTime(2025, 8, 4),
      );

      expect(window.start, DateTime(2025, 3, 10));
      expect(window.end, DateTime(2025, 8, 4));
      // Column 0 is the first day of the start month.
      expect(window.origin, DateTime(2025, 3, 1));
    });

    test('widens to cover milestones and sub-activities outside the '
        'project bounds', () {
      final window = TimelineWindow.resolve(
        projectStart: DateTime(2025, 3, 1),
        projectEnd: DateTime(2025, 4, 1),
        milestones: [
          milestone(
            start: DateTime(2025, 1, 20),
            end: DateTime(2025, 2, 10),
            subs: [
              SubActivityModel(
                id: 1,
                startDate: DateTime(2025, 1, 20),
                endDate: DateTime(2025, 9, 30),
              ),
            ],
          ),
        ],
      );

      expect(window.start, DateTime(2025, 1, 20));
      expect(window.end, DateTime(2025, 9, 30));
    });

    test('resolves without any date at all', () {
      final window = TimelineWindow.resolve();
      expect(window.end.isBefore(window.start), isFalse);
    });
  });

  group('TimelineWindow.offsetOf', () {
    final window = TimelineWindow.resolve(
      projectStart: DateTime(2025, 1, 1),
      projectEnd: DateTime(2025, 12, 31),
    );

    test('snaps a date to its week bucket', () {
      // W1: 1-7, W2: 8-14, W3: 15-21, W4: 22-end.
      expect(window.offsetOf(DateTime(2025, 1, 1)), 0);
      expect(window.offsetOf(DateTime(2025, 1, 7)), 0);
      expect(window.offsetOf(DateTime(2025, 1, 8)), 1);
      expect(window.offsetOf(DateTime(2025, 1, 16)), 2);
      expect(window.offsetOf(DateTime(2025, 1, 22)), 3);
      expect(window.offsetOf(DateTime(2025, 1, 31)), 3);
      // Each month takes exactly 4 columns.
      expect(window.offsetOf(DateTime(2025, 2, 1)), 4);
      expect(window.offsetOf(DateTime(2025, 3, 1)), 8);
    });

    test('endOfCell moves to the end of the date week cell', () {
      expect(window.offsetOf(DateTime(2025, 1, 1), endOfCell: true), 1);
      expect(window.offsetOf(DateTime(2025, 1, 31), endOfCell: true), 4);
    });
  });

  group('TimelineWindow.spanOf', () {
    final window = TimelineWindow.resolve(
      projectStart: DateTime(2025, 1, 1),
      projectEnd: DateTime(2025, 3, 31),
    );

    test('an item inside one week is exactly one column wide', () {
      final span = window.spanOf(DateTime(2025, 1, 5), DateTime(2025, 1, 5))!;
      expect(span.start, 0);
      expect(span.end, 1);
      expect(span.width, 1);
    });

    test('width counts the week cells the item touches', () {
      final span = window.spanOf(DateTime(2025, 1, 5), DateTime(2025, 1, 16))!;
      expect(span.start, 0); // W1
      expect(span.end, 3); // through W3, exclusive end
      expect(span.width, 3);
    });

    test('items inside the same week collapse onto the same cell - which is '
        'why a truncated label needs its tooltip', () {
      final first = window.spanOf(DateTime(2025, 1, 1), DateTime(2025, 1, 2))!;
      final second = window.spanOf(DateTime(2025, 1, 3), DateTime(2025, 1, 7))!;
      expect(second.start, first.start);
      expect(second.width, first.width);
    });

    test('clamps to the window and drops ranges fully outside it', () {
      final clamped = window.spanOf(
        DateTime(2024, 12, 1),
        DateTime(2025, 1, 10),
      )!;
      expect(clamped.start, 0);

      expect(window.spanOf(DateTime(2025, 6, 1), DateTime(2025, 7, 1)), isNull);
      expect(window.spanOf(null, DateTime(2025, 1, 1)), isNull);
    });

    test('tolerates a reversed range', () {
      final reversed = window.spanOf(
        DateTime(2025, 1, 20),
        DateTime(2025, 1, 10),
      )!;
      final forward = window.spanOf(
        DateTime(2025, 1, 10),
        DateTime(2025, 1, 20),
      )!;
      expect(reversed.start, forward.start);
      expect(reversed.end, forward.end);
    });
  });

  group('ProjectMonth.generateMonths', () {
    test('covers the window and always shows at least 4 months', () {
      final months = ProjectMonth.generateMonths(
        DateTime(2025, 11, 3),
        DateTime(2026, 1, 20),
      );
      expect(months.length, 4);
      expect(months.first.year, 2025);
      expect(months.first.month, 11);
      expect(months.last.year, 2026);
      expect(months.last.month, 2);
      expect(months.first.displayName, contains('2025'));
    });
  });

  group('PlacedMilestone', () {
    test('exposes the lane width its layout reserved', () {
      final placed = PlacedMilestone(
        milestone: milestone(),
        row: 1,
        rowSpanRows: 3,
        bottomRow: 3,
        laneStartOffset: 2,
        laneEndOffset: 6.5,
        barStartOffset: 2,
        barEndOffset: 4,
        subActivities: const [],
      );

      expect(placed.laneWidth, 4.5);
      expect(placed.subCount, 0);
      expect(placed.milestone.name, 'M1');
    });
  });
}
