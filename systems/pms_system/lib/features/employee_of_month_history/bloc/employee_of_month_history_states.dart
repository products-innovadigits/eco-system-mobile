import 'package:pms_system/features/employee_of_month_history/model/employee_of_month_history_model.dart';

abstract class EmployeeOfMonthHistoryState {
  const EmployeeOfMonthHistoryState();
}

class EmployeeOfMonthHistoryInitial extends EmployeeOfMonthHistoryState {
  const EmployeeOfMonthHistoryInitial();
}

class EmployeeOfMonthHistoryLoading extends EmployeeOfMonthHistoryState {
  const EmployeeOfMonthHistoryLoading();
}

class EmployeeOfMonthHistoryLoaded extends EmployeeOfMonthHistoryState {
  final List<EmployeeOfMonthHistoryItemModel> items;
  final bool isLoadingMore;
  final int currentPage;
  final int totalPages;
  final int totalCount;
  final bool hasMore;

  const EmployeeOfMonthHistoryLoaded({
    required this.items,
    this.isLoadingMore = false,
    this.currentPage = 0,
    this.totalPages = 1,
    this.totalCount = 0,
    this.hasMore = false,
  });
}

class EmployeeOfMonthHistoryEmpty extends EmployeeOfMonthHistoryState {
  final bool isInitial;

  const EmployeeOfMonthHistoryEmpty({this.isInitial = false});
}

class EmployeeOfMonthHistoryFailure extends EmployeeOfMonthHistoryState {
  final String message;

  const EmployeeOfMonthHistoryFailure({required this.message});
}
