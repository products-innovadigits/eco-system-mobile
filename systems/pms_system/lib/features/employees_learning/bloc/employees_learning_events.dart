import 'package:pms_system/core/utility/pms_exports.dart';

abstract class EmployeesLearningEvent {
  const EmployeesLearningEvent();
}

class LoadEmployees extends EmployeesLearningEvent {
  final SearchEngine searchEngine;

  const LoadEmployees({required this.searchEngine});
}

class RefreshEmployees extends EmployeesLearningEvent {
  const RefreshEmployees();
}

class EmployeesSearchChanged extends EmployeesLearningEvent {
  final String text;

  const EmployeesSearchChanged(this.text);
}

class LoadMoreEmployees extends EmployeesLearningEvent {
  const LoadMoreEmployees();
}
