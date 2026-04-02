import 'package:core_system/core/bloc/theme_cubit.dart';
import 'package:core_system/core/config/app_config.dart';
import 'package:core_system/core/helpers/permissions.dart';
import 'package:core_system/core/utility/export.dart';
import 'package:eco_system/app/modules/modules_registry.dart';

class SplashBloc extends Bloc<AppEvent, AppState> {
  SplashBloc() : super(Start()) {
    on<Click>(onClick);
  }

  Future<void> getActiveSystem(SharedHelper helper) async {
    final raw = await helper.readString(CachingKey.allowedSystemModuleIds);
    final enabledIds =
        ModulesRegistry.enabledModules.map((m) => m.id).toSet();

    if (raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is List && decoded.isNotEmpty) {
          final filtered = decoded
              .map((e) => '$e')
              .where(enabledIds.contains)
              .toList();
          if (filtered.isNotEmpty) {
            UserBloc.activeSystems = filtered
                .map(ActiveSystemEnum.fromModuleId)
                .toList();
            return;
          }
        }
      } catch (_) {}
    }

    UserBloc.activeSystems =
        ModulesRegistry.enabledModules.map((m) => m.system).toList();
  }

  Future<void> getColorScheme() async {
    ThemeCubit.instance.applyModel(ColorSchemeModel());
  }

  Future<void> onClick(Click event, Emitter<AppState> emit) async {
    await getColorScheme();
    Future.delayed(const Duration(milliseconds: 3000), () async {
      PermissionHandler.checkNotificationsPermission();

      SharedHelper helper = SharedHelper();
      bool? isLogin = await helper.readBoolean(CachingKey.isLogin);
      bool? skip = await helper.readBoolean(CachingKey.skipBoarding);

      await getActiveSystem(helper);

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

  Future<void> _restoreChosenSystem(SharedHelper helper) async {
    final moduleId = await helper.readString(CachingKey.chosenSystemModuleId);
    if (moduleId.isEmpty) {
      if (ModulesRegistry.enabledModules.isNotEmpty) {
        AppConfig.activeSystem = ModulesRegistry.enabledModules.first.system;
        UserBloc.currentActiveSystem =
            UserBloc.activeSystems.length > 1 ? null : AppConfig.activeSystem;
      }
      return;
    }

    if (moduleId == SystemHelper.allSystemsUiModuleId) {
      if (UserBloc.activeSystems.isNotEmpty) {
        AppConfig.activeSystem = UserBloc.activeSystems.first;
      } else if (ModulesRegistry.enabledModules.isNotEmpty) {
        AppConfig.activeSystem = ModulesRegistry.enabledModules.first.system;
      }
      UserBloc.currentActiveSystem = null;
      return;
    }

    AppConfig.activeSystem = ActiveSystemEnum.fromModuleId(moduleId);
    UserBloc.currentActiveSystem = AppConfig.activeSystem;
  }
}
