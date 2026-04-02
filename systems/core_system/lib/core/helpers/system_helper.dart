import 'package:core_system/core/utility/export.dart';

class SystemHelper {
  // System display names
  static const Map<ActiveSystemEnum, String> systemNames = {
    ActiveSystemEnum.projectManagement: 'نظام إدارة المشاريع',
    ActiveSystemEnum.strategy: 'نظام الأداء الاستراتيجي',
    ActiveSystemEnum.ats: 'نظام إدارة الموظفين',
    ActiveSystemEnum.pms: 'نظام PMS',
  };

  /// Hive value for [CachingKey.chosenSystemModuleId] when default view is combined home.
  static const String allSystemsUiModuleId = '__all_systems_ui__';

  /// [ActiveSystemEnum] → [SystemModule.id] for persistence.
  static String moduleIdForActiveSystem(ActiveSystemEnum system) {
    if (system == ActiveSystemEnum.pms) return 'pms_system';
    if (system == ActiveSystemEnum.ats) return 'ats_system';
    if (system == ActiveSystemEnum.strategy) return 'strategy_system';
    if (system == ActiveSystemEnum.projectManagement) {
      return 'project_management';
    }
    return system.value;
  }

  /// Get the display name for a system
  static String getSystemName(ActiveSystemEnum? system) {
    if (system == null) {
      return allTranslations.text(LocaleKeys.all_systems);
    }
    return systemNames[system] ?? system.value;
  }

  /// Get available systems (excluding current system)
  static List<Map<String, dynamic>> getAvailableSystems(
    ActiveSystemEnum? currentSystem,
  ) {
    final options = <Map<String, dynamic>>[
      {'name': allTranslations.text(LocaleKeys.all_systems), 'enum': null},
    ];

    // Add active systems, excluding current system
    for (final system in UserBloc.activeSystems) {
      if (system != currentSystem) {
        options.add({'name': getSystemName(system), 'enum': system});
      }
    }

    return options;
  }

  /// Show switcher when the user has more than one allowed system (login customize or all-enabled with 2+ modules).
  static bool shouldShowSystemWidget() {
    return UserBloc.activeSystems.length > 1;
  }

  /// Handle system selection
  static void handleSystemSelection(ActiveSystemEnum? systemEnum) {
    UserBloc.currentActiveSystem = systemEnum;

    if (systemEnum == null) {
      // Navigate to main page when "all" is selected
      CustomNavigator.push(Routes.MAIN_PAGE);
    } else {
      // Navigate to specific system
      CustomNavigator.push(Routes.SYSTEM_SWITCHER, arguments: systemEnum);
    }
  }
}
