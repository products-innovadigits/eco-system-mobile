import 'dart:developer';

import 'package:pms_system/pms_home/model/kpis_initiatives_progress_model.dart';
import 'package:pms_system/project_details/bloc/general_progress/project_general_progress_summary_events.dart';
import 'package:pms_system/project_details/bloc/general_progress/project_general_progress_summary_state.dart';
import 'package:pms_system/project_details/model/general_progress_chart_model.dart';
import 'package:pms_system/shared/pms_exports.dart';

class ProjectGeneralProgressSummaryBloc extends Bloc<
    ProjectGeneralProgressSummaryEvent, ProjectGeneralProgressSummaryState> {
  ProjectGeneralProgressSummaryBloc()
      : super(const ProjectGeneralProgressSummaryInitial()) {
    on<LoadGeneralProgressSummary>(_onLoadGeneralProgressSummary);
  }

  GeneralProgressChartModel? chartModel;
  ChartTime selectedChartType = ChartTime.Month;

  _onLoadGeneralProgressSummary(
    LoadGeneralProgressSummary event,
    Emitter<ProjectGeneralProgressSummaryState> emit,
  ) async {
    log(
      'ProjectGeneralProgressSummaryBloc: LoadGeneralProgressSummary received for projectId=${event.projectId}, type=${event.chartType}',
    );
    try {
      emit(const ProjectGeneralProgressSummaryLoading());

      selectedChartType = event.chartType;

      Response res = await ProjectDetailsRepo.getProjectGeneralProgressSummary(
        event.projectId,
        chartType: event.chartType,
      );

      if (res.statusCode == 200 && res.data != null) {
        GeneralProgressChartModel model = GeneralProgressChartModel.fromJson(
          res.data,
        );
        chartModel = model;
        log(
          'ProjectGeneralProgressSummaryBloc: series length = ${chartModel?.series?.length}, type=${chartModel?.type}',
        );
        emit(ProjectGeneralProgressSummaryLoaded(chartModel: model));
      } else {
        emit(
          const ProjectGeneralProgressSummaryFailure(
            message: 'Failed to load progress summary',
          ),
        );
      }
    } catch (e) {
      emit(
        const ProjectGeneralProgressSummaryFailure(
          message: 'Failed to load progress summary',
        ),
      );
    }
  }

  void updateChartType({required ChartTime chartType, required int projectId}) {
    selectedChartType = chartType;
    add(
      LoadGeneralProgressSummary(projectId: projectId, chartType: chartType),
    );
  }
}

