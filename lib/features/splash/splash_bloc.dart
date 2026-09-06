import 'package:core_system/core/bloc/theme_cubit.dart';
import 'package:core_system/core/config/app_config.dart';
import 'package:core_system/core/helpers/permissions.dart';
import 'package:core_system/core/utility/export.dart';
import 'package:eco_system/app/modules/modules_registry.dart';

class SplashBloc extends Bloc<AppEvent, AppState> {
  SplashBloc() : super(Start()) {
    on<Click>(onClick);
  }

  /// Systems reachable in this session: the group unlocked by the system the
  /// user logged in with, limited to the modules compiled into this build.
  void getActiveSystem() {
    UserBloc.activeSystems = SystemHelper.resolveAccessibleSystems(
      AppConfig.activeSystem,
      ModulesRegistry.enabledModules.map((m) => m.system).toList(),
    );
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

      if (isLogin) {
        await _restoreChosenSystem(helper);

        ///Get Selected Active System (depends on the restored login system)
        getActiveSystem();
        UserBloc.instance.add(Click());
      }

      if (!skip) {
        // CustomNavigator.push(Routes.INTRO, clean: true);
        CustomNavigator.push(Routes.LOGIN, clean: true);
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
      return;
    }
    if (ModulesRegistry.enabledModules.isNotEmpty) {
      AppConfig.activeSystem = ModulesRegistry.enabledModules.first.system;
    }
  }
}
