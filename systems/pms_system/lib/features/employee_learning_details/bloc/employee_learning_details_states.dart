import 'package:pms_system/features/employee_learning_details/model/employee_learning_details_model.dart';

abstract class EmployeeLearningDetailsState {}

class EmployeeLearningDetailsInitial extends EmployeeLearningDetailsState {}

class EmployeeLearningDetailsLoading extends EmployeeLearningDetailsState {}

class EmployeeLearningDetailsLoaded extends EmployeeLearningDetailsState {
  EmployeeLearningDetailsLoaded(this.data);

  final EmployeeLearningDetailsModel data;
}

class EmployeeLearningDetailsFailure extends EmployeeLearningDetailsState {
  EmployeeLearningDetailsFailure(this.message);

  final String message;
}
