import 'package:ats_system/ats_module.dart';
import 'package:core_system/core/modules/system_module.dart';
import 'package:pms_system/core/module/pms_module.dart';
import 'package:project_management/core/module/project_management_module.dart';
import 'package:strategy_system/strategy_module.dart';

/// Enabled system modules for the app shell (login multi-select, home, routes).

List<SystemModule> buildEnabledModules() {
  return [
    ProjectManagementModule(),
    PmsModule(),
    AtsModule(),
    StrategyModule(),
  ];
}
