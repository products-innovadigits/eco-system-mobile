import 'package:eco_system/core/app_event.dart';
import 'package:eco_system/core/app_state.dart';
import 'package:eco_system/core/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBloc extends Bloc<AppEvent, AppState> {
  ProfileBloc() : super(Start()) {
    on<Select>(_onSelectTab);
    on<ShowDialog>(_onShowMoreDialog);
    on<Expand>(onExpand);
  }

  bool isCareerObjExpanded = false;
  bool isEducationExpanded = false;
  bool isWorkExperienceExpanded = false;
  bool showMoreDialog = false;

  ProfileEnum selectedTab = ProfileEnum.profile;
  int selectedRatingTabIndex = 0;
  int selectedTechSkillsRate = -1;

  Future<void> onExpand(Expand event, Emitter<AppState> emit) async {
    if (event.arguments == 2) {
      isCareerObjExpanded = !isCareerObjExpanded;
    } else if (event.arguments == 1) {
      isEducationExpanded = !isEducationExpanded;
    } else if (event.arguments == 0) {
      isWorkExperienceExpanded = !isWorkExperienceExpanded;
    }
    showMoreDialog = false;
    emit(Done());
  }

  _onSelectTab(Select event, Emitter<AppState> emit) async {
    showMoreDialog = false;
    final ProfileEnum tab = event.arguments as ProfileEnum;
    if (selectedTab != tab) {
      selectedTab = tab;
    }
    emit(Done());
  }

  _onShowMoreDialog(ShowDialog event, Emitter<AppState> emit) async {
    bool? isDialogOpen = event.arguments as bool?;
    if (isDialogOpen == null) {
      showMoreDialog = !showMoreDialog;
    } else {
      showMoreDialog = false;
    }

    emit(Done());
  }
}
