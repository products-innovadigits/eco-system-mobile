
import '../../shared/strategy_exports.dart';

class ObjectiveInitiativesBloc extends Bloc<AppEvent, AppState> {
  ObjectiveInitiativesBloc() : super(Start()) {
    on<Click>(onClick);
  }

  onClick(AppEvent event, Emitter<AppState> emit) async {
    try {
      emit(Loading());

      Response res = await ObjectiveDetailsRepo.getObjectiveInitiatives(
          event.arguments as int);

      if (res.statusCode == 200 && res.data != null) {
        if (res.data["data"] != null && res.data["data"].isNotEmpty) {
          List<ObjectiveInitiativeModel> list =
              List<ObjectiveInitiativeModel>.from(res.data["data"]
                  .map((e) => ObjectiveInitiativeModel.fromJson(e)));
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
