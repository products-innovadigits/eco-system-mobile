import 'package:eco_system/model/custom_field_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/app_core.dart';
import '../../../core/app_event.dart';
import '../../../core/app_state.dart';
import '../../../helpers/translation/all_translation.dart';
import '../repo/projects_repo.dart';

class ProjectPriorityLevelBloc extends Bloc<AppEvent, AppState> {
  ProjectPriorityLevelBloc() : super(Start()) {
    on<Click>(_getStrategicAxis);
  }

  _getStrategicAxis(AppEvent event, Emitter<AppState> emit) async {
    try {
      emit(Loading());

      CustomFieldsModel res = await ProjectsRepo.getProjectPriorityLevel();

      if (res.data != null && res.data!.isNotEmpty) {
        emit(Done(list: res.data!));
      } else {
        emit(Empty());
      }
    } catch (e) {
      AppCore.errorMessage(allTranslations.text('something_went_wrong'));

      emit(Error());
    }
  }
}
