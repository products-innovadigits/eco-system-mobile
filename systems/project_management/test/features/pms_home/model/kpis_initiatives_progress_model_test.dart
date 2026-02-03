import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/pms_home/model/kpis_initiatives_progress_model.dart';
import '../../../helpers/json_fixtures.dart';

void main() {
  group('KpisInitiativesProgressModel', () {
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
