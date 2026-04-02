import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/employees_performance/bloc/employees_performance_events.dart';
import 'package:pms_system/features/employees_performance/bloc/employees_performance_states.dart';
import 'package:pms_system/features/employees_performance/domain/employees_performance_repo.dart';
import 'package:pms_system/features/employees_performance/model/employees_performance_model.dart';

class EmployeesPerformanceBloc
    extends Bloc<EmployeesPerformanceEvent, EmployeesPerformanceState> {
  final EmployeesPerformanceRepo repo;
  String? _currentType;

  EmployeesPerformanceBloc({required this.repo})
      : super(const PerformanceInitial()) {
    on<LoadPerformanceData>(_onLoad);
    on<SetEmployeeOfTheMonth>(_onSetEmployeeOfTheMonth);
  }

  Future<void> _onLoad(
    LoadPerformanceData event,
    Emitter<EmployeesPerformanceState> emit,
  ) async {
    try {
      _currentType = event.type;
      emit(const PerformanceLoading());
      EmployeesPerformanceModel model =
          await repo.getPerformanceData(type: event.type);
      final employees = model.data ?? [];

      for (int i = 0; i < employees.length; i++) {
        employees[i].rank = i + 1;
      }

      final top3 = employees.take(3).toList();

      emit(PerformanceLoaded(top3: top3, top10: employees));
    } catch (e) {
      emit(PerformanceFailure(message: e.toString()));
    }
  }

  Future<void> _onSetEmployeeOfTheMonth(
    SetEmployeeOfTheMonth event,
    Emitter<EmployeesPerformanceState> emit,
  ) async {
    try {
      final employee = event.employee;
      await repo.setEmployeeOfTheMonth(
        userId: employee.id!,
        reviewCycleId: employee.reviewCycleId!,
        score: employee.score!,
      );
      AppCore.successMessage(
        allTranslations.text(LocaleKeys.employee_of_the_month_set_successfully),
      );
      add(LoadPerformanceData(type: _currentType));
    } catch (e) {
      AppCore.errorMessage(allTranslations.text('something_went_wrong'));
    }
  }
}
