import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/project_management_home/model/kpis_initiatives_progress_model.dart';

import '../../../helpers/contract_asserts.dart';
import '../../../helpers/fixture_reader.dart';
import '../../../helpers/json_fixtures.dart';
import '../../../helpers/model_field_asserts.dart';

void main() {
  group('KpisInitiativesProgressModel', () {
    test('Contract: fromJson accepts wrapper with "succeeded" and "data" keys (List)', () {
      final fixtureJson =
          readJsonFixture('project_management_home/project_management_home_kpis_response.json');
      expectWrapperContract(fixtureJson, dataShape: DataShape.list);
    });

    test('fromJson correctly maps critical fields from fixture item (fails if model key changes)', () {
      final fixtureJson =
          readJsonFixture('project_management_home/project_management_home_kpis_response.json');
      expectWrapperContract(fixtureJson, dataShape: DataShape.list);
      final dataList = fixtureJson['data'] as List;
      expect(dataList, isNotEmpty);
      final firstItem = dataList.first as Map<String, dynamic>;
      expect(firstItem.containsKey('objectValue'), isTrue);
      expect(firstItem.containsKey('kpisValue'), isTrue);
      expect(firstItem.containsKey('initiativesValue'), isTrue);

      final model = KpisInitiativesProgressModel.fromJson(firstItem);
      expectModelFields([
        (key: 'objectValue -> objective', actual: model.objective, expected: 'Objective 1'),
        (key: 'kpisValue', actual: model.kpisValue, expected: 75.5),
        (key: 'initiativesValue', actual: model.initiativesValue, expected: 80.0),
      ]);
    });

    test('toJson returns Map with essential fields', () {
      final fixtureJson =
          readJsonFixture('project_management_home/project_management_home_kpis_response.json');
      final firstItem = (fixtureJson['data'] as List).first as Map<String, dynamic>;
      final model = KpisInitiativesProgressModel.fromJson(firstItem);
      final json = model.toJson();
      expect(json, isA<Map<String, dynamic>>());
      expect(json['objectValue'], 'Objective 1');
      expect(json['kpisValue'], 75.5);
      expect(json['initiativesValue'], 80.0);
    });

    test('fromJson parses minimal valid JSON without throwing', () {
      final json = JsonFixtures.minimalMap();
      expect(() => KpisInitiativesProgressModel().fromJson(json), returnsNormally);
    });

    test('fromJson returns correct type', () {
      final json = JsonFixtures.minimalMap();
      final res = KpisInitiativesProgressModel().fromJson(json);
      expect(res, isA<KpisInitiativesProgressModel>());
    });

    test('toJson returns Map without throwing', () {
      final model = KpisInitiativesProgressModel();
      final json = model.toJson();
      expect(json, isA<Map<String, dynamic>>());
    });

    test('round-trip does not throw', () {
      final json = JsonFixtures.minimalMap();
      final m = KpisInitiativesProgressModel().fromJson(json) as KpisInitiativesProgressModel;
      expect(() => m.toJson(), returnsNormally);
    });
  });
}
