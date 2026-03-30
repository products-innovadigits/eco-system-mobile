import 'package:pms_system/features/employee_learning_details/model/employee_learning_details_model.dart';

abstract class EmployeeLearningDetailsState {
  const EmployeeLearningDetailsState();
}

class EmployeeLearningDetailsInitial extends EmployeeLearningDetailsState {
  const EmployeeLearningDetailsInitial();
}

class EmployeeLearningDetailsLoading extends EmployeeLearningDetailsState {
  const EmployeeLearningDetailsLoading();
}

class EmployeeLearningDetailsLoaded extends EmployeeLearningDetailsState {
  final EmployeeLearningDetailsModel data;

  const EmployeeLearningDetailsLoaded({required this.data});
}

class EmployeeLearningDetailsFailure extends EmployeeLearningDetailsState {
  final String message;

  const EmployeeLearningDetailsFailure({required this.message});
}
