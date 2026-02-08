import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/project_details/model/project_timeline_model.dart';

import '../../../helpers/json_fixtures.dart';

void main() {
  group('ProjectTimelineModel', () {
    test('fromJson parses minimal valid JSON without throwing', () {
      final json = JsonFixtures.minimalMap();
      expect(() => ProjectTimelineModel().fromJson(json), returnsNormally);
    });

    test('fromJson returns correct type', () {
      final json = JsonFixtures.minimalMap();
      final res = ProjectTimelineModel().fromJson(json);
      expect(res, isA<ProjectTimelineModel>());
    });

    test('toJson returns Map without throwing', () {
      final model = ProjectTimelineModel();
      final json = model.toJson();
      expect(json, isA<Map<String, dynamic>>());
    });

    test('round-trip does not throw', () {
      final json = JsonFixtures.minimalMap();
      final m = ProjectTimelineModel().fromJson(json) as ProjectTimelineModel;
      expect(() => m.toJson(), returnsNormally);
    });
  });

  group('MilestoneModel', () {
    test('fromJson parses minimal valid JSON without throwing', () {
      final json = JsonFixtures.minimalMap();
      expect(() => MilestoneModel.fromJson(json), returnsNormally);
    });

    test('fromJson returns correct type', () {
      final json = JsonFixtures.minimalMap();
      final res = MilestoneModel.fromJson(json);
      expect(res, isA<MilestoneModel>());
    });

    test('toJson returns Map without throwing', () {
      final model = MilestoneModel();
      final json = model.toJson();
      expect(json, isA<Map<String, dynamic>>());
    });

    test('round-trip does not throw', () {
      final json = JsonFixtures.minimalMap();
      final m = MilestoneModel.fromJson(json);
      expect(() => m.toJson(), returnsNormally);
    });
  });

  group('SubActivityModel', () {
    test('fromJson parses minimal valid JSON without throwing', () {
      final json = JsonFixtures.minimalMap();
      expect(() => SubActivityModel.fromJson(json), returnsNormally);
    });

    test('fromJson returns correct type', () {
      final json = JsonFixtures.minimalMap();
      final res = SubActivityModel.fromJson(json);
      expect(res, isA<SubActivityModel>());
    });

    test('toJson returns Map without throwing', () {
      final model = SubActivityModel();
      final json = model.toJson();
      expect(json, isA<Map<String, dynamic>>());
    });

    test('round-trip does not throw', () {
      final json = JsonFixtures.minimalMap();
      final m = SubActivityModel.fromJson(json);
      expect(() => m.toJson(), returnsNormally);
    });
  });
}
