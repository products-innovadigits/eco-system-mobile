import 'package:flutter_test/flutter_test.dart';
import 'package:pms_system/features/employee_learning_details/model/employee_learning_details_model.dart';

import '../../../helpers/model_field_asserts.dart';

void main() {
  group('ReviewCyclesModel', () {
    test('fromJson parses data list correctly', () {
      final json = {
        'data': [
          {
            'id': 145,
            'name': 'eeeess 2026-01-05',
            'start_date': '2026-01-05',
            'closed_date': '2026-03-29',
            'is_learning_assignment_sent': false,
            'report': null,
          },
          {
            'id': 8,
            'name': 'Senior Mobile Developer 2025-06-18',
            'start_date': '2025-06-18',
            'closed_date': '2026-03-29',
            'is_learning_assignment_sent': 1,
            'report': {
              'final_score': 3.89035,
              'weakest_area': {'avg': 3, 'name': 'Bug Resolution Time'},
              'strongest_area': {'avg': 5, 'name': 'Code Optimization Score'},
              'weakest_factor': {'avg': 3, 'name': 'Technical Mastery'},
              'strongest_factor': {
                'avg': 4.3,
                'name': 'Professionalism & Strategic Attitude',
              },
            },
          },
        ],
      };

      final model = ReviewCyclesModel.fromJson(json);
      expect(model.data, isNotNull);
      expect(model.data!.length, 2);

      expectModelFields([
        (key: 'data[0].id', actual: model.data![0].id, expected: 145),
        (
          key: 'data[0].name',
          actual: model.data![0].name,
          expected: 'eeeess 2026-01-05',
        ),
        (key: 'data[0].report', actual: model.data![0].report, expected: null),
        (key: 'data[1].id', actual: model.data![1].id, expected: 8),
        (
          key: 'data[1].report.finalScore',
          actual: model.data![1].report?.finalScore,
          expected: 3.89035,
        ),
        (
          key: 'data[1].report.strongestFactor.name',
          actual: model.data![1].report?.strongestFactor?.name,
          expected: 'Professionalism & Strategic Attitude',
        ),
      ]);
    });

    test('fromJson with empty data returns empty list', () {
      final model = ReviewCyclesModel.fromJson({'data': []});
      expect(model.data, isNotNull);
      expect(model.data, isEmpty);
    });

    test('toJson round-trips correctly', () {
      final original = ReviewCyclesModel(
        data: [ReviewCycleItemModel(id: 1, name: 'Test Cycle')],
      );
      final json = original.toJson();
      final restored = ReviewCyclesModel.fromJson(json);
      expect(restored.data?.length, 1);
      expect(restored.data![0].id, 1);
    });
  });

  group('LastReviewCycleReportModel', () {
    test('fromJson parses report_data correctly', () {
      final json = {
        'id': 38,
        'created_at': '2025-07-06 10:12:42',
        'name': 'Mid - Level | Mobile Developer 2025-07-06',
        'report_data': {
          'final_score': 4.011074999999999,
          'weakest_area': {'avg': 3, 'name': 'Feature Delivery Timeliness'},
          'strongest_area': {'avg': 8, 'name': 'App Performance Optimization'},
          'weakest_factor': {
            'avg': 3.25,
            'name': 'Mobile Development Execution',
          },
          'strongest_factor': {
            'avg': 4.333333333333333,
            'name': 'App Maintenance & Optimization',
          },
        },
      };

      final model = LastReviewCycleReportModel.fromJson(json);

      expectModelFields([
        (key: 'id', actual: model.id, expected: 38),
        (
          key: 'name',
          actual: model.name,
          expected: 'Mid - Level | Mobile Developer 2025-07-06',
        ),
        (
          key: 'reportData.strongestFactor.name',
          actual: model.reportData?.strongestFactor?.name,
          expected: 'App Maintenance & Optimization',
        ),
        (
          key: 'reportData.weakestFactor.name',
          actual: model.reportData?.weakestFactor?.name,
          expected: 'Mobile Development Execution',
        ),
      ]);
    });

    test('fromJson with null report_data', () {
      final model = LastReviewCycleReportModel.fromJson({
        'id': 1,
        'name': 'Test',
      });
      expect(model.reportData, isNull);
    });
  });

  group('EmployeeLearningDetailsModel', () {
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

      expect(item.scoreLabel, equals('(4.50/5.0)'));
    });

    test('default maxScore is 5', () {
      final item = CompetencyItem(name: 'Test', score: 3.0);

      expect(item.maxScore, equals(5));
    });
  });

  group('ReviewCycleItem', () {
    test('constructor stores all fields', () {
      final date = DateTime(2024, 12, 11);
      final item = ReviewCycleItem(
        id: 1,
        name: 'Senior Developer',
        startDate: date,
        closedDate: '2025-06-01',
        isLearningAssignmentSent: true,
      );

      expectModelFields([
        (key: 'id', actual: item.id, expected: 1),
        (key: 'name', actual: item.name, expected: 'Senior Developer'),
        (
          key: 'isLearningAssignmentSent',
          actual: item.isLearningAssignmentSent,
          expected: true,
        ),
      ]);
      expect(item.startDate, equals(date));
    });

    test('fromApiModel maps fields correctly', () {
      final apiModel = ReviewCycleItemModel(
        id: 8,
        name: 'Senior Mobile Developer 2025-06-18',
        startDate: '2025-06-18',
        closedDate: '2026-03-29',
        isLearningAssignmentSent: 1,
        report: ReviewCycleReportModel(finalScore: 3.89),
      );

      final item = ReviewCycleItem.fromApiModel(apiModel);

      expect(item.id, 8);
      expect(item.name, 'Senior Mobile Developer 2025-06-18');
      expect(item.startDate, DateTime(2025, 6, 18));
      expect(item.isLearningAssignmentSent, isTrue);
    });

    test('fromApiModel handles null report', () {
      final apiModel = ReviewCycleItemModel(
        id: 145,
        name: 'Test',
        isLearningAssignmentSent: false,
      );

      final item = ReviewCycleItem.fromApiModel(apiModel);
      expect(item.isLearningAssignmentSent, isFalse);
    });
  });
}
