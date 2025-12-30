import 'package:core_system/core/modules/system_module.dart';
import 'package:core_system/core/utility/export.dart'; // BlocProvider
import 'package:pms_system/features/latest_request/bloc/filtration/latest_request_filtration_cubit.dart';
import 'package:pms_system/features/projects/bloc/filtration/projects_filtration_bloc.dart';

/// PMS System module implementation.
///
/// Registers all Bloc providers required by the PMS (Project Management System) module.
class PmsModule implements SystemModule {
  @override
  String get id => 'pms_system';

  @override
  String get name => 'PMS System';

  @override
  List<BlocProvider> get providers => [
    // Projects Filtration Bloc - used for filtering projects
    BlocProvider<ProjectsFiltrationBloc>(
      create: (_) => ProjectsFiltrationBloc(),
    ),
    // Latest Request Filtration Cubit - used for filtering requests
    BlocProvider<LatestRequestFiltrationCubit>(
      create: (_) => LatestRequestFiltrationCubit(),
    ),
  ];
}
