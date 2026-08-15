import 'package:core_system/core/modules/system_module.dart';
import 'package:project_management/core/module/project_management_module.dart';
import 'package:strategy_system/strategy_module.dart';

/// GENERATED FILE - DO NOT EDIT MANUALLY
/// Demo instance: Project Management + Strategy only. Both are served by the
/// same backend, so one login covers both and the in-app switcher moves between
/// them without re-authenticating.
///
/// Order matters — the first entry is the system a fresh session signs in to
/// (see `ActiveSystem.signedInTo`).

List<SystemModule> buildEnabledModules() {
  return [
    // AtsModule(),
    ProjectManagementModule(),
    StrategyModule(),
    // PmsModule(),
  ];
}
