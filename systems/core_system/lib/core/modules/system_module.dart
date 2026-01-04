import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/enums.dart';
import 'home_section.dart';

abstract class SystemModule {
  String get id;

  String get name;

  List<BlocProvider> get providers;

  /// Routes provided by this module.
  /// Maps route names to their respective factories.
  Map<String, RouteFactory> get routes;

  /// The active system enum associated with this module.
  ActiveSystemEnum get system;

  /// UI sections to be displayed on the home page.
  List<HomeSection> get homeSections;
}
