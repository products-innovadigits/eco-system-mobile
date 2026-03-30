import 'package:core_system/core/network/error/network_exception.dart';
import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/employee_learning_details/bloc/employee_learning_details_events.dart';
import 'package:pms_system/features/employee_learning_details/bloc/employee_learning_details_states.dart';
import 'package:pms_system/features/employee_learning_details/domain/employee_learning_details_repo.dart';
import 'package:pms_system/features/employee_learning_details/model/employee_learning_details_model.dart';

class EmployeeLearningDetailsBloc
    extends Bloc<EmployeeLearningDetailsEvent, EmployeeLearningDetailsState> {
  final EmployeeLearningDetailsRepo repo;

  EmployeeLearningDetailsBloc({required this.repo})
    : super(const EmployeeLearningDetailsInitial()) {
    on<LoadEmployeeLearningDetails>(_onLoad);
  }

  EmployeeLearningDetailsModel? _cachedModel;

  Future<void> _onLoad(
    LoadEmployeeLearningDetails event,
    Emitter<EmployeeLearningDetailsState> emit,
  ) async {
    try {
      emit(const EmployeeLearningDetailsLoading());

      ReviewCyclesModel? reviewCyclesModel;
      LastReviewCycleReportModel? lastReportModel;

      try {
        reviewCyclesModel = await repo.getReviewCycles(
          userId: event.employeeId,
        );
      } catch (_) {}

      try {
        lastReportModel = await repo.getLastReviewCycleReport(
          userId: event.employeeId,
        );
      } catch (_) {}

      if (reviewCyclesModel == null && lastReportModel == null) {
        emit(
          const EmployeeLearningDetailsFailure(
            message: 'Failed to load employee learning details',
          ),
        );
        return;
      }

      final reviewCycles =
          reviewCyclesModel?.data
              ?.map((item) => ReviewCycleItem.fromApiModel(item))
              .toList() ??
          [];

      CompetencyItem? highestCompetency;
      CompetencyItem? lowestCompetency;

      final reportData = lastReportModel?.reportData;
      if (reportData?.strongestFactor != null) {
        final factor = reportData!.strongestFactor!;
        highestCompetency = CompetencyItem(
          name: factor.name ?? '',
          score: factor.avg ?? 0,
        );
      }

      if (reportData?.weakestFactor != null) {
        final factor = reportData!.weakestFactor!;
        lowestCompetency = CompetencyItem(
          name: factor.name ?? '',
          score: factor.avg ?? 0,
        );
      }

      _cachedModel = EmployeeLearningDetailsModel(
        employeeName: event.employeeName,
        highestCompetency: highestCompetency,
        lowestCompetency: lowestCompetency,
        reviewCycles: reviewCycles,
      );

      emit(EmployeeLearningDetailsLoaded(data: _cachedModel!));
    } on NetworkException catch (e) {
      emit(EmployeeLearningDetailsFailure(message: e.message));
    } catch (e) {
      emit(
        const EmployeeLearningDetailsFailure(
          message: 'Failed to load employee learning details',
        ),
      );
    }
  }
}
