import 'package:flutter_test/flutter_test.dart';
import 'package:pms_system/features/cycle_reports/model/cycle_reports_model.dart';

import '../../../helpers/fixture_reader.dart';
import '../../../helpers/model_field_asserts.dart';

void main() {
  group('CycleReportItemModel', () {
    final fixtureJson =
        readJsonFixture('cycle_reports/cycle_reports_response.json');

    test('fromJson correctly maps fields from fixture items', () {
      final items = fixtureJson['items'] as List<dynamic>;
      expect(items, isNotEmpty,
          reason: 'Fixture should contain at least one report item');

      final first =
          CycleReportItemModel.fromJson(items.first as Map<String, dynamic>);
      expectModelFields([
        (key: 'id', actual: first.id, expected: 1),
        (key: 'name', actual: first.name, expected: 'Hassan Aziz'),
        (
          key: 'jobTitle',
          actual: first.jobTitle,
          expected: 'Senior Product Designer'
        ),
      ]);
    });

    test('fromJson handles missing optional fields with defaults', () {
      final model = CycleReportItemModel.fromJson(<String, dynamic>{});

      expect(model.id, equals(0),
          reason: 'id should default to 0 when missing');
      expect(model.name, equals(''),
          reason: 'name should default to empty string when missing');
      expect(model.jobTitle, equals(''),
          reason: 'jobTitle should default to empty string when missing');
      expect(model.imageUrl, isNull,
          reason: 'imageUrl should be null when missing');
    });

    test('toJson returns Map with all fields', () {
      final model = CycleReportItemModel(
        id: 5,
        name: 'Test User',
        jobTitle: 'Engineer',
        imageUrl: 'http://img.png',
      );
      final json = model.toJson();

      expect(json, isA<Map<String, dynamic>>());
      expectModelFields([
        (key: 'id', actual: json['id'], expected: 5),
        (key: 'name', actual: json['name'], expected: 'Test User'),
        (key: 'jobTitle', actual: json['jobTitle'], expected: 'Engineer'),
        (key: 'imageUrl', actual: json['imageUrl'], expected: 'http://img.png'),
      ]);
    });

    test('fromJson/toJson round-trip preserves data', () {
      final original = {
        'id': 3,
        'name': 'Round Trip',
        'jobTitle': 'Tester',
        'imageUrl': null,
      };
      final model = CycleReportItemModel.fromJson(original);
      final output = model.toJson();

      expectModelFields([
        (key: 'id', actual: output['id'], expected: 3),
        (key: 'name', actual: output['name'], expected: 'Round Trip'),
        (key: 'jobTitle', actual: output['jobTitle'], expected: 'Tester'),
      ]);
    });
  });
}
