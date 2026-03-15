import 'package:flutter_test/flutter_test.dart';
import 'package:pms_system/features/employee_learning_details/model/employee_learning_details_model.dart';

import '../../../helpers/model_field_asserts.dart';

void main() {
  group('EmployeeLearningDetailsModel', () {
    test('mock factory returns populated model', () {
      final model = EmployeeLearningDetailsModel.mock();

      expect(model.employeeName, isNotNull,
          reason: 'Mock should provide employeeName');
      expect(model.highestCompetency, isNotNull,
          reason: 'Mock should provide highestCompetency');
      expect(model.lowestCompetency, isNotNull,
          reason: 'Mock should provide lowestCompetency');
      expect(model.reviewCycles, isNotEmpty,
          reason: 'Mock should provide non-empty reviewCycles');

      expectModelFields([
        (
          key: 'employeeName',
          actual: model.employeeName,
          expected: 'Abdelraheem'
        ),
        (
          key: 'highestCompetency.name',
          actual: model.highestCompetency?.name,
          expected: 'Problem Solving'
        ),
        (
          key: 'lowestCompetency.name',
          actual: model.lowestCompetency?.name,
          expected: 'Design System'
        ),
      ]);
    });

    test('constructor with null fields works', () {
      final model = EmployeeLearningDetailsModel();

      expect(model.employeeName, isNull);
      expect(model.highestCompetency, isNull);
      expect(model.lowestCompetency, isNull);
      expect(model.reviewCycles, isEmpty);
    });
  });

  group('CompetencyItem', () {
    test('scoreLabel formats correctly', () {
      final item = CompetencyItem(name: 'Test', score: 4.5, maxScore: 5);

      expect(item.scoreLabel, equals('(4.5/5.0)'),
          reason: 'scoreLabel should format as (score/maxScore)');
    });

    test('default maxScore is 5', () {
      final item = CompetencyItem(name: 'Test', score: 3.0);

      expect(item.maxScore, equals(5),
          reason: 'Default maxScore should be 5');
    });
  });

  group('ReviewCycleItem', () {
    test('constructor stores all fields', () {
      final date = DateTime(2024, 12, 11);
      final item = ReviewCycleItem(
        role: 'Senior Developer',
        dateOfCycle: date,
        cycleId: 1,
      );

      expectModelFields([
        (key: 'role', actual: item.role, expected: 'Senior Developer'),
        (key: 'cycleId', actual: item.cycleId, expected: 1),
      ]);
      expect(item.dateOfCycle, equals(date));
    });
  });
}
