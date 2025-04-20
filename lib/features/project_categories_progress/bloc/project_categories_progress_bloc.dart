import 'package:dio/dio.dart';
import 'package:eco_system/features/project_categories_progress/model/project_progress_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/app_core.dart';
import '../../../core/app_event.dart';
import '../../../core/app_state.dart';
import '../../../helpers/translation/all_translation.dart';
import '../repo/project_categories_progress_repo.dart';

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
        List<ProjectProgressModel> data =
            List<ProjectProgressModel>.from(res.data["data"]
                .map((e) => ProjectProgressModel.fromJson(e)));
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
