import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/app_event.dart';
import '../../../../core/app_state.dart';

class ProfileBloc extends Bloc<AppEvent, AppState> {
  ProfileBloc() : super(Start()) {
    on<Select>(_onSelectTab);
  }

  final int selectedTabIndex = 0;

  _onSelectTab(Select event, Emitter<AppState> emit) async {
    int index = event.arguments as int;
    log('Selected tab index: $index');
    if (selectedTabIndex == index) {
      emit(Done());
    } else {
      emit(Done());
    }
  }
}
