import 'package:eco_system/core/app_event.dart';
import 'package:eco_system/core/app_state.dart';
import 'package:eco_system/core/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBloc extends Bloc<AppEvent, AppState> {
  ProfileBloc() : super(Start()) {
    on<Select>(_onSelectTab);
    on<SelectTab>(_onSelectRatingTab);
    on<ShowDialog>(_onShowMoreDialog);
    on<Expand>(_onExpand);
    on<ToggleExpand>(_onToggleExpansion);
    on<onTechSkillRate>(_onTechSkillRate);
    on<onKnowledgeRate>(_onKnowledgeRate);
    on<onCommunicationRate>(_onCommunicationRate);
  }

  bool isCareerObjExpanded = false;
  bool isEducationExpanded = false;
  bool isWorkExperienceExpanded = false;
  int reviewExpandedIndex = -1;
  bool showMoreDialog = false;
  TextEditingController techSkillsController = TextEditingController();
  TextEditingController knowledgeController = TextEditingController();
  TextEditingController communicationController = TextEditingController();

  ProfileEnum selectedTab = ProfileEnum.profile;
  int selectedRatingTabIndex = 0;
  int selectedTechSkillsRate = -1;
  int selectedKnowledgeRate = -1;
  int selectedCommunicationRate = -1;

  _onExpand(Expand event, Emitter<AppState> emit) async {
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

  _onToggleExpansion(ToggleExpand event, Emitter<AppState> emit) async {
    int index = event.arguments as int;
    reviewExpandedIndex = index;
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

  _onSelectRatingTab(SelectTab event, Emitter<AppState> emit) async {
    int tabIndex = event.arguments as int;
    if (selectedRatingTabIndex != tabIndex) {
      selectedRatingTabIndex = tabIndex;
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

  _onTechSkillRate(onTechSkillRate event, Emitter<AppState> emit) async {
    int rate = event.arguments as int;
    selectedTechSkillsRate = rate;
    emit(Done());
  }

  _onKnowledgeRate(onKnowledgeRate event, Emitter<AppState> emit) async {
    int rate = event.arguments as int;
    selectedKnowledgeRate = rate;
    emit(Done());
  }

  _onCommunicationRate(
      onCommunicationRate event, Emitter<AppState> emit) async {
    int rate = event.arguments as int;
    selectedCommunicationRate = rate;
    emit(Done());
  }

  void resetRatingBottomSheetData() {
    selectedRatingTabIndex = 0;
    reviewExpandedIndex = -1;
    selectedTechSkillsRate = -1;
    selectedKnowledgeRate = -1;
    selectedCommunicationRate = -1;
    techSkillsController.clear();
    knowledgeController.clear();
    communicationController.clear();
  }
}
