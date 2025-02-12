import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/app_core.dart';
import '../../../core/app_event.dart';
import '../../../core/app_state.dart';
import '../../../helpers/translation/all_translation.dart';
import '../model/objective_percentage_model.dart';
import '../repo/objective_active_repo.dart';

class ObjectiveCategorizedBloc extends Bloc<AppEvent, AppState> {
  ObjectiveCategorizedBloc() : super(Start()) {
    on<Click>(onClick);
  }

  onClick(AppEvent event, Emitter<AppState> emit) async {
    try {
      emit(Loading());

      Response res = await ObjectiveActiveRepo.getObjectActiveCategorized();

      if (res.statusCode == 200 && res.data != null) {
        List<ObjectivePercentageModel> data = List<ObjectivePercentageModel>.from(
            res.data["data"].map((e) => ObjectivePercentageModel.fromJson(e)));
        emit(Done(list: data));
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
