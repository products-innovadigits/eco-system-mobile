import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/projects/model/projects_filters_model.dart';

import '../../../helpers/json_fixtures.dart';

void main() {
  group('ProjectsFiltersModel', () {
    test('fromJson parses minimal valid JSON without throwing', () {
      final json = JsonFixtures.wrapperResponse(data: {});

      expect(
        json,
        isNotEmpty,
        reason: 'Test setup error: fixture JSON should not be empty',
      );
      expect(
        json.containsKey('data'),
        isTrue,
        reason: 'Fixture JSON must contain "data" key for parsing',
      );

      expect(
        () => ProjectsFiltersModel().fromJson(json),
        returnsNormally,
        reason:
            'ProjectsFiltersModel.fromJson failed to parse a simple empty-data wrapper',
      );
    });

    test('fromJson returns correct type', () {
      final json = JsonFixtures.wrapperResponse(data: {});
      final res = ProjectsFiltersModel().fromJson(json);

      expect(
        res,
        isNotNull,
        reason: 'fromJson returned null for a valid wrapper',
      );
      expect(
        res,
        isA<ProjectsFiltersModel>(),
        reason:
            'fromJson should return an instance of ProjectsFiltersModel, got ${res.runtimeType}',
      );
    });

    test('toJson returns Map without throwing', () {
      final model = ProjectsFiltersModel();
      final json = model.toJson();

      expect(
        json,
        isA<Map<String, dynamic>>(),
        reason:
            'toJson must return a Map<String, dynamic>, got ${json.runtimeType}',
      );
    });

    test('round-trip does not throw', () {
      final json = JsonFixtures.wrapperResponse(data: {});
      final result = ProjectsFiltersModel().fromJson(json);

      expect(
        result,
        isA<ProjectsFiltersModel>(),
        reason: 'Initial parse failed',
      );
      final m = result as ProjectsFiltersModel;

      expect(
        () => m.toJson(),
        returnsNormally,
        reason: 'toJson failed on a model newly created from fromJson',
      );
    });

    test('Contract: fromJson accepts wrapper with "succeeded" and "data" keys', () {
      final json = JsonFixtures.wrapperResponse(data: {});

      expect(
        json.containsKey('succeeded'),
        isTrue,
        reason:
            'API Contract: Input JSON must have "succeeded" key. Keys found: ${json.keys.toList()}',
      );
      expect(
        json.containsKey('data'),
        isTrue,
        reason:
            'API Contract: Input JSON must have "data" key. Keys found: ${json.keys.toList()}',
      );

      expect(
        () => ProjectsFiltersModel().fromJson(json),
        returnsNormally,
        reason:
            'Model failed to parse even though required keys "succeeded" and "data" were present',
      );
    });
  });

  group('ProjectsFiltersData', () {
    test('fromJson parses minimal valid JSON without throwing', () {
      final json = JsonFixtures.minimalMap();

      expect(
        json,
        isNotNull,
        reason: 'Test setup error: minimalMap fixture is null',
      );
      expect(
        () => ProjectsFiltersData.fromJson(json),
        returnsNormally,
        reason: 'ProjectsFiltersData.fromJson failed on minimal map',
      );
    });

    test('fromJson returns correct type', () {
      final json = JsonFixtures.minimalMap();
      final res = ProjectsFiltersData.fromJson(json);

      expect(
        res,
        isNotNull,
        reason: 'fromJson returned null for ProjectsFiltersData',
      );
      expect(
        res,
        isA<ProjectsFiltersData>(),
        reason:
            'ProjectsFiltersData.fromJson should return ProjectsFiltersData, got ${res.runtimeType}',
      );
    });

    test('toJson returns Map without throwing', () {
      final model = ProjectsFiltersData();
      final json = model.toJson();

      expect(
        json,
        isA<Map<String, dynamic>>(),
        reason: 'ProjectsFiltersData.toJson must return a Map',
      );
    });

    test('round-trip does not throw', () {
      final json = JsonFixtures.minimalMap();
      final m = ProjectsFiltersData.fromJson(json);

      expect(
        () => m.toJson(),
        returnsNormally,
        reason: 'toJson failed after parsing for ProjectsFiltersData',
      );
    });
  });
}
