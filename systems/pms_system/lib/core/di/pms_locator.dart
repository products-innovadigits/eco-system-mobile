import 'package:get_it/get_it.dart';
import 'package:pms_system/core/utility/pms_exports.dart';

final GetIt pmsSl = GetIt.asNewInstance();

void setupPmsLocator() {
  if (!pmsSl.isRegistered<Network>()) {
    pmsSl.registerLazySingleton<Network>(() => Network());
  }
}
