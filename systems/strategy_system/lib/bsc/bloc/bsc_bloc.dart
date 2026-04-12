import '../../shared/strategy_exports.dart';

class BscBloc extends Bloc<AppEvent, AppState> {
  BscBloc() : super(Start()) {
    on<Click>(_getBscData);
    // Load is triggered once from [StrategyModule] providers (`..add(Click())`).
  }

  int selectedAxes = 0;

  ///APIs calls
  Future<void> _getBscData(AppEvent event, Emitter<AppState> emit) async {
    emit(Loading());
    try {
      final BscModel res = await BscRepo.getBscData();

      if (res.data != null) {
        emit(Done(data: res.data!));
      } else {
        emit(Error());
      }
    } catch (e) {
      AppCore.errorMessage(
        allTranslations.text(LocaleKeys.something_went_wrong),
      );
      emit(Error());
    }
  }
}
