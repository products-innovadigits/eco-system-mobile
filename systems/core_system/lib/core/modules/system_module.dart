import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SystemModule {
  String get id;

  String get name;

  List<BlocProvider> get providers;
}
