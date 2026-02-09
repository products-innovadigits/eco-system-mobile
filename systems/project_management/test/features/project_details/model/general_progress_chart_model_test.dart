import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/project_details/model/general_progress_chart_model.dart';

import '../../../helpers/fixture_reader.dart';
import '../../../helpers/json_fixtures.dart';
import '../../../helpers/model_field_asserts.dart';

void main() {
  group('GeneralProgressChartModel', () {
    final fixtureJson = readJsonFixture(
      'project_details/general_progress_chart_response.json',
    );

    test('Contract: fixture contains required API keys', () {
      expect(
        fixtureJson.containsKey('totalProgress'),
        isTrue,
        reason:
            'API contract: fixture must have "totalProgress". Keys: ${fixtureJson.keys.toList()}',
      );
      expect(
        fixtureJson.containsKey('currentMonth'),
        isTrue,
        reason:
            'API contract: fixture must have "currentMonth". Keys: ${fixtureJson.keys.toList()}',
      );
      expect(
        fixtureJson.containsKey('currentYear'),
        isTrue,
        reason:
            'API contract: fixture must have "currentYear". Keys: ${fixtureJson.keys.toList()}',
      );
      expect(
        fixtureJson.containsKey('monthProgress'),
        isTrue,
        reason:
            'API contract: fixture must have "monthProgress". Keys: ${fixtureJson.keys.toList()}',
      );
      expect(
        fixtureJson.containsKey('yearProgress'),
        isTrue,
        reason:
            'API contract: fixture must have "yearProgress". Keys: ${fixtureJson.keys.toList()}',
      );
    });

    test('fromJson correctly maps critical fields from fixture (fails if model key changes)', () {
      expect(fixtureJson, isNotNull,
          reason: 'Test setup: general progress chart fixture JSON is null');

      final model = GeneralProgressChartModel.fromJson(fixtureJson);

      expectModelFields([
        (key: 'totalProgress', actual: model.totalProgress, expected: 72.5),
        (key: 'currentMonth', actual: model.currentMonth, expected: 3),
        (key: 'currentYear', actual: model.currentYear, expected: 2025),
        (key: 'monthProgress[].month', actual: model.monthProgress?.first.month, expected: 1),
        (key: 'monthProgress[].year', actual: model.monthProgress?.first.year, expected: 2025),
        (key: 'monthProgress[].progress', actual: model.monthProgress?.first.progress, expected: 45.0),
        (key: 'yearProgress[].month', actual: model.yearProgress?.first.month, expected: 1),
        (key: 'yearProgress[].year', actual: model.yearProgress?.first.year, expected: 2025),
        (key: 'yearProgress[].progress', actual: model.yearProgress?.first.progress, expected: 72.5),
      ]);
      expect(model.monthProgress, isNotNull, reason: 'Key "monthProgress"');
      expect(model.monthProgress, isNotEmpty, reason: 'Key "monthProgress"');
      expect(model.yearProgress, isNotNull, reason: 'Key "yearProgress"');
      expect(model.yearProgress, isNotEmpty, reason: 'Key "yearProgress"');
    });

    group('Negative Contract Tests', () {
      test('fails if "totalProgress" key is missing from fixture shape', () {
        final invalidJson = Map<String, dynamic>.from(fixtureJson)
          ..remove('totalProgress');
        final model = GeneralProgressChartModel.fromJson(invalidJson);
        expect(model.totalProgress, isNull,
            reason:
                'When "totalProgress" is missing, model must have null. Key change may break API.');
      });

      test('fails if "monthProgress" item misses "progress" key', () {
        final invalidJson = Map<String, dynamic>.from(fixtureJson);
        (invalidJson['monthProgress'] as List)[0] = {
          'month': 1,
          'year': 2025,
        };
        final model = GeneralProgressChartModel.fromJson(invalidJson);
        expect(model.monthProgress!.first.progress, isNull);
      });
    });

    test('toJson returns Map with essential fields', () {
      final model = GeneralProgressChartModel.fromJson(fixtureJson);
      final json = model.toJson();

      expect(json, isA<Map<String, dynamic>>(),
          reason: 'toJson must return a Map');
      expect(json['totalProgress'], isNotNull);
      expect(json['currentMonth'], isNotNull);
      expect(json['currentYear'], isNotNull);
      expect(json['monthProgress'], isA<List>());
      expect(json['yearProgress'], isA<List>());
    });

    test('fromJson parses minimal valid JSON without throwing', () {
      final json = JsonFixtures.minimalMap();
      expect(
        () => GeneralProgressChartModel().fromJson(json),
        returnsNormally,
      );
    });

    test('fromJson returns correct type', () {
      final json = JsonFixtures.minimalMap();
      final res = GeneralProgressChartModel().fromJson(json);
      expect(res, isA<GeneralProgressChartModel>());
    });

    test('round-trip with fixture does not throw', () {
      final model = GeneralProgressChartModel.fromJson(fixtureJson);
      expect(() => model.toJson(), returnsNormally);
    });
  });

  group('ProgressItem', () {
    test('Contract: item shape has month, year, progress keys', () {
      final itemJson = <String, dynamic>{
        'month': 2,
        'year': 2025,
        'progress': 60.0,
      };
      expect(itemJson.containsKey('month'), isTrue);
      expect(itemJson.containsKey('year'), isTrue);
      expect(itemJson.containsKey('progress'), isTrue);
      final item = ProgressItem.fromJson(itemJson);
      expect(item.month, 2);
      expect(item.year, 2025);
      expect(item.progress, 60.0);
    });

    test('fromJson parses minimal valid JSON without throwing', () {
      final json = JsonFixtures.minimalMap();
      expect(() => ProgressItem.fromJson(json), returnsNormally);
    });

    test('fromJson returns correct type', () {
      final json = <String, dynamic>{
        'month': 3,
        'year': 2025,
        'progress': 90,
      };
      final res = ProgressItem.fromJson(json);
      expect(res, isA<ProgressItem>());
      expect(res.month, 3);
      expect(res.year, 2025);
      expect(res.progress, 90.0);
    });

    test('toJson returns Map without throwing', () {
      final model = ProgressItem(month: 4, year: 2025, progress: 50.0);
      final json = model.toJson();
      expect(json, isA<Map<String, dynamic>>());
      expect(json['month'], 4);
      expect(json['year'], 2025);
      expect(json['progress'], 50.0);
    });
  });
}
