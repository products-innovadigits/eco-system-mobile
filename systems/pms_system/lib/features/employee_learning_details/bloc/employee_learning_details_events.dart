abstract class EmployeeLearningDetailsEvent {
  const EmployeeLearningDetailsEvent();
}

class LoadEmployeeLearningDetails extends EmployeeLearningDetailsEvent {
  final int employeeId;
  final String? employeeName;

  const LoadEmployeeLearningDetails({
    required this.employeeId,
    this.employeeName,
  });
}
