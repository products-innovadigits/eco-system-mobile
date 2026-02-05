import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/project_categories_progress/model/project_categories_progress_model.dart';

import '../../../helpers/contract_asserts.dart';
import '../../../helpers/fixture_reader.dart';
import '../../../helpers/json_fixtures.dart';

void main() {
  group('ProjectCategoriesProgressModel', () {
    test('Contract: fromJson accepts wrapper with "succeeded" and "data" keys (List)', () {
      final fixtureJson =
          readJsonFixture('project_categories_progress/project_categories_progress_response.json');
      expectWrapperContract(fixtureJson, dataShape: DataShape.list);
    });

    test('Contract: fixture data items contain required API keys', () {
      final fixtureJson =
          readJsonFixture('project_categories_progress/project_categories_progress_response.json');
      expectWrapperContract(fixtureJson, dataShape: DataShape.list);
      final dataList = fixtureJson['data'] as List;
      expect(dataList, isNotEmpty);
      final firstItem = dataList.first as Map<String, dynamic>;
      expect(firstItem.containsKey('id'), isTrue,
          reason: 'API contract: item must have "id". Keys: ${firstItem.keys.toList()}');
      expect(firstItem.containsKey('name'), isTrue,
          reason: 'API contract: item must have "name". Keys: ${firstItem.keys.toList()}');
      expect(firstItem.containsKey('progress'), isTrue,
          reason: 'API contract: item must have "progress". Keys: ${firstItem.keys.toList()}');
      expect(firstItem.containsKey('color'), isTrue,
          reason: 'API contract: item must have "color". Keys: ${firstItem.keys.toList()}');
      expect(firstItem['id'], 1);
      expect(firstItem['name'], 'Category A');
    });

    test('fromJson parses minimal valid JSON without throwing', () {
      final json = JsonFixtures.minimalMap();
      expect(() => ProjectCategoriesProgressModel().fromJson(json), returnsNormally);
    });

    test('fromJson returns correct type', () {
      final json = JsonFixtures.minimalMap();
      final res = ProjectCategoriesProgressModel().fromJson(json);
      expect(res, isA<ProjectCategoriesProgressModel>());
    });

    test('toJson returns Map without throwing', () {
      final model = ProjectCategoriesProgressModel();
      final json = model.toJson();
      expect(json, isA<Map<String, dynamic>>());
    });

    test('round-trip does not throw', () {
      final json = JsonFixtures.minimalMap();
      final m = ProjectCategoriesProgressModel().fromJson(json) as ProjectCategoriesProgressModel;
      expect(() => m.toJson(), returnsNormally);
    });
  });
}
