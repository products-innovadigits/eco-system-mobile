import 'package:ats_package/shared/ats_exports.dart';
import 'package:core_package/core/utility/export.dart';

abstract class ProviderList {
  static List<BlocProvider> providers = [
    BlocProvider<UserBloc>(create: (_) => UserBloc()),
    BlocProvider<JobsBloc>(
        create: (_) => JobsBloc()..add(Click(arguments: SearchEngine()))),
    // BlocProvider<TalentPoolBloc>(
    //     create: (_) => TalentPoolBloc()..add(Click(arguments: SearchEngine()))),
    BlocProvider<FiltrationBloc>(
        create: (_) => FiltrationBloc()..add(Click()), lazy: false),
  ];
}
