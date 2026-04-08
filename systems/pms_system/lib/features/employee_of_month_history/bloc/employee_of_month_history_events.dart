import 'package:pms_system/core/utility/pms_exports.dart';

abstract class EmployeeOfMonthHistoryEvent {
  const EmployeeOfMonthHistoryEvent();
}

class LoadEmployeeOfMonthHistory extends EmployeeOfMonthHistoryEvent {
  final SearchEngine searchEngine;

  const LoadEmployeeOfMonthHistory({required this.searchEngine});
}

class RefreshEmployeeOfMonthHistory extends EmployeeOfMonthHistoryEvent {
  const RefreshEmployeeOfMonthHistory();
}

class EmployeeOfMonthHistorySearchChanged extends EmployeeOfMonthHistoryEvent {
  final String text;

  const EmployeeOfMonthHistorySearchChanged(this.text);
}

class LoadMoreEmployeeOfMonthHistory extends EmployeeOfMonthHistoryEvent {
  const LoadMoreEmployeeOfMonthHistory();
}
