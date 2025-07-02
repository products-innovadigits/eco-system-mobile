

import '../../shared/strategy_exports.dart';

class ObjectiveKPISBloc extends Bloc<AppEvent, AppState> {
  ObjectiveKPISBloc() : super(Start()) {
    on<Click>(onClick);
  }

  onClick(AppEvent event, Emitter<AppState> emit) async {
    try {
      emit(Loading());

      Response res =
          await ObjectiveDetailsRepo.getObjectiveKPIS(event.arguments as int);
      if (res.statusCode == 200 && res.data != null) {
        if (res.data["data"] != null && res.data["data"].isNotEmpty) {
          List<ObjectiveKPIModel> list = List<ObjectiveKPIModel>.from(
              res.data["data"].map((e) => ObjectiveKPIModel.fromJson(e)));
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
