
import 'package:pms_package/shared/pms_exports.dart';

class ReportsFilterBloc extends Bloc<AppEvent, AppState> {
  ReportsFilterBloc() : super(Start()) {
    // on<Click>(_getStrategicAxis);
  }

  // _getStrategicAxis(AppEvent event, Emitter<AppState> emit) async {
  //   try {
  //     emit(Loading());
  //
  //     CustomFieldsModel res = await ProjectsRepo.getProjectPriorityLevel();
  //
  //     if (res.data != null && res.data!.isNotEmpty) {
  //       emit(Done(list: res.data!));
  //     } else {
  //       emit(Empty());
  //     }
  //   } catch (e) {
  //     AppCore.errorMessage(allTranslations.text('something_went_wrong'));
  //
  //     emit(Error());
  //   }
  // }
}
