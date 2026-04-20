import 'package:core_system/core/config/app_config.dart';
import 'package:core_system/core/utility/export.dart';

class SystemHelper {
  /// Get the display name for a system (localized; matches login dropdown labels).
  static String getSystemName(ActiveSystemEnum? system) {
    if (system == null) {
      return allTranslations.text(LocaleKeys.all_systems);
    }
    if (system == ActiveSystemEnum.strategy) {
      return allTranslations.text(LocaleKeys.login_dropdown_strategy_system);
    }
    if (system == ActiveSystemEnum.projectManagement) {
      return allTranslations.text(LocaleKeys.login_dropdown_project_management);
    }
    if (system == ActiveSystemEnum.ats) {
      return allTranslations.text(LocaleKeys.login_dropdown_ats_system);
    }
    if (system == ActiveSystemEnum.pms) {
      return allTranslations.text(LocaleKeys.login_dropdown_pms_system);
    }
    return system.value;
  }

  /// Get available systems (excluding current system)
  static List<Map<String, dynamic>> getAvailableSystems(
    ActiveSystemEnum? currentSystem,
  ) {
    final options = <Map<String, dynamic>>[
      {'name': getSystemName(null), 'enum': null},
    ];

    final systemsToOffer = UserBloc.linkedStrategyPmLogin
        ? UserBloc.activeSystems
            .where(
              (s) =>
                  s == ActiveSystemEnum.strategy ||
                  s == ActiveSystemEnum.projectManagement,
            )
            .toList()
        : UserBloc.activeSystems;

    for (final system in systemsToOffer) {
      if (system != currentSystem) {
        options.add({'name': getSystemName(system), 'enum': system});
      }
    }

    return options;
  }

  /// Check if we should show the system selection widget
  static bool shouldShowSystemWidget() {
    return UserBloc.linkedStrategyPmLogin;
  }

  /// Handle system selection
  static void handleSystemSelection(ActiveSystemEnum? systemEnum) {
    UserBloc.currentActiveSystem = systemEnum;
    if (systemEnum != null) {
      AppConfig.activeSystem = systemEnum;
    } else if (UserBloc.linkedStrategyPmLogin) {
      AppConfig.activeSystem = ActiveSystemEnum.projectManagement;
    }

    if (systemEnum == null) {
      CustomNavigator.push(Routes.MAIN_PAGE);
    } else {
      CustomNavigator.push(Routes.SYSTEM_SWITCHER, arguments: systemEnum);
    }

    try {
      UserBloc.instance.add(Update());
    } catch (_) {}
  }
}
