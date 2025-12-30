import 'package:core_system/core/modules/system_module.dart';
import 'package:core_system/core/utility/export.dart'; // BlocProvider
import 'package:strategy_system/objectives/bloc/objectives_filtration_bloc.dart';

/// Strategy System module implementation.
/// 
/// Registers all Bloc providers required by the Strategy module.
class StrategyModule implements SystemModule {
  @override
  String get id => 'strategy_system';

  @override
  String get name => 'Strategy System';

  @override
  List<BlocProvider> get providers => [
    // Objectives Filtration Bloc - used for filtering objectives
    BlocProvider<ObjectivesFiltrationBloc>(
      create: (_) => ObjectivesFiltrationBloc(),
    ),
  ];
}

