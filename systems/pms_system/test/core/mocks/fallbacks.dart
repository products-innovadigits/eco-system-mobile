import 'package:mocktail/mocktail.dart';
import 'package:pms_system/core/utility/pms_exports.dart';

void initMocktailFallbacks() {
  registerFallbackValue(SearchEngine());
  registerFallbackValue(ServerMethods.GET);
}
