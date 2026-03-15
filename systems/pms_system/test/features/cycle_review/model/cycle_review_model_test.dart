import 'package:flutter_test/flutter_test.dart';
import 'package:pms_system/features/cycle_review/model/cycle_review_model.dart';

import '../../../helpers/contract_asserts.dart';
import '../../../helpers/fixture_reader.dart';
import '../../../helpers/json_fixtures.dart';
import '../../../helpers/model_field_asserts.dart';

void main() {
  group('CycleDetailModel', () {
    final fixtureJson =
        readJsonFixture('cycle_review/cycle_review_response.json');

    test(
      'Contract: fromJson accepts wrapper with "succeeded" and "data" keys (Map)',
      () {
        expectWrapperContract(fixtureJson, dataShape: DataShape.map);
      },
    );

    test('fromJson correctly maps critical fields from fixture', () {
      expectWrapperContract(fixtureJson, dataShape: DataShape.map);

      final model = CycleDetailModel.fromJson(fixtureJson);

      expect(model.succeeded, isTrue,
          reason: 'Expected "succeeded" to be true from fixture');

      final data = model.data;
      expect(data, isNotNull,
          reason: 'Expected "data" to be non-null after parsing valid fixture');

      expectModelFields([
        (key: 'data.id', actual: data?.id, expected: 1),
        (
          key: 'data.title',
          actual: data?.title,
          expected: 'Bi-Annual Review'
        ),
        (key: 'data.status', actual: data?.status, expected: 'Active'),
        (
          key: 'data.overallProgress',
          actual: data?.overallProgress,
          expected: 60.0
        ),
        (key: 'data.completedCount', actual: data?.completedCount, expected: 6),
        (key: 'data.totalCount', actual: data?.totalCount, expected: 10),
        (key: 'data.totalScore', actual: data?.totalScore, expected: 87.0),
        (key: 'data.revieweesCount', actual: data?.revieweesCount, expected: 13),
      ]);
    });

    test('fromJson parses nested reviewees and roleGroups', () {
      final model = CycleDetailModel.fromJson(fixtureJson);
      final data = model.data;

      expect(data?.reviewees, isNotNull, reason: 'Expected reviewees list');
      expect(data?.reviewees, isNotEmpty, reason: 'Expected non-empty reviewees');

      final firstReviewee = data?.reviewees?.first;
      expectModelFields([
        (key: 'reviewees[0].name', actual: firstReviewee?.name, expected: 'Mohamed Khaled'),
        (key: 'reviewees[0].jobTitle', actual: firstReviewee?.jobTitle, expected: 'Senior Product Designer'),
      ]);

      expect(firstReviewee?.reviews, isNotNull,
          reason: 'Expected reviews on first reviewee');
      expect(firstReviewee?.reviews?.first.type, equals('Manager Review'));

      expect(data?.roleGroups, isNotNull, reason: 'Expected roleGroups list');
      expect(data?.roleGroups, isNotEmpty, reason: 'Expected non-empty roleGroups');
      expectModelFields([
        (key: 'roleGroups[0].role', actual: data?.roleGroups?.first.role, expected: 'Managers'),
        (key: 'roleGroups[0].count', actual: data?.roleGroups?.first.count, expected: 3),
      ]);
    });

    group('Negative Contract Tests', () {
      test('fails if "succeeded" key is missing', () {
        final invalidJson = Map<String, dynamic>.from(fixtureJson)
          ..remove('succeeded');
        expect(
          () => expectWrapperContract(invalidJson, dataShape: DataShape.map),
          throwsA(isA<TestFailure>()),
        );
      });

      test('fails if "data" key is missing', () {
        final invalidJson = Map<String, dynamic>.from(fixtureJson)
          ..remove('data');
        expect(
          () => expectWrapperContract(invalidJson, dataShape: DataShape.map),
          throwsA(isA<TestFailure>()),
        );
      });
    });

    test('toJson returns Map with essential fields', () {
      final model = CycleDetailModel.fromJson(fixtureJson);
      final json = model.toJson();

      expect(json, isA<Map<String, dynamic>>());
      expect(json['succeeded'], isTrue,
          reason: 'toJson missing or incorrect "succeeded" value');
      expect(json['data'], isNotNull,
          reason: 'toJson missing or null "data" value');
    });

    test('fromJson round-trip via Mapper interface', () {
      final model = CycleDetailModel();
      final parsed = model.fromJson(fixtureJson);

      expect(parsed, isA<CycleDetailModel>());
      expect((parsed as CycleDetailModel).succeeded, isTrue);
    });
  });

  group('CycleDetailDataModel', () {
    test('fromJson parses minimal valid JSON without throwing', () {
      expect(
        () => CycleDetailDataModel.fromJson(JsonFixtures.minimalMap()),
        returnsNormally,
      );
    });
  });

  group('CycleRevieweeModel', () {
    test('fromJson/toJson round-trip', () {
      final json = {
        'id': 1,
        'name': 'Test User',
        'jobTitle': 'Developer',
        'imageUrl': null,
        'completedReviews': 2,
        'totalReviews': 4,
        'overallPercentage': 50.0,
        'reviews': [],
      };
      final model = CycleRevieweeModel.fromJson(json);
      final output = model.toJson();

      expectModelFields([
        (key: 'id', actual: output['id'], expected: 1),
        (key: 'name', actual: output['name'], expected: 'Test User'),
        (key: 'completedReviews', actual: output['completedReviews'], expected: 2),
        (key: 'overallPercentage', actual: output['overallPercentage'], expected: 50.0),
      ]);
    });
  });

  group('CycleReviewTypeModel', () {
    test('fromJson parses minimal valid JSON without throwing', () {
      expect(
        () => CycleReviewTypeModel.fromJson(JsonFixtures.minimalMap()),
        returnsNormally,
      );
    });
  });

  group('CycleReviewerInfoModel', () {
    test('fromJson/toJson round-trip', () {
      final json = {
        'id': 10,
        'name': 'Reviewer',
        'imageUrl': null,
        'status': 'Completed',
      };
      final model = CycleReviewerInfoModel.fromJson(json);
      final output = model.toJson();

      expectModelFields([
        (key: 'id', actual: output['id'], expected: 10),
        (key: 'name', actual: output['name'], expected: 'Reviewer'),
        (key: 'status', actual: output['status'], expected: 'Completed'),
      ]);
    });
  });

  group('CycleRoleGroupModel', () {
    test('fromJson/toJson round-trip', () {
      final json = {
        'role': 'Managers',
        'count': 3,
        'dueDate': 'FEB 5, 2025',
        'isCompleted': false,
      };
      final model = CycleRoleGroupModel.fromJson(json);
      final output = model.toJson();

      expectModelFields([
        (key: 'role', actual: output['role'], expected: 'Managers'),
        (key: 'count', actual: output['count'], expected: 3),
        (key: 'isCompleted', actual: output['isCompleted'], expected: false),
      ]);
    });
  });
}
