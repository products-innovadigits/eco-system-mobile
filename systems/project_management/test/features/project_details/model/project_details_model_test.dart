import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/project_details/model/project_details_model.dart';

import '../../../helpers/fixture_reader.dart';
import '../../../helpers/json_fixtures.dart';
import '../../../helpers/model_field_asserts.dart';

void main() {
  group('ProjectDetailsModel', () {
    test('fromJson parses minimal valid JSON without throwing', () {
      final json = JsonFixtures.minimalMap();
      expect(() => ProjectDetailsModel.fromJson(json), returnsNormally);
    });

    test('fromJson returns correct type', () {
      final json = JsonFixtures.minimalMap();
      final res = ProjectDetailsModel.fromJson(json);
      expect(res, isA<ProjectDetailsModel>());
    });

    test('toJson returns Map without throwing', () {
      final model = ProjectDetailsModel();
      final json = model.toJson();
      expect(json, isA<Map<String, dynamic>>());
    });

    test('round-trip does not throw', () {
      final json = JsonFixtures.minimalMap();
      final m = ProjectDetailsModel.fromJson(json);
      expect(() => m.toJson(), returnsNormally);
    });

    test('fromJson correctly maps critical fields from fixture (fails if model key changes)', () {
      final fixture = readJsonFixture('project_details/project_details_response.json');
      final data = fixture['data'] as Map<String, dynamic>;
      final model = ProjectDetailsModel.fromJson(data);
      expectModelFields([
        (key: 'id', actual: model.id, expected: 101),
        (key: 'title', actual: model.title, expected: 'Eco-System Mobile Expansion'),
        (key: 'weight', actual: model.weight, expected: 1.0),
        (key: 'progressRation -> progressRatio', actual: model.progressRatio, expected: 0.65),
        (key: 'budget', actual: model.budget, expected: 500000),
        (key: 'riskLevelName', actual: model.riskLevelName, expected: 'Low'),
        (key: 'projectCategoryId', actual: model.projectCategoryId, expected: 1),
      ]);
      expect(model.description, isNotNull, reason: 'Key "description"');
    });
  });
}
