import 'package:mocktail/mocktail.dart';
import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/employees_learning/model/employees_learning_model.dart';

void initMocktailFallbacks() {
  registerFallbackValue(SearchEngine());
  registerFallbackValue(ServerMethods.GET);
  registerFallbackValue(ActiveSystemEnum.pms);
  registerFallbackValue(EmployeesLearningModel());
}
