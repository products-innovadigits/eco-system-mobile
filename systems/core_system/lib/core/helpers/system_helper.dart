import 'package:core_system/core/utility/export.dart';

/// One entry in the system switcher. `system == null` is the combined
/// "all systems" home.
class SystemOption {
  final ActiveSystemEnum? system;
  final String name;

  const SystemOption({required this.system, required this.name});
}

/// Navigation side of system switching. All state lives in [ActiveSystem].
class SystemHelper {
  /// Display name for a system, or the "all systems" label for null.
  static String getSystemName(ActiveSystemEnum? system) =>
      ActiveSystem.nameOf(system);

  /// Switcher entries: the combined home first, then every enabled system
  /// except the one already being viewed.
  static List<SystemOption> getAvailableSystems([
    ActiveSystemEnum? currentSystem,
  ]) {
    final current = currentSystem ?? ActiveSystem.viewing;
    return [
      SystemOption(system: null, name: ActiveSystem.nameOf(null)),
      for (final system in ActiveSystem.available)
        if (system != current)
          SystemOption(system: system, name: ActiveSystem.nameOf(system)),
    ];
  }

  /// The switcher is only meaningful once a system has been chosen and there
  /// is more than one to choose between.
  static bool shouldShowSystemWidget() => ActiveSystem.available.length > 1;

  /// The single entry point for moving between systems: records the choice,
  /// then routes to that system's layout (or the combined home for null).
  static void goToSystem(ActiveSystemEnum? system) {
    ActiveSystem.view(system);
    if (system == null) {
      CustomNavigator.push(Routes.MAIN_PAGE);
    } else {
      CustomNavigator.push(Routes.SYSTEM_SWITCHER, arguments: system);
    }
  }
}
