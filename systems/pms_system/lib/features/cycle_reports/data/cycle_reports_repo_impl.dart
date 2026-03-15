import 'package:core_system/core/network/network_layer.dart';
import 'package:pms_system/features/cycle_reports/domain/cycle_reports_repo.dart';
import 'package:pms_system/features/cycle_reports/model/cycle_reports_model.dart';

/// Simulated data - replace with real API call when endpoint is available.
class CycleReportsRepoImpl implements CycleReportsRepo {
  final Network network;

  CycleReportsRepoImpl({required this.network});

  @override
  Future<List<CycleReportItemModel>> getCycleReports(int cycleId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _simulatedReports;
  }

  static final List<CycleReportItemModel> _simulatedReports = [
    CycleReportItemModel(
      id: 1,
      name: 'Hassan Aziz',
      jobTitle: 'Senior Product Designer',
      imageUrl: null,
    ),
    CycleReportItemModel(
      id: 2,
      name: 'Sarah Jenkins',
      jobTitle: 'Product Manager',
      imageUrl: null,
    ),
    CycleReportItemModel(
      id: 3,
      name: 'Michael Chen',
      jobTitle: 'Software Engineer',
      imageUrl: null,
    ),
    CycleReportItemModel(
      id: 4,
      name: 'Emma Wilson',
      jobTitle: 'UX Researcher',
      imageUrl: null,
    ),
    CycleReportItemModel(
      id: 5,
      name: 'David Brown',
      jobTitle: 'Engineering Lead',
      imageUrl: null,
    ),
    CycleReportItemModel(
      id: 6,
      name: 'Lisa Anderson',
      jobTitle: 'Data Analyst',
      imageUrl: null,
    ),
  ];
}
