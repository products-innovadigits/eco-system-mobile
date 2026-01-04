import 'package:core_system/core/bloc/theme_cubit.dart';
import 'package:core_system/core/bloc/user_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Core system providers only.
///
/// Feature system providers are registered via SystemModule implementations
/// in the app shell (lib/app/modules/modules_registry.dart).
abstract class ProviderList {
  /// Core providers that are always required (theme, user).
  /// Feature system providers are added via SystemModule.providers.
  static List<BlocProvider> providers = [
    BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()..init()),
    BlocProvider<UserBloc>(create: (_) => UserBloc()),
  ];
}
