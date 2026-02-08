import 'dart:developer';

import 'package:project_management/core/utility/project_management_exports.dart';

class ProjectGeneralProgressSummaryBloc
    extends
        Bloc<
          ProjectGeneralProgressSummaryEvent,
          ProjectGeneralProgressSummaryState
        > {
  final ProjectDetailsRepo repo;

  ProjectGeneralProgressSummaryBloc({required this.repo})
    : super(const ProjectGeneralProgressSummaryInitial()) {
    on<LoadGeneralProgressSummary>(_onLoadGeneralProgressSummary);
  }

  GeneralProgressChartModel? chartModel;
  ChartTime selectedChartType = ChartTime.monthly;

  Future<void> _onLoadGeneralProgressSummary(
    LoadGeneralProgressSummary event,
    Emitter<ProjectGeneralProgressSummaryState> emit,
  ) async {
    log(
      'ProjectGeneralProgressSummaryBloc: LoadGeneralProgressSummary received for projectId=${event.projectId}, type=${event.chartType}',
    );
    try {
      emit(const ProjectGeneralProgressSummaryLoading());

      selectedChartType = event.chartType;

      Response res = await repo.getProjectGeneralProgressSummary(
        event.projectId,
        chartType: event.chartType,
      );

      if (res.statusCode == 200 && res.data != null) {
        GeneralProgressChartModel model = GeneralProgressChartModel.fromJson(
          res.data,
        );
        chartModel = model;
        // latestProgressItem = model.latest;
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
    add(LoadGeneralProgressSummary(projectId: projectId, chartType: chartType));
  }
}
