import '../../shared/strategy_exports.dart';

class ObjectiveChartMonthBloc extends Bloc<AppEvent, AppState> {
  ObjectiveChartMonthBloc() : super(Start()) {
    on<Click>(onClick);
  }

  onClick(AppEvent event, Emitter<AppState> emit) async {
    try {
      emit(Loading());

      Response res = await ObjectiveDetailsRepo.getObjectiveChartData(
          id: event.arguments as int, time: ChartTime.Month.name);

      if (res.statusCode == 200 && res.data != null) {
        if (res.data["data"] != null && res.data["data"].isNotEmpty) {
          List<ObjectiveChartModel> list = List<ObjectiveChartModel>.from(
              res.data["data"].map((e) => ObjectiveChartModel.fromJson(e)));
          emit(Done(list: list));
        } else {
          emit(Empty());
        }
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
