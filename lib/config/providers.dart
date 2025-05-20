import '../bloc/user_bloc.dart';
import '../utility/export.dart';

abstract class ProviderList {
  static List<BlocProvider> providers = [
    BlocProvider<UserBloc>(create: (_) => UserBloc()),
    BlocProvider<JobsBloc>(
        create: (_) => JobsBloc()..add(Click(arguments: SearchEngine()))),
    // BlocProvider<TalentPoolBloc>(
    //     create: (_) => TalentPoolBloc()..add(Click(arguments: SearchEngine()))),
    BlocProvider<FiltrationBloc>(create: (_) => FiltrationBloc()..add(Click()) , lazy: false),
  ];
}
