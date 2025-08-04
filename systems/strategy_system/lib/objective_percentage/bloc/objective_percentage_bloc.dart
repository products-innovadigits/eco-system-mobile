import '../../shared/strategy_exports.dart';


class ObjectivePercentageBloc extends Bloc<AppEvent, AppState> {
  ObjectivePercentageBloc() : super(Start()) {
    on<Click>(onClick);
  }

  onClick(AppEvent event, Emitter<AppState> emit) async {
    try {
      emit(Loading());

      Response res = await ObjectiveActiveRepo.getObjectivePercentage();

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
