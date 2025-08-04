import 'package:ats_system/shared/ats_exports.dart';
import 'package:core_system/core/utility/export.dart';
import 'package:pms_system/projects/bloc/projects_filtration_bloc.dart';
import 'package:strategy_system/objectives/bloc/objectives_filtration_bloc.dart';

abstract class ProviderList {
  static List<BlocProvider> providers = [
    BlocProvider<UserBloc>(create: (_) => UserBloc()),
    BlocProvider<JobsBloc>(
      create: (_) => JobsBloc()..add(Click(arguments: SearchEngine())),
    ),
    BlocProvider<AtsFiltrationBloc>(create: (_) => AtsFiltrationBloc()),
    BlocProvider<ObjectivesFiltrationBloc>(
      create: (_) => ObjectivesFiltrationBloc(),
    ),
    BlocProvider<ProjectsFiltrationBloc>(
      create: (_) => ProjectsFiltrationBloc(),
    ),
  ];
}
