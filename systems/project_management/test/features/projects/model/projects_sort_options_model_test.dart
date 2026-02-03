import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/projects/model/projects_sort_options_model.dart';

import '../../../helpers/json_fixtures.dart';

void main() {
  group('ProjectsFiltersModel (sort options)', () {
    test('fromJson parses valid list data without throwing', () {
      final json = JsonFixtures.wrapperResponse(
        data: [
          {'name': 'Name A', 'id': 1},
        ],
      );

      expect(json, isNotEmpty, reason: 'Test setup error: fixture JSON is empty');
      expect(json.containsKey('data'), isTrue, reason: 'Fixture JSON missing "data" key');
      
      expect(() => ProjectsFiltersModel().fromJson(json), returnsNormally,
          reason: 'ProjectsFiltersModel.fromJson failed to parse valid list data');
    });

    test('fromJson maps data into List<ProjectSortModel>', () {
      final json = JsonFixtures.wrapperResponse(
        data: [
          {'name': 'Name A', 'id': 1},
          {'name': 'Name B', 'id': 2},
        ],
      );

      final result = ProjectsFiltersModel().fromJson(json);
      expect(result, isNotNull, reason: 'fromJson returned null for valid sort options wrapper');
      expect(result, isA<ProjectsFiltersModel>(), reason: 'Result should be ProjectsFiltersModel');
      
      final model = result as ProjectsFiltersModel;

      expect(model.data, isNotNull, reason: 'model.data should not be null after parsing list');
      expect(model.data, isA<List<ProjectSortModel>>(), 
          reason: 'model.data should be List<ProjectSortModel>, got ${model.data.runtimeType}');
      
      final dataList = model.data!;
      expect(dataList.length, equals(2), reason: 'Expected 2 items in data list, found ${dataList.length}');
      
      expect(dataList.first.name, equals('Name A'), reason: 'First item name mismatch');
      expect(dataList.first.id, equals(1), reason: 'First item id mismatch');
    });

    test('toJson returns Map and includes data list when present', () {
      final model = ProjectsFiltersModel(
        succeeded: true,
        data: [ProjectSortModel(name: 'X', id: 10)],
      );

      final json = model.toJson();

      expect(json, isA<Map<String, dynamic>>(), reason: 'toJson must return a Map<String, dynamic>');
      expect(
        json.containsKey('succeeded'),
        isTrue,
        reason: 'toJson output missing "succeeded" key. Keys: ${json.keys.toList()} json: $json',
      );

      expect(
        json.containsKey('data'),
        isTrue,
        reason: 'toJson output missing "data" key. Keys: ${json.keys.toList()} json: $json',
      );

      final data = json['data'];
      expect(
        data,
        isA<List<dynamic>>(),
        reason: 'Expected json["data"] to be a List, got ${data.runtimeType}. json: $json',
      );

      expect(
        (data as List).isNotEmpty,
        isTrue,
        reason: 'Expected serialized data list to be non-empty. json: $json',
      );
    });

    test('round-trip: fromJson -> toJson does not throw and keeps list shape', () {
        final input = JsonFixtures.wrapperResponse(
          data: [
            {'name': 'Name A', 'id': 1},
          ],
        );

        final result = ProjectsFiltersModel().fromJson(input);
        expect(result, isA<ProjectsFiltersModel>(), reason: 'Initial fromJson failed');
        final model = result as ProjectsFiltersModel;

        expect(() => model.toJson(), returnsNormally, reason: 'toJson failed after fromJson parse');

        final out = model.toJson();
        expect(
          out['data'],
          isA<List<dynamic>>(),
          reason: 'Round-trip lost List shape in output json["data"]. json: $out',
        );
      },
    );
  });
}
