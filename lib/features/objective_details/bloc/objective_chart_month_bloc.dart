import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/app_core.dart';
import '../../../core/app_event.dart';
import '../../../core/app_state.dart';
import '../../../helpers/translation/all_translation.dart';
import '../model/objective_chart_month_model.dart';
import '../repo/objective_details_repo.dart';

class ObjectiveChartMonthBloc extends Bloc<AppEvent, AppState> {
  ObjectiveChartMonthBloc() : super(Start()) {
    on<Click>(onClick);
  }

  onClick(AppEvent event, Emitter<AppState> emit) async {
    try {
      emit(Loading());

      Response res = await ObjectiveDetailsRepo.getObjectiveChartData(
          id: event.arguments as int, filterType: "month");

      if (res.statusCode == 200 && res.data != null) {
        List<ObjectiveChartMonthModel> list =
            List<ObjectiveChartMonthModel>.from(res.data["data"]
                .map((e) => ObjectiveChartMonthModel.fromJson(e)));
        emit(Done(list: list));
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
