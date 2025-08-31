import '../../shared/strategy_exports.dart';

class StrategicAxisBloc extends Bloc<AppEvent, AppState> {
  StrategicAxisBloc() : super(Start()) {
    on<Click>(_getStrategicAxis);
  }

  _getStrategicAxis(AppEvent event, Emitter<AppState> emit) async {
    try {
      emit(Loading());

      CustomFieldsModel res = await ObjectivesRepo.getStrategicAxis();

      if (res.data != null && res.data!.isNotEmpty) {
        emit(Done(list: res.data!));
      } else {
        emit(Empty());
      }
    } catch (e) {
      AppCore.errorMessage(allTranslations.text('something_went_wrong'));

      emit(Error());
    }
  }
}
