import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/app_core.dart';
import '../../../core/app_event.dart';
import '../../../core/app_state.dart';
import '../../../helpers/translation/all_translation.dart';
import '../model/project_progress_model.dart';
import '../repo/projects_progress_repo.dart';

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
