import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/projects_progress/model/project_progress_model.dart';
import '../../../helpers/json_fixtures.dart';

void main() {
  group('ProjectProgressModel', () {
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
