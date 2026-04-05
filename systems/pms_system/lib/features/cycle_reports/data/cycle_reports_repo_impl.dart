import 'package:core_system/core/network/network_layer.dart';
import 'package:pms_system/core/pms_prototype_employees.dart';
import 'package:pms_system/features/cycle_reports/domain/cycle_reports_repo.dart';
import 'package:pms_system/features/cycle_reports/model/cycle_reports_model.dart';

/// Simulated data - replace with real API call when endpoint is available.
class CycleReportsRepoImpl implements CycleReportsRepo {
  final Network network;

  CycleReportsRepoImpl({required this.network});

  @override
  Future<List<CycleReportItemModel>> getCycleReports(int cycleId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return buildPrototypeCycleReportItems();
  }
}
