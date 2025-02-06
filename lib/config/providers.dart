import 'package:flutter_bloc/flutter_bloc.dart' show BlocProvider;

import '../bloc/user_bloc.dart';

abstract class ProviderList {
  static List<BlocProvider> providers = [
    BlocProvider<UserBloc>(create: (_) => UserBloc()),
  ];
}