import 'package:core_system/core/modules/home_section.dart';
import 'package:core_system/core/modules/system_module.dart';
import 'package:core_system/core/utility/export.dart'; // BlocProvider
import 'package:strategy_system/bsc/view/bsc_view.dart';
import 'package:strategy_system/objective_details/view/objective_details_view.dart';
import 'package:strategy_system/objective_percentage/view/objective_percentage_section.dart';
import 'package:strategy_system/objectives/bloc/objectives_filtration_bloc.dart';
import 'package:strategy_system/objectives/view/objectives_view.dart';
import 'package:strategy_system/okr/view/okr_view.dart';
import 'package:strategy_system/strategic_axes/view/strategic_axes_view.dart';
import 'package:strategy_system/strategy_layout.dart';

/// Strategy System module implementation.
/// 
/// Registers all Bloc providers required by the Strategy module.
class StrategyModule implements SystemModule {
  @override
  String get id => 'strategy_system';

  @override
  String get name =>
      allTranslations.text(LocaleKeys.strategic_performance_system);

  @override
  ActiveSystemEnum get system => ActiveSystemEnum.strategy;

  @override
  List<BlocProvider> get providers => [
    // Objectives Filtration Bloc - used for filtering objectives
    BlocProvider<ObjectivesFiltrationBloc>(
      create: (_) => ObjectivesFiltrationBloc(),
    ),
  ];

  @override
  Map<String, RouteFactory> get routes => {
    Routes.STRATEGY_LAYOUT: (settings) {
      final args = settings.arguments as StrategyLayoutArgs? ??
          const StrategyLayoutArgs(showSwitcher: true);
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => StrategyLayout(
          index: args.index,
          showSwitcher: args.showSwitcher,
        ),
      );
    },
    Routes.OBJECTIVES: (settings) => MaterialPageRoute(builder: (_) => const ObjectivesView()),
    Routes.BSC: (settings) => MaterialPageRoute(builder: (_) => const BscView()),
    Routes.OKR: (settings) => MaterialPageRoute(builder: (_) => const OkrView()),
    Routes.STRATEGIC_AXES: (settings) => MaterialPageRoute(builder: (_) => const StrategicAxesView()),
    Routes.OBJECTIVE_DETAILS: (settings) => MaterialPageRoute(
      builder: (_) => ObjectiveDetailsView(id: settings.arguments as int),
    ),
  };

  @override
  List<HomeSection> get homeSections => [
    HomeSection(
      id: 'objective_percentage',
      order: 10,
      builder: (context) {
        if (!ActiveSystem.showsContentFor(system)) {
          return const SizedBox.shrink();
        }
        return const ObjectivePercentageSection();
      },
    ),
  ];
}

