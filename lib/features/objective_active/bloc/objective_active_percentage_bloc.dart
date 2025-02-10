import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/app_core.dart';
import '../../../core/app_event.dart';
import '../../../core/app_state.dart';
import '../../../helpers/translation/all_translation.dart';
import '../repo/objective_active_repo.dart';

class ObjectActivePercentageBloc extends Bloc<AppEvent, AppState> {
  ObjectActivePercentageBloc() : super(Start()) {
    on<Click>(onClick);
  }

  onClick(AppEvent event, Emitter<AppState> emit) async {
    try {
      emit(Loading());

      Response res = await ObjectiveActiveRepo.getObjectActivePercentage();

      if (res.statusCode == 200 &&
          res.data != null &&
          res.data["data"] != null &&
          res.data["data"]["totalPercentage"] != null) {
        emit(Done(data: res.data["data"]["totalPercentage"]));
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
