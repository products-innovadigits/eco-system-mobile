import 'package:mocktail/mocktail.dart';
import 'package:project_management/core/utility/pms_exports.dart';

void initMocktailFallbacks() {
  registerFallbackValue(SearchEngine());
  registerFallbackValue(ChartTime.monthly);
  registerFallbackValue(ActiveSystemEnum.pms);
  registerFallbackValue(ServerMethods.GET);
  // Add other complex types as needed
}
