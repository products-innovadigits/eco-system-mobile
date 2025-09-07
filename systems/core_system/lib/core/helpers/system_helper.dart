import 'package:core_system/core/utility/export.dart';

class SystemHelper {
  // System display names
  static const Map<ActiveSystemEnum, String> systemNames = {
    ActiveSystemEnum.pms: 'نظام إدارة المشاريع',
    ActiveSystemEnum.strategy: 'نظام الأداء الاستراتيجي',
    ActiveSystemEnum.ats: 'نظام إدارة الموظفين',
  };

  static const String allSystemsName = 'كل الانظمة';

  /// Get the display name for a system
  static String getSystemName(ActiveSystemEnum? system) {
    if (system == null) return allSystemsName;
    return systemNames[system] ?? system.value;
  }

  /// Get available systems (excluding current system)
  static List<Map<String, dynamic>> getAvailableSystems(
    ActiveSystemEnum? currentSystem,
  ) {
    final options = <Map<String, dynamic>>[
      // Always include "all systems" option
      {'name': allSystemsName, 'enum': null},
    ];

    // Add active systems, excluding current system
    for (final system in UserBloc.activeSystems) {
      if (system != currentSystem) {
        options.add({'name': getSystemName(system), 'enum': system});
      }
    }

    return options;
  }

  /// Check if we should show the system selection widget
  static bool shouldShowSystemWidget() {
    return UserBloc.currentActiveSystem != null;
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

