import 'package:flutter_test/flutter_test.dart';
import 'package:pms_package/project_details/model/project_details_model.dart';

void main() {
  group('ProjectDetailsModel.fromJson', () {
    test('uses name when title is missing and parses dates', () {
      final json = {
        'id': 1,
        'name': 'Alpha',
        'description': 'desc',
        'startDate': '2024-01-01',
        'endDate': '2024-06-30'
      };

      final model = ProjectDetailsModel.fromJson(json);

      expect(model.id, 1);
      expect(model.title, 'Alpha');
      expect(model.startDate, DateTime.parse('2024-01-01'));
      expect(model.endDate, DateTime.parse('2024-06-30'));
    });
  });

  group('ProjectStagesModel.fromJson', () {
    test('parses progress as double from string', () {
      final json = {
        'id': 1,
        'name': 'Stage',
        'progress': '75'
      };

      final stage = ProjectStagesModel.fromJson(json);

      expect(stage.id, 1);
      expect(stage.title, 'Stage');
      expect(stage.progress, 75.0);
    });
  });
}