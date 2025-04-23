import 'package:eco_system/core/app_event.dart';
import 'package:eco_system/core/app_state.dart';
import 'package:eco_system/core/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBloc extends Bloc<AppEvent, AppState> {
  ProfileBloc() : super(Start()) {
    on<Select>(_onSelectTab);
    on<Expand>(onExpand);
  }

  bool isCareerObjExpanded = false;
  bool isEducationExpanded = false;
  bool isWorkExperienceExpanded = false;

  Future<void> onExpand(Expand event, Emitter<AppState> emit) async {
    if (event.arguments == 2) {
      isCareerObjExpanded = !isCareerObjExpanded;
    } else if (event.arguments == 1) {
      isEducationExpanded = !isEducationExpanded;
    } else if (event.arguments == 0) {
      isWorkExperienceExpanded = !isWorkExperienceExpanded;
    }
    emit(Done());
  }

  ProfileEnum selectedTab = ProfileEnum.profile;

  _onSelectTab(Select event, Emitter<AppState> emit) async {
    final ProfileEnum tab = event.arguments as ProfileEnum;
    if (selectedTab != tab) {
      selectedTab = tab;
      emit(Done());
    }
  }
}
