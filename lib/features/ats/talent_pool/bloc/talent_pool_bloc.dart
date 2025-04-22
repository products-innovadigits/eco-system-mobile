import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/app_event.dart';
import '../../../../core/app_state.dart';

class TalentPoolBloc extends Bloc<AppEvent, AppState> {
  TalentPoolBloc() : super(Start()) {
    on<Click>(onClick);
    on<Select>(onToggleSelection);
    on<SelectTalent>(onSelectTalent);
  }

  TextEditingController fileNameController = TextEditingController();
  List<int> selectedTalentsList = [];
  bool activeSelection = false;

  void onToggleSelection(Select event, Emitter<AppState> emit) async {
    activeSelection = event.arguments as bool;
    if (activeSelection == false) {
      selectedTalentsList.clear();
    }
    emit(Done());
  }

  void onSelectTalent(SelectTalent event, Emitter<AppState> emit) {
    int talentId = event.arguments as int;
    if (event.arguments != null) {
      if (selectedTalentsList.contains(talentId)) {
        selectedTalentsList.remove(talentId);
      } else {
        selectedTalentsList.add(talentId);
      }
    }
    emit(Done());
  }

  onClick(AppEvent event, Emitter<AppState> emit) async {
    emit(Done());
    // try {
    //   emit(Loading());
    //
    //   Response res = await JobsRepo.getObjectivePercentage();
    //
    //   if (res.statusCode == 200 &&
    //       res.data != null &&
    //       res.data["data"] != null &&
    //       res.data["data"]["totalPercentage"] != null) {
    //     emit(Done(data: res.data["data"]["totalPercentage"]));
    //   } else {
    //     AppCore.errorMessage(allTranslations.text('something_went_wrong'));
    //     emit(Error());
    //   }
    // } catch (e) {
    //   AppCore.errorMessage(allTranslations.text('something_went_wrong'));
    //
    //   emit(Error());
    // }
  }
}
