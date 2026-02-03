import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/project_report/model/project_report_model.dart';
import '../../../helpers/json_fixtures.dart';

void main() {
  group('ProjectReportModel', () {
    test('fromJson parses minimal valid JSON without throwing', () {
      final json = JsonFixtures.wrapperResponse(data: {});
      expect(() => ProjectReportModel().fromJson(json), returnsNormally);
    });

    test('fromJson returns correct type', () {
      final json = JsonFixtures.wrapperResponse(data: {});
      final res = ProjectReportModel().fromJson(json);
      expect(res, isA<ProjectReportModel>());
    });

    test('toJson returns Map without throwing', () {
      final model = ProjectReportModel();
      final json = model.toJson();
      expect(json, isA<Map<String, dynamic>>());
    });

    test('round-trip does not throw', () {
      final json = JsonFixtures.wrapperResponse(data: {});
      final m = ProjectReportModel().fromJson(json) as ProjectReportModel;
      expect(() => m.toJson(), returnsNormally);
    });

    test('Contract: fromJson accepts wrapper with "succeeded" and "data" keys', () {
      final json = JsonFixtures.wrapperResponse(data: {});
      expect(json.containsKey('succeeded'), isTrue,
          reason: 'Contract expects input key "succeeded". Keys: ${json.keys.toList()}');
      expect(json.containsKey('data'), isTrue,
          reason: 'Contract expects input key "data". Keys: ${json.keys.toList()}');
      expect(() => ProjectReportModel().fromJson(json), returnsNormally);
    });
  });
}
