import 'package:pms_system/latest_request/model/latest_request_models.dart';
import 'package:pms_system/latest_request/repo/latest_request_repo.dart';
import 'package:pms_system/shared/pms_exports.dart';

class LatestRequestBloc extends Bloc<AppEvent, AppState> {
  LatestRequestBloc() : super(Start()) {
    on<Click>(_onClick);
  }

  _onClick(AppEvent event, Emitter<AppState> emit) async {
    try {
      emit(Loading());
      
      LatestRequestModel model = await LatestRequestRepo.getLatestRequest();
      
      emit(Done(model: model));
    } catch (e) {
      emit(Error());
    }
  }
}

