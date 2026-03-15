import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/employees_performance/bloc/employees_performance_events.dart';
import 'package:pms_system/features/employees_performance/bloc/employees_performance_states.dart';
import 'package:pms_system/features/employees_performance/domain/employees_performance_repo.dart';
import 'package:pms_system/features/employees_performance/model/employees_performance_model.dart';

class EmployeesPerformanceBloc
    extends Bloc<EmployeesPerformanceEvent, EmployeesPerformanceState> {
  final EmployeesPerformanceRepo repo;

  EmployeesPerformanceBloc({required this.repo})
      : super(const PerformanceInitial()) {
    on<LoadPerformanceData>(_onLoad);
  }

  Future<void> _onLoad(
    LoadPerformanceData event,
    Emitter<EmployeesPerformanceState> emit,
  ) async {
    try {
      emit(const PerformanceLoading());
      EmployeesPerformanceModel model = await repo.getPerformanceData();
      if (model.data != null) {
        emit(PerformanceLoaded(data: model.data!));
      } else {
        emit(const PerformanceFailure(message: 'No data found'));
      }
    } catch (e) {
      emit(PerformanceFailure(message: e.toString()));
    }
  }
}
