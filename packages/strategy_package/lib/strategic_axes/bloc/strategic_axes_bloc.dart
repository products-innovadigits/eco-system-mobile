import 'package:core_package/core/utility/export.dart';
import 'package:strategy_package/bsc/model/bsc_model.dart';
import 'package:strategy_package/bsc/repo/bsc_repo.dart';

class StrategicAxesBloc extends Bloc<AppEvent, AppState> {
  StrategicAxesBloc() : super(Start()) {
    on<Click>(_getBscData);
  }

  int selectedAxes = 0;

  ///APIs calls
  Future<void> _getBscData(AppEvent event, Emitter<AppState> emit) async {
    emit(Loading());
    try {
      final BscModel res = await BscRepo.getBscData();

      if (res.data != null) {
        emit(Done(data: res.data));
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
