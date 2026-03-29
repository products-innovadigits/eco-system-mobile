import 'package:core_system/core/bloc/theme_cubit.dart';
import 'package:core_system/core/config/app_config.dart';
import 'package:core_system/core/helpers/permissions.dart';
import 'package:core_system/core/utility/export.dart';
import 'package:eco_system/app/modules/modules_registry.dart';

class SplashBloc extends Bloc<AppEvent, AppState> {
  SplashBloc() : super(Start()) {
    on<Click>(onClick);
  }

  void getActiveSystem() async {
    /// Selected Systems derived from compile-time enabled modules (Single Source of Truth)
    UserBloc.activeSystems = ModulesRegistry.enabledModules
        .map((m) => m.system)
        .toList();
  }

  Future<void> getColorScheme() async {
    ThemeCubit.instance.applyModel(ColorSchemeModel());
  }

  Future<void> onClick(Click event, Emitter<AppState> emit) async {
    await getColorScheme();
    Future.delayed(const Duration(milliseconds: 3000), () async {
      ///Ask Notification Permission
      PermissionHandler.checkNotificationsPermission();

      ///Ask Location Permission
      // Geolocator.requestPermission();

      SharedHelper helper = SharedHelper();
      bool? isLogin = await helper.readBoolean(CachingKey.isLogin);
      bool? skip = await helper.readBoolean(CachingKey.skipBoarding);

      ///Get Selected Active System
      getActiveSystem();

      if (isLogin) {
        await _restoreChosenSystem(helper);
        UserBloc.instance.add(Click());
      }

      if (!skip) {
        CustomNavigator.push(Routes.INTRO, clean: true);
      } else if (!isLogin) {
        CustomNavigator.push(Routes.LOGIN, clean: true);
      } else {
        CustomNavigator.push(Routes.MAIN_PAGE, clean: true);
      }
    });
  }

  /// Restores [AppConfig.activeSystem] from Hive after cold start (login dropdown is in-memory only).
  Future<void> _restoreChosenSystem(SharedHelper helper) async {
    final moduleId = await helper.readString(CachingKey.chosenSystemModuleId);
    if (moduleId.isNotEmpty) {
      AppConfig.activeSystem = ActiveSystemEnum.fromModuleId(moduleId);
      UserBloc.currentActiveSystem = AppConfig.activeSystem;
      return;
    }
    if (ModulesRegistry.enabledModules.isNotEmpty) {
      AppConfig.activeSystem = ModulesRegistry.enabledModules.first.system;
      UserBloc.currentActiveSystem = AppConfig.activeSystem;
    }
  }
}
