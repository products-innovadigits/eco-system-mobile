import 'package:ats_system/ats_module.dart';
import 'package:core_system/core/config/providers.dart';
import 'package:core_system/core/modules/system_module.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pms_system/core/module/pms_module.dart';
import 'package:strategy_system/strategy_module.dart';

class ModulesRegistry {
  /// List of enabled system modules.
  ///
  /// Modify this list to enable/disable modules. Only enabled modules'
  /// providers will be included in the app.
  static List<SystemModule> get enabledModules => [
    AtsModule(),
    PmsModule(),
    StrategyModule(),
    // Add more modules here as needed
  ];

  /// Composes all providers from core system and enabled feature modules.
  ///
  /// Returns a flat list of all BlocProvider widgets that should be wrapped
  /// in MultiBlocProvider at the app root.
  static List<BlocProvider> get appProviders {
    // Start with core providers (always required)
    final List<BlocProvider> providers = [...ProviderList.providers];

    // Add providers from each enabled module
    for (final module in enabledModules) {
      providers.addAll(module.providers);
    }

    // Safety check: detect duplicate providers in debug mode
    if (kDebugMode) {
      _assertNoDuplicateProviders(providers);
    }

    return providers;
  }

  /// Debug assertion to detect duplicate provider types.
  ///
  /// Throws an assertion error if multiple providers of the same type are found.
  /// This helps catch configuration errors early.
  ///
  /// Note: This checks provider runtime types. For generic BlocProvider<T>,
  /// this will catch providers with the same T type.
  static void _assertNoDuplicateProviders(List<BlocProvider> providers) {
    final Map<String, int> typeCounts = <String, int>{};

    for (final provider in providers) {
      final typeName = provider.runtimeType.toString();
      typeCounts[typeName] = (typeCounts[typeName] ?? 0) + 1;
    }

    final duplicates = typeCounts.entries
        .where((e) => e.value > 1)
        .map((e) => '${e.key} (${e.value} times)')
        .toList();

    if (duplicates.isNotEmpty) {
      throw AssertionError(
        'Duplicate providers detected:\n${duplicates.join("\n")}\n\n'
        'Each Bloc/Cubit type should only have one provider. '
        'Check your module implementations for duplicate registrations.',
      );
    }
  }

  /// Get module by ID (useful for conditional logic based on enabled modules).
  static SystemModule? getModuleById(String id) {
    try {
      return enabledModules.firstWhere((m) => m.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Check if a module is enabled.
  static bool isModuleEnabled(String moduleId) {
    return enabledModules.any((m) => m.id == moduleId);
  }
}
