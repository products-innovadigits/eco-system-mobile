import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/project_categories_progress/model/projects_progress_model.dart';

import '../../../helpers/fixture_reader.dart';
import '../../../helpers/json_fixtures.dart';
import '../../../helpers/model_field_asserts.dart';

void main() {
  group('ProjectsOverviewModel', () {
    test('fromJson correctly maps critical fields from fixture (fails if model key changes)', () {
      final fixtureJson =
          readJsonFixture('project_categories_progress/projects_overview_response.json');
      final model = ProjectsOverviewModel.fromJson(fixtureJson);
      expect(model.succeeded, isTrue, reason: 'Key "succeeded"');
      expect(model.data, isNotNull, reason: 'Key "data"');
      expect(model.data, isNotEmpty, reason: 'Key "data"');
      expectModelFields([
        (key: 'data[].name', actual: model.data!.first.name, expected: 'On Track'),
        (key: 'data[].hexColor', actual: model.data!.first.hexColor, expected: '#4CAF50'),
        (key: 'data[].percentage', actual: model.data!.first.percentage, expected: 60),
        (key: 'data[].count', actual: model.data!.first.count, expected: 12),
      ]);
    });

    test('fromJson parses minimal valid JSON without throwing', () {
      final json = JsonFixtures.wrapperResponse(data: []);
      expect(() => ProjectsOverviewModel.fromJson(json), returnsNormally);
    });

    test('fromJson returns correct type', () {
      final json = JsonFixtures.wrapperResponse(data: []);
      final res = ProjectsOverviewModel.fromJson(json);
      expect(res, isA<ProjectsOverviewModel>());
    });

    test('toJson returns Map without throwing', () {
      final model = ProjectsOverviewModel();
      final json = model.toJson();
      expect(json, isA<Map<String, dynamic>>());
    });

    test('round-trip does not throw', () {
      final json = JsonFixtures.wrapperResponse(data: []);
      final m = ProjectsOverviewModel.fromJson(json);
      expect(() => m.toJson(), returnsNormally);
    });

    test(
      'Contract: fromJson accepts wrapper with "succeeded" and "data" keys',
      () {
        final json = JsonFixtures.wrapperResponse(data: []);
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
        expect(() => ProjectsOverviewModel.fromJson(json), returnsNormally);
      },
    );
  });

  group('ProjectsOverviewData', () {
    test('fromJson parses minimal valid JSON without throwing', () {
      final json = JsonFixtures.minimalMap();
      expect(() => ProjectsOverviewData.fromJson(json), returnsNormally);
    });

    test('fromJson returns correct type', () {
      final json = JsonFixtures.minimalMap();
      final res = ProjectsOverviewData.fromJson(json);
      expect(res, isA<ProjectsOverviewData>());
    });

    test('toJson returns Map without throwing', () {
      final model = ProjectsOverviewData();
      final json = model.toJson();
      expect(json, isA<Map<String, dynamic>>());
    });

    test('round-trip does not throw', () {
      final json = JsonFixtures.minimalMap();
      final m = ProjectsOverviewData.fromJson(json);
      expect(() => m.toJson(), returnsNormally);
    });
  });
}
