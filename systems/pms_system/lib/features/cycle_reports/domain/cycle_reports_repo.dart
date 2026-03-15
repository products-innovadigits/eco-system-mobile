import 'package:pms_system/features/cycle_reports/model/cycle_reports_model.dart';

abstract class CycleReportsRepo {
  Future<List<CycleReportItemModel>> getCycleReports(int cycleId);
}
