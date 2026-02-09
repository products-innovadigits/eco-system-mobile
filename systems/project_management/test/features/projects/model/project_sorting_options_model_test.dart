import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/projects/model/project_sorting_options_model.dart';

import '../../../helpers/contract_asserts.dart';
import '../../../helpers/fixture_reader.dart';
import '../../../helpers/json_fixtures.dart';
import '../../../helpers/model_field_asserts.dart';

void main() {
  group('ProjectSortingOptionsModel', () {
    test('Contract: fromJson accepts wrapper with "succeeded" and "data" keys (List)', () {
      final fixtureJson =
          readJsonFixture('projects/project_sorting_options_response.json');
      expectWrapperContract(fixtureJson, dataShape: DataShape.list);
    });

    test('Contract: fixture data items contain required API keys (id, nameAr, nameEn)', () {
      final fixtureJson =
          readJsonFixture('projects/project_sorting_options_response.json');
      expectWrapperContract(fixtureJson, dataShape: DataShape.list);
      final dataList = fixtureJson['data'] as List;
      expect(dataList, isNotEmpty);
      final firstItem = dataList.first as Map<String, dynamic>;
      expect(firstItem.containsKey('id'), isTrue,
          reason: 'API contract: sorting option item must have "id". Keys: ${firstItem.keys.toList()}');
      expect(firstItem.containsKey('nameAr'), isTrue,
          reason: 'API contract: sorting option item must have "nameAr". Keys: ${firstItem.keys.toList()}');
      expect(firstItem.containsKey('nameEn'), isTrue,
          reason: 'API contract: sorting option item must have "nameEn". Keys: ${firstItem.keys.toList()}');
      expect(firstItem['id'], 1);
      expect(firstItem['nameAr'], 'الأحدث');
      expect(firstItem['nameEn'], 'Newest');
    });

    test('fromJson correctly maps full fixture to model (fails if model key changes)', () {
      final fixtureJson =
          readJsonFixture('projects/project_sorting_options_response.json');
      final model = ProjectSortingOptionsModel.fromJson(fixtureJson);
      expect(model.succeeded, isTrue, reason: 'Key "succeeded"');
      expect(model.data, isNotNull, reason: 'Key "data"');
      expect(model.data, isNotEmpty, reason: 'Key "data"');
      expect(model.data!.length, 3, reason: 'Key "data" length');
      final first = model.data!.first;
      expectModelFields([
        (key: 'data[].id', actual: first.id, expected: 1),
        (key: 'data[].nameAr', actual: first.nameAr, expected: 'الأحدث'),
        (key: 'data[].nameEn', actual: first.nameEn, expected: 'Newest'),
      ]);
    });

    test('fails if required wrapper key is missing: fixture contract guards model', () {
      final fixtureJson =
          readJsonFixture('projects/project_sorting_options_response.json');
      final invalidJson = Map<String, dynamic>.from(fixtureJson)..remove('succeeded');
      expect(
        () => expectWrapperContract(invalidJson, dataShape: DataShape.list),
        throwsA(anything),
        reason: 'Contract test must fail when "succeeded" is removed from fixture',
      );
    });

    test('fails if required item key is missing: fixture contract guards item shape', () {
      final fixtureJson =
          readJsonFixture('projects/project_sorting_options_response.json');
      final dataList = List<Map<String, dynamic>>.from(
        (fixtureJson['data'] as List).map((e) => Map<String, dynamic>.from(e as Map)),
      );
      dataList.first.remove('nameAr');
      final invalidJson = Map<String, dynamic>.from(fixtureJson)..['data'] = dataList;
      final model = ProjectSortingOptionsModel.fromJson(invalidJson);
      expect(model.data, isNotEmpty);
      expect(model.data!.first.nameAr, isNull,
          reason: 'If fixture item misses "nameAr", model must reflect it; change fixture or model together');
    });

    test('fromJson parses minimal valid JSON without throwing', () {
      final json = JsonFixtures.wrapperResponse(data: <Map<String, dynamic>>[]);
      expect(() => ProjectSortingOptionsModel().fromJson(json), returnsNormally);
    });

    test('fromJson returns correct type', () {
      final json = JsonFixtures.wrapperResponse(data: <Map<String, dynamic>>[]);
      final res = ProjectSortingOptionsModel().fromJson(json);
      expect(res, isA<ProjectSortingOptionsModel>());
    });

    test('toJson returns Map without throwing', () {
      final model = ProjectSortingOptionsModel(succeeded: true, data: []);
      final out = model.toJson();
      expect(out, isA<Map<String, dynamic>>());
    });

    test('round-trip with fixture does not throw', () {
      final fixtureJson =
          readJsonFixture('projects/project_sorting_options_response.json');
      final model = ProjectSortingOptionsModel.fromJson(fixtureJson);
      expect(() => model.toJson(), returnsNormally);
    });
  });

  group('ProjectSortingOptionModel', () {
    test('fromJson parses item with id, nameAr, nameEn', () {
      final json = <String, dynamic>{'id': 1, 'nameAr': 'أ', 'nameEn': 'A'};
      final item = ProjectSortingOptionModel.fromJson(json);
      expect(item.id, 1);
      expect(item.nameAr, 'أ');
      expect(item.nameEn, 'A');
    });

    test('toJson round-trip preserves data', () {
      final item = ProjectSortingOptionModel(id: 2, nameAr: 'ب', nameEn: 'B');
      final json = item.toJson();
      expect(json['id'], 2);
      expect(json['nameAr'], 'ب');
      expect(json['nameEn'], 'B');
    });
  });
}
