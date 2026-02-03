import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/project_categories_progress/model/projects_progress_model.dart';
import '../../../helpers/json_fixtures.dart';

void main() {
  group('ProjectsOverviewModel', () {
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

    test('Contract: fromJson accepts wrapper with "succeeded" and "data" keys', () {
      final json = JsonFixtures.wrapperResponse(data: []);
      expect(json.containsKey('succeeded'), isTrue,
          reason: 'Contract expects input key "succeeded". Keys: ${json.keys.toList()}');
      expect(json.containsKey('data'), isTrue,
          reason: 'Contract expects input key "data". Keys: ${json.keys.toList()}');
      expect(() => ProjectsOverviewModel.fromJson(json), returnsNormally);
    });
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
