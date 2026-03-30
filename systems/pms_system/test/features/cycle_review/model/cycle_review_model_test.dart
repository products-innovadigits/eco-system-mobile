import 'package:flutter_test/flutter_test.dart';
import 'package:pms_system/features/cycle_review/model/cycle_review_model.dart';

import '../../../helpers/contract_asserts.dart';
import '../../../helpers/fixture_reader.dart';
import '../../../helpers/json_fixtures.dart';
import '../../../helpers/model_field_asserts.dart';

void main() {
  group('CycleDetailModel', () {
    final fixtureJson = readJsonFixture(
      'cycle_review/cycle_review_response.json',
    );

    test(
      'Contract: fromJson accepts wrapper with "succeeded" and "data" keys (Map)',
      () {
        expectWrapperContract(fixtureJson, dataShape: DataShape.map);
      },
    );

    test('fromJson correctly maps critical fields from fixture', () {
      expectWrapperContract(fixtureJson, dataShape: DataShape.map);

      final model = CycleDetailModel.fromJson(fixtureJson);

      expect(
        model.succeeded,
        isTrue,
        reason: 'Expected "succeeded" to be true from fixture',
      );

      final data = model.data;
      expect(
        data,
        isNotNull,
        reason: 'Expected "data" to be non-null after parsing valid fixture',
      );

      expectModelFields([
        (key: 'data.id', actual: data?.id, expected: 1),
        (key: 'data.title', actual: data?.title, expected: 'Bi-Annual Review'),
        (key: 'data.status', actual: data?.status, expected: 'Active'),
        (
          key: 'data.overallProgress',
          actual: data?.overallProgress,
          expected: 60.0,
        ),
        (key: 'data.completedCount', actual: data?.completedCount, expected: 6),
        (key: 'data.totalCount', actual: data?.totalCount, expected: 10),
        (key: 'data.totalScore', actual: data?.totalScore, expected: 87.0),
        (
          key: 'data.revieweesCount',
          actual: data?.revieweesCount,
          expected: 13,
        ),
      ]);
    });

    test('fromJson parses nested reviewees and roleGroups', () {
      final model = CycleDetailModel.fromJson(fixtureJson);
      final data = model.data;

      expect(data?.reviewees, isNotNull, reason: 'Expected reviewees list');
      expect(
        data?.reviewees,
        isNotEmpty,
        reason: 'Expected non-empty reviewees',
      );

      final firstReviewee = data?.reviewees?.first;
      expectModelFields([
        (
          key: 'reviewees[0].name',
          actual: firstReviewee?.name,
          expected: 'Mohamed Khaled',
        ),
        (
          key: 'reviewees[0].jobTitle',
          actual: firstReviewee?.jobTitle,
          expected: 'Senior Product Designer',
        ),
      ]);

      expect(
        firstReviewee?.reviews,
        isNotNull,
        reason: 'Expected reviews on first reviewee',
      );
      expect(firstReviewee?.reviews?.first.type, equals('Manager Review'));

      expect(data?.roleGroups, isNotNull, reason: 'Expected roleGroups list');
      expect(
        data?.roleGroups,
        isNotEmpty,
        reason: 'Expected non-empty roleGroups',
      );
      expectModelFields([
        (
          key: 'roleGroups[0].role',
          actual: data?.roleGroups?.first.role,
          expected: 'Managers',
        ),
        (
          key: 'roleGroups[0].count',
          actual: data?.roleGroups?.first.count,
          expected: 3,
        ),
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
      expect(
        json['succeeded'],
        isTrue,
        reason: 'toJson missing or incorrect "succeeded" value',
      );
      expect(
        json['data'],
        isNotNull,
        reason: 'toJson missing or null "data" value',
      );
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
        (
          key: 'completedReviews',
          actual: output['completedReviews'],
          expected: 2,
        ),
        (
          key: 'overallPercentage',
          actual: output['overallPercentage'],
          expected: 50.0,
        ),
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

  // --- New API model tests ---

  group('CycleSummaryResponseModel', () {
    final fixtureJson = readJsonFixture(
      'cycle_review/cycle_summary_response.json',
    );

    test('fromJson correctly parses summary response', () {
      final model = CycleSummaryResponseModel.fromJson(fixtureJson);

      expect(model.status, equals(200));
      expect(model.message, equals('Fetched Successfully'));
      expect(model.data, isNotNull);
    });

    test('data fields are correctly mapped', () {
      final model = CycleSummaryResponseModel.fromJson(fixtureJson);
      final data = model.data!;

      expectModelFields([
        (key: 'id', actual: data.id, expected: 171),
        (
          key: 'name',
          actual: data.name,
          expected: '2 reviewers 2026-03-30 ----> 2',
        ),
        (key: 'state', actual: data.state, expected: 'canceled'),
        (key: 'overallProgress', actual: data.overallProgress, expected: 50),
        (key: 'completedCount', actual: data.completedCount, expected: 1),
        (key: 'totalCount', actual: data.totalCount, expected: 2),
        (key: 'reviewersCount', actual: data.reviewersCount, expected: 2),
      ]);
    });

    test('role group sub-models are parsed', () {
      final model = CycleSummaryResponseModel.fromJson(fixtureJson);
      final data = model.data!;

      expect(data.managers, isNotNull);
      expect(data.managers?.count, equals(2));
      expect(data.managers?.deadline, equals(5));
      expect(data.managers?.deadlineDate, equals('2026-04-04'));

      expect(data.directReports, isNotNull);
      expect(data.directReports?.count, equals(0));

      expect(data.peers, isNotNull);
      expect(data.peers?.count, equals(0));
    });

    test('toCycleDetailDataModel maps correctly', () {
      final model = CycleSummaryResponseModel.fromJson(fixtureJson);
      final detail = model.data!.toCycleDetailDataModel();

      expectModelFields([
        (key: 'id', actual: detail.id, expected: 171),
        (key: 'title', actual: detail.title, expected: model.data!.name),
        (key: 'status', actual: detail.status, expected: 'canceled'),
        (
          key: 'overallProgress',
          actual: detail.overallProgress,
          expected: 50.0,
        ),
        (key: 'completedCount', actual: detail.completedCount, expected: 1),
        (key: 'totalCount', actual: detail.totalCount, expected: 2),
        (key: 'revieweesCount', actual: detail.revieweesCount, expected: 2),
      ]);

      expect(detail.roleGroups, isNotNull);
      expect(detail.roleGroups!.length, equals(1),
          reason: 'Only managers has count > 0');
      expect(detail.roleGroups!.first.role, equals('Managers'));
      expect(detail.roleGroups!.first.count, equals(2));
    });

    test('toJson returns Map with essential fields', () {
      final model = CycleSummaryResponseModel.fromJson(fixtureJson);
      final json = model.toJson();

      expect(json['status'], equals(200));
      expect(json['message'], equals('Fetched Successfully'));
      expect(json['data'], isNotNull);
    });

    test('fromJson round-trip via Mapper interface', () {
      final model = CycleSummaryResponseModel();
      final parsed = model.fromJson(fixtureJson);

      expect(parsed, isA<CycleSummaryResponseModel>());
      expect((parsed as CycleSummaryResponseModel).status, equals(200));
    });

    test('fromJson handles null data gracefully', () {
      final json = {'status': 200, 'message': 'OK', 'data': null};
      final model = CycleSummaryResponseModel.fromJson(json);

      expect(model.data, isNull);
    });
  });

  group('RoleGroupInfoModel', () {
    test('fromJson/toJson round-trip', () {
      final json = {
        'count': 3,
        'deadline': 5,
        'deadline_date': '2026-04-04',
      };
      final model = RoleGroupInfoModel.fromJson(json);
      final output = model.toJson();

      expectModelFields([
        (key: 'count', actual: output['count'], expected: 3),
        (key: 'deadline', actual: output['deadline'], expected: 5),
        (
          key: 'deadline_date',
          actual: output['deadline_date'],
          expected: '2026-04-04',
        ),
      ]);
    });
  });

  group('RevieweeStatusResponseModel', () {
    final fixtureJson = readJsonFixture(
      'cycle_review/reviewee_status_response.json',
    );

    test('fromJson correctly parses paginated list', () {
      final model = RevieweeStatusResponseModel.fromJson(fixtureJson);

      expect(model.data, isNotNull);
      expect(model.data!.length, equals(2));
      expect(model.currentPage, equals(1));
      expect(model.lastPage, equals(1));
      expect(model.total, equals(2));
      expect(model.perPage, equals(10));
    });

    test('first item fields are correctly mapped', () {
      final model = RevieweeStatusResponseModel.fromJson(fixtureJson);
      final item = model.data!.first;

      expectModelFields([
        (key: 'id', actual: item.id, expected: 12),
        (key: 'name', actual: item.name, expected: 'Nhyd Basha'),
        (
          key: 'jobTitle',
          actual: item.jobTitle,
          expected: 'Full stack developer',
        ),
        (key: 'overallProgress', actual: item.overallProgress, expected: 50),
        (key: 'completedCount', actual: item.completedCount, expected: 1),
        (key: 'totalCount', actual: item.totalCount, expected: 2),
      ]);

      expect(item.types, isNotNull);
      expect(item.types!.length, equals(1));
      expect(item.types!.first.name, equals('Manager Review'));
    });

    test('nested reviewers are parsed with all fields', () {
      final model = RevieweeStatusResponseModel.fromJson(fixtureJson);
      final reviewer = model.data!.first.types!.first.reviewers!.first;

      expectModelFields([
        (key: 'id', actual: reviewer.id, expected: 4),
        (key: 'name', actual: reviewer.name, expected: 'Shm Mdny'),
        (key: 'status', actual: reviewer.status, expected: 'completed'),
        (key: 'overdue', actual: reviewer.overdue, expected: false),
        (key: 'teams', actual: reviewer.teams, expected: 'Development'),
      ]);
    });

    test('toCycleRevieweeModel maps correctly', () {
      final model = RevieweeStatusResponseModel.fromJson(fixtureJson);
      final mapped = model.data!.first.toCycleRevieweeModel();

      expect(mapped, isA<CycleRevieweeModel>());
      expectModelFields([
        (key: 'id', actual: mapped.id, expected: 12),
        (key: 'name', actual: mapped.name, expected: 'Nhyd Basha'),
        (key: 'jobTitle', actual: mapped.jobTitle, expected: 'Full stack developer'),
        (key: 'completedReviews', actual: mapped.completedReviews, expected: 1),
        (key: 'totalReviews', actual: mapped.totalReviews, expected: 2),
        (key: 'overallPercentage', actual: mapped.overallPercentage, expected: 50.0),
      ]);

      expect(mapped.reviews, isNotNull);
      expect(mapped.reviews!.first.type, equals('Manager Review'));
    });

    test('reviewer status mapping handles overdue flag', () {
      final model = RevieweeStatusResponseModel.fromJson(fixtureJson);
      final reviewers = model.data!.first.types!.first.reviewers!;

      final completedReviewer = reviewers[0].toCycleReviewerInfoModel();
      expect(completedReviewer.status, equals('Completed'));

      final overdueReviewer = reviewers[1].toCycleReviewerInfoModel();
      expect(overdueReviewer.status, equals('Overdue'));
    });

    test('toJson returns Map with essential fields', () {
      final model = RevieweeStatusResponseModel.fromJson(fixtureJson);
      final json = model.toJson();

      expect(json['data'], isA<List>());
      expect(json['current_page'], equals(1));
      expect(json['total'], equals(2));
    });

    test('fromJson round-trip via Mapper interface', () {
      final model = RevieweeStatusResponseModel();
      final parsed = model.fromJson(fixtureJson);

      expect(parsed, isA<RevieweeStatusResponseModel>());
      expect(
        (parsed as RevieweeStatusResponseModel).data?.length,
        equals(2),
      );
    });

    test('fromJson handles empty data list', () {
      final json = {
        'data': [],
        'current_page': 1,
        'last_page': 1,
        'total': 0,
        'per_page': 10,
      };
      final model = RevieweeStatusResponseModel.fromJson(json);

      expect(model.data, isNotNull);
      expect(model.data, isEmpty);
    });
  });
}
