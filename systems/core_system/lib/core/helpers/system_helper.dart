import 'package:core_system/core/utility/export.dart';

class SystemHelper {
  // System display names
  static const Map<ActiveSystemEnum, String> systemNames = {
    ActiveSystemEnum.projectManagement: 'نظام إدارة المشاريع',
    ActiveSystemEnum.strategy: 'نظام الأداء الاستراتيجي',
    ActiveSystemEnum.ats: 'نظام إدارة الموظفين',
    ActiveSystemEnum.pms: 'نظام PMS',
  };

  static const String allSystemsName = 'كل الانظمة';

  /// Systems unlocked by each login system, keyed by [ActiveSystemEnum.value].
  ///
  /// A login grants access to its own system plus the sibling systems that
  /// share the same account, e.g. logging in with Project Management also
  /// unlocks Strategy. PMS authenticates against its own backend, so it
  /// stands alone.
  static const Map<String, List<ActiveSystemEnum>> _loginSystemGroups = {
    'project_management': [
      ActiveSystemEnum.projectManagement,
      ActiveSystemEnum.strategy,
    ],
    'strategy': [ActiveSystemEnum.strategy, ActiveSystemEnum.projectManagement],
    'pms': [ActiveSystemEnum.pms],
    'ats': [ActiveSystemEnum.ats],
  };

  /// Systems reachable in the current session: the group unlocked by
  /// [loginSystem], intersected with the modules compiled into the build so a
  /// disabled module can never be offered.
  static List<ActiveSystemEnum> resolveAccessibleSystems(
    ActiveSystemEnum loginSystem,
    List<ActiveSystemEnum> compiledSystems,
  ) {
    final group = _loginSystemGroups[loginSystem.value] ?? [loginSystem];
    return group.where(compiledSystems.contains).toList();
  }

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
      // Include "all systems" unless it is already the current selection
      if (currentSystem != null) {'name': allSystemsName, 'enum': null},
    ];

    // Add active systems, excluding current system
    for (final system in UserBloc.activeSystems) {
      if (system != currentSystem) {
        options.add({'name': getSystemName(system), 'enum': system});
      }
    }

    return options;
  }

  /// Check if we should show the system selection widget.
  /// Only meaningful when the session can reach more than one system.
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
