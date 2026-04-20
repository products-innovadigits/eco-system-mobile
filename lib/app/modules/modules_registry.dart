import 'package:core_system/core/config/providers.dart';
import 'package:core_system/core/modules/home_section.dart';
import 'package:core_system/core/modules/system_module.dart';
import 'package:core_system/core/utility/export.dart';
import 'package:eco_system/app/modules/generated/enabled_modules.dart' as gen;
import 'package:flutter/foundation.dart';

class ModulesRegistry {
  /// Login-only id when Strategy and Project Management are shown as one dropdown row.
  /// Persists to [CachingKey.chosenSystemModuleId]; maps to PM auth via [ActiveSystemEnum.fromModuleId].
  static const String combinedStrategyProjectManagementId =
      'strategy_pm_combined';

  /// List of enabled system modules.
  /// This list is now provided by a generated file to ensure
  /// compile-time modularity and zero shell imports of feature systems.
  static List<SystemModule> get enabledModules => gen.buildEnabledModules();

  /// Localized label for a module row in the login system dropdown.
  static String localizedLoginModuleName(String moduleId) {
    switch (moduleId) {
      case 'strategy_system':
        return allTranslations.text(LocaleKeys.login_dropdown_strategy_system);
      case 'project_management':
        return allTranslations.text(LocaleKeys.login_dropdown_project_management);
      case 'ats_system':
        return allTranslations.text(LocaleKeys.login_dropdown_ats_system);
      case 'pms_system':
        return allTranslations.text(LocaleKeys.login_dropdown_pms_system);
      default:
        return getModuleById(moduleId)?.name ?? moduleId;
    }
  }

  /// Dropdown rows for login: merges strategy + project management when both are enabled.
  static List<DropListModel> loginSystemDropList() {
    final modules = enabledModules;
    final hasStrategy =
        modules.any((m) => m.system == ActiveSystemEnum.strategy);
    final hasPm =
        modules.any((m) => m.system == ActiveSystemEnum.projectManagement);
    final mergePair = hasStrategy && hasPm;

    var pairMerged = false;
    final list = <DropListModel>[];
    var index = 0;

    for (final m in modules) {
      if (mergePair &&
          (m.system == ActiveSystemEnum.strategy ||
              m.system == ActiveSystemEnum.projectManagement)) {
        if (pairMerged) {
          continue;
        }
        pairMerged = true;
        index++;
        list.add(
          DropListModel(
            id: index,
            name: allTranslations.text(LocaleKeys.strategy_and_pm_system),
            key: combinedStrategyProjectManagementId,
          ),
        );
        continue;
      }
      index++;
      list.add(
        DropListModel(
          id: index,
          name: localizedLoginModuleName(m.id),
          key: m.id,
        ),
      );
    }
    return list;
  }

  /// Aggregated routes from all enabled modules.
  static Map<String, RouteFactory> get appRoutes {
    final Map<String, RouteFactory> routes = {};
    for (final module in enabledModules) {
      if (kDebugMode) {
        _assertNoDuplicateRoutes(routes, module.routes);
      }
      routes.addAll(module.routes);
    }
    return routes;
  }

  /// Aggregated and sorted home sections from all enabled modules.
  static List<HomeSection> get appSections {
    final List<HomeSection> sections = enabledModules
        .expand((m) => m.homeSections)
        .toList();

    if (kDebugMode) {
      _assertNoDuplicateSections(sections);
    }

    return sections..sort((a, b) => a.order.compareTo(b.order));
  }

  static void _assertNoDuplicateRoutes(
    Map<String, RouteFactory> currentRoutes,
    Map<String, RouteFactory> newRoutes,
  ) {
    for (final routeName in newRoutes.keys) {
      if (currentRoutes.containsKey(routeName)) {
        throw AssertionError(
          'Duplicate route detected: $routeName. '
          'Ensure route names are unique across all modules.',
        );
      }
    }
  }

  static void _assertNoDuplicateSections(List<HomeSection> sections) {
    final Set<String> ids = {};
    for (final section in sections) {
      if (!ids.add(section.id)) {
        throw AssertionError(
          'Duplicate home section ID detected: ${section.id}',
        );
      }
    }
  }

  /// Returns the layout route for a specific system.
  /// This performs a generic lookup from aggregated routes,
  /// ensuring the shell has zero knowledge of feature layout classes.
  static Route<dynamic>? getLayoutRoute(ActiveSystemEnum system) {
    String? routeName;
    if (system == ActiveSystemEnum.projectManagement) {
      routeName = Routes.PROJECT_MANAGEMENT_LAYOUT;
    } else if (system == ActiveSystemEnum.strategy) {
      routeName = Routes.STRATEGY_LAYOUT;
    } else if (system == ActiveSystemEnum.pms) {
      routeName = Routes.PMS_LAYOUT;
    }

    if (routeName != null) {
      final factory = appRoutes[routeName];
      // Lookup the factory and call it with name only;
      // feature modules are expected to handle default arguments for their layouts.
      return factory?.call(RouteSettings(name: routeName));
    }
    return null;
  }

  /// Composes all providers from core system and enabled feature modules.
  static List<BlocProvider> get appProviders {
    final List<BlocProvider> providers = [...ProviderList.providers];

    for (final module in enabledModules) {
      providers.addAll(module.providers);
    }

    if (kDebugMode) {
      _assertNoDuplicateProviders(providers);
    }

    return providers;
  }

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

  static SystemModule? getModuleById(String id) {
    try {
      return enabledModules.firstWhere((m) => m.id == id);
    } catch (e) {
      return null;
    }
  }

  static bool isModuleEnabled(String moduleId) {
    return enabledModules.any((m) => m.id == moduleId);
  }
}
