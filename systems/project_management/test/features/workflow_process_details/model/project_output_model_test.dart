import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/workflow_process_details/widgets/project_outputs_chart.dart';

void main() {
  group('ProjectOutputModel', () {
    test('can be constructed with values', () {
      final model = ProjectOutputModel(
        type: ProjectOutputType.completed,
        titleKey: 'completed_outputs',
        count: 5,
      );

      expect(model.type, ProjectOutputType.completed);
      expect(model.titleKey, 'completed_outputs');
      expect(model.count, 5);
    });
  });
}

