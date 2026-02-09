import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/project_report/model/project_report_model.dart';

import '../../../helpers/fixture_reader.dart';
import '../../../helpers/json_fixtures.dart';
import '../../../helpers/model_field_asserts.dart';

void main() {
  group('ProjectReportModel', () {
    test('fromJson correctly maps critical fields from fixture (fails if model key changes)', () {
      final fixtureJson = readJsonFixture('project_report/project_report_response.json');
      final model = ProjectReportModel.fromJson(fixtureJson);
      expect(model.succeeded, isTrue, reason: 'Key "succeeded"');
      expect(model.data, isNotNull, reason: 'Key "data"');
      expectModelFields([
        (key: 'data.status', actual: model.data!.status, expected: 'In Progress'),
        (key: 'data.daysLeft', actual: model.data!.daysLeft, expected: 120),
        (key: 'data.details.projectName', actual: model.data!.details?.projectName, expected: 'Annual Tech Review'),
        (key: 'data.details.managerName', actual: model.data!.details?.managerName, expected: 'Jane Smith'),
        (key: 'data.budget[].key', actual: model.data!.budget?.first.key, expected: 'labor'),
        (key: 'data.budget[].amount', actual: model.data!.budget?.first.amount, expected: 150000),
      ]);
      expect(model.data!.budget, isNotNull, reason: 'Key "data.budget"');
      expect(model.data!.budget!.length, 2, reason: 'Key "data.budget" length');
    });

    test('fromJson parses minimal valid JSON without throwing', () {
      final json = JsonFixtures.wrapperResponse(data: {});
      expect(() => ProjectReportModel().fromJson(json), returnsNormally);
    });

    test('fromJson returns correct type', () {
      final json = JsonFixtures.wrapperResponse(data: {});
      final res = ProjectReportModel().fromJson(json);
      expect(res, isA<ProjectReportModel>());
    });

    test('toJson returns Map without throwing', () {
      final model = ProjectReportModel();
      final json = model.toJson();
      expect(json, isA<Map<String, dynamic>>());
    });

    test('round-trip does not throw', () {
      final json = JsonFixtures.wrapperResponse(data: {});
      final m = ProjectReportModel().fromJson(json) as ProjectReportModel;
      expect(() => m.toJson(), returnsNormally);
    });

    test(
      'Contract: fromJson accepts wrapper with "succeeded" and "data" keys',
      () {
        final json = JsonFixtures.wrapperResponse(data: {});
        expect(
          json.containsKey('succeeded'),
          isTrue,
          reason:
              'Contract expects input key "succeeded". Keys: ${json.keys.toList()}',
        );
        expect(
          json.containsKey('data'),
          isTrue,
          reason:
              'Contract expects input key "data". Keys: ${json.keys.toList()}',
        );
        expect(() => ProjectReportModel().fromJson(json), returnsNormally);
      },
    );
  });
}
