import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/project_details/model/project_timeline_model.dart';
import 'package:project_management/features/project_details/model/timeline_project_model.dart';

void main() {
  group('ProjectItem', () {
    test('can be constructed with required fields', () {
      const item = ProjectItem(
        startMonth: 1,
        startWeek: 1,
        endMonth: 3,
        endWeek: 2,
      );
      expect(item.startMonth, 1);
      expect(item.startWeek, 1);
      expect(item.endMonth, 3);
      expect(item.endWeek, 2);
      expect(item.preferredRow, isNull);
      expect(item.name, isNull);
      expect(item.subProjects, isNull);
    });

    test('can be constructed with optional name and subProjects', () {
      const sub = ProjectItem(
        startMonth: 2,
        startWeek: 1,
        endMonth: 2,
        endWeek: 4,
      );
      const item = ProjectItem(
        startMonth: 1,
        startWeek: 1,
        endMonth: 3,
        endWeek: 2,
        name: 'Parent',
        subProjects: [sub],
        preferredRow: 0,
      );
      expect(item.name, 'Parent');
      expect(item.subProjects, isNotNull);
      expect(item.subProjects!.length, 1);
      expect(item.subProjects!.first.name, isNull);
      expect(item.preferredRow, 0);
    });
  });

  group('Span', () {
    test('holds start and end values', () {
      final span = Span(1, 10);
      expect(span.s, 1);
      expect(span.e, 10);
    });
  });

  group('PlacedProject', () {
    test('can be constructed with all required fields', () {
      const item = ProjectItem(
        startMonth: 1,
        startWeek: 1,
        endMonth: 2,
        endWeek: 4,
      );
      final placed = PlacedProject(
        item: item,
        row: 0,
        minCol: 0,
        maxCol: 8,
        rowSpanRows: 1,
        bottomRow: 0,
        subCount: 0,
      );
      expect(placed.item, item);
      expect(placed.row, 0);
      expect(placed.minCol, 0);
      expect(placed.maxCol, 8);
      expect(placed.rowSpanRows, 1);
      expect(placed.bottomRow, 0);
      expect(placed.subCount, 0);
    });
  });

  group('PlacedMilestone', () {
    test('can be constructed with MilestoneModel and layout fields', () {
      final milestone = MilestoneModel(id: 1, name: 'M1');
      final placed = PlacedMilestone(
        milestone: milestone,
        row: 1,
        minCol: 2,
        maxCol: 4,
        rowSpanRows: 1,
        bottomRow: 1,
        subCount: 2,
      );
      expect(placed.milestone, milestone);
      expect(placed.milestone.id, 1);
      expect(placed.milestone.name, 'M1');
      expect(placed.row, 1);
      expect(placed.minCol, 2);
      expect(placed.maxCol, 4);
      expect(placed.subCount, 2);
    });
  });

  group('LayoutResult', () {
    test('can be constructed with null lists and maxRowIndex', () {
      final result = LayoutResult(maxRowIndex: 5);
      expect(result.placed, isNull);
      expect(result.placedMilestones, isNull);
      expect(result.maxRowIndex, 5);
    });

    test('can be constructed with placed and placedMilestones', () {
      const item = ProjectItem(
        startMonth: 1,
        startWeek: 1,
        endMonth: 1,
        endWeek: 4,
      );
      final placed = PlacedProject(
        item: item,
        row: 0,
        minCol: 0,
        maxCol: 4,
        rowSpanRows: 1,
        bottomRow: 0,
        subCount: 0,
      );
      final milestone = MilestoneModel(id: 1, name: 'M1');
      final placedMilestone = PlacedMilestone(
        milestone: milestone,
        row: 1,
        minCol: 0,
        maxCol: 2,
        rowSpanRows: 1,
        bottomRow: 1,
        subCount: 0,
      );
      final result = LayoutResult(
        placed: [placed],
        placedMilestones: [placedMilestone],
        maxRowIndex: 2,
      );
      expect(result.placed, isNotNull);
      expect(result.placed!.length, 1);
      expect(result.placedMilestones, isNotNull);
      expect(result.placedMilestones!.length, 1);
      expect(result.maxRowIndex, 2);
    });
  });
}
