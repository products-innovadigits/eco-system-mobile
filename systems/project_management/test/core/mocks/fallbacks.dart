import 'package:mocktail/mocktail.dart';
import 'package:project_management/core/utility/project_management_exports.dart';

void initMocktailFallbacks() {
  registerFallbackValue(SearchEngine());
  registerFallbackValue(ChartTime.monthly);
  registerFallbackValue(ActiveSystemEnum.projectManagement);
  registerFallbackValue(ServerMethods.GET);
  // Add other complex types as needed
}
