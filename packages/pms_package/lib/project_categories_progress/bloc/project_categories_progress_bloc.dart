import 'package:pms_package/shared/pms_exports.dart';

class ProjectCategoriesProgressBloc extends Bloc<AppEvent, AppState> {
  ProjectCategoriesProgressBloc() : super(Start()) {
    on<Click>(onClick);
  }

  onClick(AppEvent event, Emitter<AppState> emit) async {
    try {
      emit(Loading());

      Response res =
          await ProjectCategoriesProgressRepo.getProjectCategoriesProgress();

      if (res.statusCode == 200 && res.data != null) {
        List<ProjectCategoriesProgressModel> data =
            List<ProjectCategoriesProgressModel>.from(res.data["data"]
                .map((e) => ProjectCategoriesProgressModel.fromJson(e)));
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
