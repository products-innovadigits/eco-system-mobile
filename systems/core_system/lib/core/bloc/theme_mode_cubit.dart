import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

/// Drives [MaterialApp.themeMode] alongside [ThemeCubit] (light theme / branding).
class ThemeModeCubit extends Cubit<ThemeMode> {
  ThemeModeCubit() : super(ThemeMode.light);

  void setDark(bool value) {
    emit(value ? ThemeMode.dark : ThemeMode.light);
  }

  void toggle() {
    emit(state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
  }
}
