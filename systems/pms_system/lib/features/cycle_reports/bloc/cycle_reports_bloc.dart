import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/cycle_reports/bloc/cycle_reports_events.dart';
import 'package:pms_system/features/cycle_reports/bloc/cycle_reports_states.dart';
import 'package:pms_system/features/cycle_reports/domain/cycle_reports_repo.dart';

class CycleReportsBloc extends Bloc<CycleReportsEvent, CycleReportsState> {
  final CycleReportsRepo repo;

  CycleReportsBloc({required this.repo}) : super(const CycleReportsInitial()) {
    on<LoadCycleReports>(_onLoad);
  }

  Future<void> _onLoad(
    LoadCycleReports event,
    Emitter<CycleReportsState> emit,
  ) async {
    try {
      emit(const CycleReportsLoading());

      final reports = await repo.getCycleReports(event.cycleId);

      emit(CycleReportsLoaded(reports: reports));
    } catch (e) {
      AppCore.errorMessage(allTranslations.text(LocaleKeys.something_went_wrong));
      emit(CycleReportsFailure(message: e.toString()));
    }
  }
}
