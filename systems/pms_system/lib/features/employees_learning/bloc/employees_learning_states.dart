import 'package:pms_system/features/employees_learning/model/employees_learning_model.dart';

abstract class EmployeesLearningState {
  const EmployeesLearningState();
}

class EmployeesInitial extends EmployeesLearningState {
  const EmployeesInitial();
}

class EmployeesLoading extends EmployeesLearningState {
  const EmployeesLoading();
}

class EmployeesLoaded extends EmployeesLearningState {
  final List<EmployeeItemModel> employees;
  final bool isLoadingMore;
  final int currentPage;
  final int totalPages;
  final int totalCount;
  final bool hasMore;

  const EmployeesLoaded({
    required this.employees,
    this.isLoadingMore = false,
    this.currentPage = 0,
    this.totalPages = 1,
    this.totalCount = 0,
    this.hasMore = false,
  });
}

class EmployeesEmpty extends EmployeesLearningState {
  final bool isInitial;

  const EmployeesEmpty({this.isInitial = false});
}

class EmployeesFailure extends EmployeesLearningState {
  final String message;

  const EmployeesFailure({required this.message});
}
