import 'package:pms_system/features/cycle_reports/model/cycle_reports_model.dart';

abstract class CycleReportsState {
  const CycleReportsState();
}

class CycleReportsInitial extends CycleReportsState {
  const CycleReportsInitial();
}

class CycleReportsLoading extends CycleReportsState {
  const CycleReportsLoading();
}

class CycleReportsLoaded extends CycleReportsState {
  final List<CycleReportItemModel> reports;

  const CycleReportsLoaded({required this.reports});
}

class CycleReportsFailure extends CycleReportsState {
  final String message;

  const CycleReportsFailure({required this.message});
}
