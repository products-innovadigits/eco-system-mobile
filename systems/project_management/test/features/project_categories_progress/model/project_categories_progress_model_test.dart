import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/project_categories_progress/model/project_categories_progress_model.dart';
import '../../../helpers/json_fixtures.dart';

void main() {
  group('ProjectCategoriesProgressModel', () {
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
