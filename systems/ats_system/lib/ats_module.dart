import 'package:ats_system/bloc/ats_filtration_bloc.dart';
import 'package:ats_system/jobs/bloc/jobs_bloc.dart';
import 'package:core_system/core/modules/system_module.dart';
import 'package:core_system/core/model/search_engine.dart';
import 'package:core_system/core/utility/export.dart'; // BlocProvider, AppEvent/AppState

/// ATS System module implementation.
/// 
/// Registers all Bloc providers required by the ATS (Applicant Tracking System) module.
class AtsModule implements SystemModule {
  @override
  String get id => 'ats_system';

  @override
  String get name => 'ATS System';

  @override
  List<BlocProvider> get providers => [
    // Jobs Bloc - manages job listings and operations
    BlocProvider<JobsBloc>(
      create: (_) => JobsBloc()..add(Click(arguments: SearchEngine())),
    ),
    // ATS Filtration Bloc - used for filtering candidates/jobs
    BlocProvider<AtsFiltrationBloc>(
      create: (_) => AtsFiltrationBloc(),
    ),
  ];
}

