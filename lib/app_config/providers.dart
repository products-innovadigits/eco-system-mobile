import 'package:eco_system/features/login/bloc/login_bloc.dart';
import 'package:eco_system/features/splah/splash_bloc.dart';
import 'package:eco_system/main_blocs/user_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocProvider;

abstract class ProviderList {
  static List<BlocProvider> providers = [
    BlocProvider<SplashBloc>(create: (_) => SplashBloc()),
    BlocProvider<LoginBloc>(create: (_) => LoginBloc()),
    BlocProvider<UserBloc>(create: (_) => UserBloc()),
  ];
}
