import 'package:strategy_package/okr/model/okr_model.dart';
import 'package:strategy_package/okr/repo/okr_repo.dart';

import '../../shared/strategy_exports.dart';

class OkrBloc extends Bloc<AppEvent, AppState> {
  OkrBloc() : super(Start()) {
    on<Click>(_getOkrData);
  }

  int selectedAxes = 0;

  ///APIs calls
  Future<void> _getOkrData(AppEvent event, Emitter<AppState> emit) async {
    emit(Loading());
    try {
      final OkrModel res = await OkrRepo.getOkrData();

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
