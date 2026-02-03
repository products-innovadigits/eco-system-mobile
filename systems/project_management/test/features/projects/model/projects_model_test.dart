import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/projects/model/projects_model.dart';
import '../../../helpers/fixture_reader.dart';
import '../../../helpers/contract_asserts.dart';
import '../../../helpers/json_fixtures.dart';

void main() {
  group('ProjectsModel', () {
    final fixtureJson = readJsonFixture('projects/projects_response.json');

    test('Contract: fromJson accepts wrapper with "succeeded" and "data" keys (Map)', () {
      expectWrapperContract(fixtureJson, dataShape: DataShape.map);
    });

    test('fromJson correctly maps critical fields from fixture', () {
      expect(fixtureJson, isNotNull, reason: 'Test setup: Projects fixture JSON is null');
      expectWrapperContract(fixtureJson, dataShape: DataShape.map);
      
      final model = ProjectsModel.fromJson(fixtureJson);
      
      expect(model.succeeded, isTrue, 
          reason: 'Expected "succeeded" to be true from fixture. Fix mapping or fixture.');
      
      final data = model.data;
      expect(data, isNotNull, 
          reason: 'Expected "data" model to be non-null after parsing valid fixture');
      
      final items = data?.items;
      expect(items, isNotNull, reason: 'Expected "items" list to be present in data');
      expect(items, isNotEmpty, reason: 'Expected "items" list to contain projects from fixture');
      
      final firstItem = items?.first;
      expect(firstItem?.title, equals('Project Alpha'), 
          reason: 'First project title mismatch. Expected "Project Alpha", got ${firstItem?.title}');
    });

    group('Negative Contract Tests', () {
      test('fails if "succeeded" key is missing', () {
        final invalidJson = Map<String, dynamic>.from(fixtureJson)..remove('succeeded');
        expect(() => expectWrapperContract(invalidJson, dataShape: DataShape.map), 
               throwsA(isA<TestFailure>()),
               reason: 'Contract helper should throw TestFailure when "succeeded" key is missing');
      });

      test('fails if "data" key is missing', () {
        final invalidJson = Map<String, dynamic>.from(fixtureJson)..remove('data');
        expect(() => expectWrapperContract(invalidJson, dataShape: DataShape.map), 
               throwsA(isA<TestFailure>()),
               reason: 'Contract helper should throw TestFailure when "data" key is missing');
      });

      test('fails if "data" is not a Map', () {
        final invalidJson = Map<String, dynamic>.from(fixtureJson)..['data'] = [];
        expect(() => expectWrapperContract(invalidJson, dataShape: DataShape.map), 
               throwsA(isA<TestFailure>()),
               reason: 'Contract helper should throw TestFailure when "data" is not a Map');
      });
    });

    test('toJson returns Map with essential fields', () {
      final model = ProjectsModel.fromJson(fixtureJson);
      final json = model.toJson();
      
      expect(json, isA<Map<String, dynamic>>(), reason: 'toJson must return a Map');
      expect(json['succeeded'], isTrue, reason: 'toJson missing or incorrect "succeeded" value');
      expect(json['data'], isNotNull, reason: 'toJson missing or null "data" value');
    });
  });

  group('ProjectsDataModel', () {
    test('fromJson parses minimal valid JSON without throwing', () {
      final json = JsonFixtures.minimalMap();
      expect(() => ProjectsDataModel.fromJson(json), returnsNormally,
          reason: 'ProjectsDataModel.fromJson failed on minimal map');
    });
  });
}
