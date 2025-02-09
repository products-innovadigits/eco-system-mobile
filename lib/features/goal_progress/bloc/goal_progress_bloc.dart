import 'package:dio/dio.dart';
import 'package:eco_system/features/goal_progress/model/goal_progress_model.dart';
import 'package:eco_system/features/goal_progress/repo/goal_progress_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/app_core.dart';
import '../../../core/app_event.dart';
import '../../../core/app_state.dart';
import '../../../helpers/translation/all_translation.dart';

class GoalProgressBloc extends Bloc<AppEvent, AppState> {
  GoalProgressBloc() : super(Start()) {
    on<Click>(onClick);
  }

  onClick(AppEvent event, Emitter<AppState> emit) async {
    try {
      emit(Loading());

      Response res = await GoalProgressRepo.getGoalProgress();

      if (res.statusCode == 200 && res.data != null) {
        GoalProgressModel model = GoalProgressModel.fromJson(res.data['data']);
        emit(Done(model: model));
      } else {
        AppCore.errorMessage(allTranslations.text('something_went_wrong'));
        emit(Error());
      }
    } catch (e) {
      AppCore.errorMessage(allTranslations.text('something_went_wrong'));

      emit(Error());
    }
  }
}
