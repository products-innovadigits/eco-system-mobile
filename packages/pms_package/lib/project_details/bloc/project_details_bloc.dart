
import 'package:pms_package/shared/pms_exports.dart';

class ProjectDetailsBloc extends Bloc<AppEvent, AppState> {
  ProjectDetailsBloc() : super(Start()) {
    on<Click>(onClick);
  }

  onClick(AppEvent event, Emitter<AppState> emit) async {
    try {
      emit(Loading());

      Response res =
          await ProjectDetailsRepo.getProjectDetails(event.arguments as int);

      if (res.statusCode == 200 &&
          res.data != null &&
          res.data["data"] != null) {
        ProjectDetailsModel model =
            ProjectDetailsModel.fromJson(res.data["data"]);
        emit(Done(model: model));
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
