import '../../shared/strategy_exports.dart';

class ObjectivePercentageBloc extends Bloc<AppEvent, AppState> {
  ObjectivePercentageBloc() : super(Start()) {
    on<Click>(onClick);
  }

  Future<void> onClick(AppEvent event, Emitter<AppState> emit) async {
    try {
      emit(Loading());

      Response res = await ObjectiveActiveRepo.getObjectivePercentage();

      if (res.statusCode == 200 &&
          res.data != null &&
          res.data["data"] != null &&
          res.data["data"]["totalPercentage"] != null) {
        emit(Done(data: _parseTotalPercentage(res.data["data"]["totalPercentage"])));
      } else {
        AppCore.errorMessage(allTranslations.text('something_went_wrong'));
        emit(Error());
      }
    } catch (e) {
      AppCore.errorMessage(allTranslations.text('something_went_wrong'));

      emit(Error());
    }
  }

  /// JSON may deliver total as [num] or percentage [String]; charts expect a [double].
  static double _parseTotalPercentage(dynamic raw) {
    if (raw == null) return 0;
    if (raw is num) return raw.toDouble();
    return double.tryParse(raw.toString().replaceAll('%', '').trim()) ?? 0;
  }
}
