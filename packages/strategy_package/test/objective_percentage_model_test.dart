import 'package:flutter_test/flutter_test.dart';
import 'package:strategy_package/objective_percentage/model/objective_percentage_model.dart';

void main() {
  group('ObjectivePercentageModel', () {
    test('fromJson parses fields correctly', () {
      final model = ObjectivePercentageModel.fromJson(
        {'categoryName': 'Quality', 'value': 25.5},
      );

      expect(model.categoryName, 'Quality');
      expect(model.value, 25.5);
    });

    test('toJson outputs the same map', () {
      final model = ObjectivePercentageModel(
        categoryName: 'Speed',
        value: 90,
      );

      expect(model.toJson(), {'categoryName': 'Speed', 'value': 90});
    });
  });
}
