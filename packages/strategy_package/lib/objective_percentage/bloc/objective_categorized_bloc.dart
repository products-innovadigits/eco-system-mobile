import '../../shared/strategy_exports.dart';

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
