import 'dart:developer';

import 'package:pms_system/pms_home/model/kpis_initiatives_progress_model.dart';
import 'package:pms_system/project_details/model/general_progress_chart_model.dart';
import 'package:pms_system/shared/pms_exports.dart';

class ProjectGeneralProgressSummaryBloc extends Bloc<AppEvent, AppState> {
  ProjectGeneralProgressSummaryBloc() : super(Start()) {
    on<Click>(_onClick);
  }

  GeneralProgressChartModel? chartModel;
  ChartTime selectedChartType = ChartTime.Month;

  _onClick(Click event, Emitter<AppState> emit) async {
    log(
      'ProjectGeneralProgressSummaryBloc: onClick received for projectId=${event.arguments}, type=$selectedChartType',
    );
    try {
      emit(Loading());

      Response res = await ProjectDetailsRepo.getProjectGeneralProgressSummary(
        event.arguments as int,
        chartType: selectedChartType,
      );

      if (res.statusCode == 200 && res.data != null) {
        GeneralProgressChartModel model = GeneralProgressChartModel.fromJson(
          res.data,
        );
        chartModel = model;
        log(
          'ProjectGeneralProgressSummaryBloc: series length = ${chartModel?.series?.length}, type=${chartModel?.type}',
        );
        emit(Done());
      } else {
        AppCore.errorMessage(allTranslations.text('something_went_wrong'));
        emit(Error());
      }
    } catch (e) {
      AppCore.errorMessage(allTranslations.text('something_went_wrong'));

      emit(Error());
    }
  }

  void updateChartType({required ChartTime chartType, required int projectId}) {
    selectedChartType = chartType;
    add(Click(arguments: projectId));
  }
}
