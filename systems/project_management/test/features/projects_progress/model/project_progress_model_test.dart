import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/projects_progress/model/project_progress_model.dart';

import '../../../helpers/contract_asserts.dart';
import '../../../helpers/fixture_reader.dart';
import '../../../helpers/json_fixtures.dart';

void main() {
  group('ProjectProgressModel', () {
    test('Contract: fromJson accepts wrapper with "succeeded" and "data" keys (List)', () {
      final fixtureJson =
          readJsonFixture('projects_progress/projects_progress_response.json');
      expectWrapperContract(fixtureJson, dataShape: DataShape.list);
    });

    test('fromJson correctly maps critical fields from fixture item', () {
      final fixtureJson =
          readJsonFixture('projects_progress/projects_progress_response.json');
      expectWrapperContract(fixtureJson, dataShape: DataShape.list);
      final dataList = fixtureJson['data'] as List;
      expect(dataList, isNotEmpty);
      final firstItem = dataList.first as Map<String, dynamic>;
      expect(firstItem.containsKey('categoryName'), isTrue);
      expect(firstItem.containsKey('value'), isTrue);
      expect(firstItem.containsKey('count'), isTrue);
      expect(firstItem.containsKey('color'), isTrue);

      final model = ProjectProgressModel.fromJson(firstItem);
      expect(model.categoryName, 'Planning');
      expect(model.value, 90.5);
      expect(model.count, 5);
      expect(model.color, '#4CAF50');
    });

    test('toJson returns Map with essential fields', () {
      final fixtureJson =
          readJsonFixture('projects_progress/projects_progress_response.json');
      final firstItem = (fixtureJson['data'] as List).first as Map<String, dynamic>;
      final model = ProjectProgressModel.fromJson(firstItem);
      final json = model.toJson();
      expect(json, isA<Map<String, dynamic>>());
      expect(json['categoryName'], 'Planning');
      expect(json['value'], 90.5);
      expect(json['count'], 5);
      expect(json['color'], '#4CAF50');
    });

    test('fromJson parses minimal valid JSON without throwing', () {
      final json = JsonFixtures.minimalMap();
      expect(() => ProjectProgressModel().fromJson(json), returnsNormally);
    });

    test('fromJson returns correct type', () {
      final json = JsonFixtures.minimalMap();
      final res = ProjectProgressModel().fromJson(json);
      expect(res, isA<ProjectProgressModel>());
    });

    test('toJson returns Map without throwing', () {
      final model = ProjectProgressModel();
      final json = model.toJson();
      expect(json, isA<Map<String, dynamic>>());
    });

    test('round-trip does not throw', () {
      final json = JsonFixtures.minimalMap();
      final m = ProjectProgressModel().fromJson(json) as ProjectProgressModel;
      expect(() => m.toJson(), returnsNormally);
    });
  });
}
