import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/employee_learning_details/bloc/employee_learning_details_states.dart';
import 'package:pms_system/features/employee_learning_details/model/employee_learning_details_model.dart';

class LoadEmployeeLearningDetails {}

class EmployeeLearningDetailsBloc
    extends Bloc<LoadEmployeeLearningDetails, EmployeeLearningDetailsState> {
  EmployeeLearningDetailsBloc({required this.employeeId})
      : super(EmployeeLearningDetailsInitial()) {
    on<LoadEmployeeLearningDetails>(_onLoad);
  }

  final int employeeId;

  Future<void> _onLoad(
    LoadEmployeeLearningDetails event,
    Emitter<EmployeeLearningDetailsState> emit,
  ) async {
    emit(EmployeeLearningDetailsLoading());
    try {
      // TODO: Replace with repo call when API is available
      await Future.delayed(const Duration(milliseconds: 500));
      emit(EmployeeLearningDetailsLoaded(EmployeeLearningDetailsModel.mock()));
    } catch (e) {
      AppCore.errorMessage(allTranslations.text(LocaleKeys.something_went_wrong));
      emit(EmployeeLearningDetailsFailure(
        allTranslations.text(LocaleKeys.something_went_wrong),
      ));
    }
  }
}
