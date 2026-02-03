import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/project_details/model/project_details_model.dart';
import '../../../helpers/json_fixtures.dart';

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
  });
}
