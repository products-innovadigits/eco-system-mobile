import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/project_report/model/report_objective_percentage_model.dart';

void main() {
  group('ReportObjectivePercentageModel', () {
    test('can be constructed with values', () {
      final model = ReportObjectivePercentageModel(
        categoryName: 'On Track',
        value: 75.5,
        count: 10,
      );

      expect(model.categoryName, 'On Track');
      expect(model.value, 75.5);
      expect(model.count, 10);
    });

    test('allows nullable fields', () {
      final model = ReportObjectivePercentageModel();

      expect(model.categoryName, isNull);
      expect(model.value, isNull);
      expect(model.count, isNull);
    });
  });
}

