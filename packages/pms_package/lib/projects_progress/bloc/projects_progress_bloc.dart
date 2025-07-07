
import 'package:pms_package/shared/pms_exports.dart';

class ProjectsProgressBloc extends Bloc<AppEvent, AppState> {
  ProjectsProgressBloc() : super(Start()) {
    on<Click>(onClick);
  }

  onClick(AppEvent event, Emitter<AppState> emit) async {
    try {
      emit(Loading());

      Response res = await ProjectProgressRepo.getProjectProgress();

      if (res.statusCode == 200 && res.data != null) {
        List<ProjectProgressModel> data = List<ProjectProgressModel>.from(
            res.data["data"].map((e) => ProjectProgressModel.fromJson(e)));
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
