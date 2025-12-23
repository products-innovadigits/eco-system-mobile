import 'package:ats_system/shared/ats_exports.dart';
import 'package:core_system/core/bloc/theme_cubit.dart';
import 'package:pms_system/shared/pms_exports.dart';
import 'package:strategy_system/objectives/bloc/objectives_filtration_bloc.dart';

abstract class ProviderList {
  static List<BlocProvider> providers = [
    BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()..init()),
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
