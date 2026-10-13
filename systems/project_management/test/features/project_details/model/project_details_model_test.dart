import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/project_details/model/project_details_model.dart';

import '../../../helpers/fixture_reader.dart';
import '../../../helpers/json_fixtures.dart';
import '../../../helpers/model_field_asserts.dart';

void main() {
  group('ProjectDetailsModel (wrapper)', () {
    test('fromJson parses wrapper with succeeded and data', () {
      final fixture = readJsonFixture('project_details/project_details_response.json');
      final model = ProjectDetailsModel.fromJson(fixture);
      expect(model, isA<ProjectDetailsModel>());
      expect(model.succeeded, isTrue, reason: 'Key "succeeded"');
      expect(model.data, isNotNull, reason: 'Key "data"');
    });

    test('toJson returns Map without throwing', () {
      final model = ProjectDetailsModel();
      final json = model.toJson();
      expect(json, isA<Map<String, dynamic>>());
    });

    test('round-trip does not throw', () {
      final fixture = readJsonFixture('project_details/project_details_response.json');
      final m = ProjectDetailsModel.fromJson(fixture);
      expect(() => m.toJson(), returnsNormally);
    });
  });

  group('ProjectDetailsDataModel', () {
    test('fromJson parses minimal valid JSON without throwing', () {
      final json = JsonFixtures.minimalMap();
      expect(() => ProjectDetailsDataModel.fromJson(json), returnsNormally);
    });

    test('fromJson returns correct type', () {
      final json = JsonFixtures.minimalMap();
      final res = ProjectDetailsDataModel.fromJson(json);
      expect(res, isA<ProjectDetailsDataModel>());
    });

    test('toJson returns Map without throwing', () {
      final model = ProjectDetailsDataModel();
      final json = model.toJson();
      expect(json, isA<Map<String, dynamic>>());
    });

    test('round-trip does not throw', () {
      final json = JsonFixtures.minimalMap();
      final m = ProjectDetailsDataModel.fromJson(json);
      expect(() => m.toJson(), returnsNormally);
    });

    test('fromJson correctly maps critical fields from fixture (fails if model key changes)', () {
      final fixture = readJsonFixture('project_details/project_details_response.json');
      final data = fixture['data'] as Map<String, dynamic>;
      final model = ProjectDetailsDataModel.fromJson(data);
      expectModelFields([
        (key: 'id', actual: model.id, expected: 101),
        (key: 'title', actual: model.title, expected: 'Eco-System Mobile Expansion'),
        (key: 'weight', actual: model.weight, expected: 1.0),
        (key: 'progressRation -> progressRatio', actual: model.progressRatio, expected: 0.65),
        (key: 'budget', actual: model.budget, expected: 500000),
        (key: 'riskLevelName', actual: model.riskLevelName, expected: 'Low'),
        (key: 'projectCategoryId', actual: model.projectCategoryId, expected: 1),
      ]);
      expect(model.description, isNotNull, reason: 'Key "description"');
    });

    test('fromJson maps mobileDetails.workflow groups and string step statuses', () {
      final fixture = readJsonFixture('project_details/project_details_response.json');
      final data = fixture['data'] as Map<String, dynamic>;
      final workflow = ProjectDetailsDataModel.fromJson(data).mobileDetails?.workflow;
      expect(workflow, isNotNull, reason: 'Key "mobileDetails.workflow"');
      final groups = workflow!.groups!;
      expectModelFields([
        (key: 'workflow.groupsCount', actual: workflow.groupsCount, expected: 2),
        (key: 'workflow.groups.length', actual: groups.length, expected: 2),
        (key: 'groups[0].groupName', actual: groups[0].groupName, expected: 'Onboarding'),
        (key: 'groups[1].progress', actual: groups[1].progress, expected: 50.0),
        (key: 'groups[0].steps[0].status', actual: groups[0].steps!.first.status, expected: 'None'),
        (key: 'groups[1].steps[0].status', actual: groups[1].steps!.first.status, expected: 'Completed'),
      ]);
    });
  });

  group('MobileWorkflowStepModel', () {
    test('fromJson keeps a numeric status as text instead of throwing', () {
      final step = MobileWorkflowStepModel.fromJson({'id': 1, 'stepName': 'A', 'status': 2});
      expect(step.status, '2');
    });

    test('fromJson leaves a missing status null', () {
      final step = MobileWorkflowStepModel.fromJson({'id': 1, 'stepName': 'A'});
      expect(step.status, isNull);
    });
  });
}
