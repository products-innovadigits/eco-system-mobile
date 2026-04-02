import 'package:pms_system/core/di/pms_locator.dart';
import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/cycle_reports/bloc/cycle_reports_bloc.dart';
import 'package:pms_system/features/cycle_reports/bloc/cycle_reports_events.dart';
import 'package:pms_system/features/cycle_reports/bloc/cycle_reports_states.dart';
import 'package:pms_system/features/cycle_reports/domain/cycle_reports_repo.dart';
import 'package:pms_system/features/cycle_reports/model/cycle_reports_model.dart';
import 'package:pms_system/features/cycle_reports/widgets/report_card.dart';

import '../../cycle_review/model/cycle_review_model.dart';
import '../../cycle_review/widgets/cycle_review_header.dart';

class CycleReportsView extends StatefulWidget {
  const CycleReportsView({
    super.key,
    required this.cycleId,
    required this.cycleName,
  });

  final int cycleId;
  final String cycleName;

  @override
  State<CycleReportsView> createState() => _CycleReportsViewState();
}

class _CycleReportsViewState extends State<CycleReportsView> {
  late CycleReportsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = CycleReportsBloc(repo: pmsSl<CycleReportsRepo>())
      ..add(LoadCycleReports(cycleId: widget.cycleId));
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CycleReportsBloc>.value(
      value: _bloc,
      child: Scaffold(
        appBar: CustomAppBar(
          title: allTranslations.text(LocaleKeys.cycle_reports),
          withCancelBtn: false,
        ),
        body: BlocBuilder<CycleReportsBloc, CycleReportsState>(
          builder: (context, state) {
            return switch (state) {
              CycleReportsLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
              CycleReportsLoaded(:final reports) => SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    CycleReviewHeader(
                      detail: CycleDetailDataModel(
                        title: 'Bi-Annual Review',
                        status: 'active',
                      ),
                    ),
                    SizedBox(height: 24.h),
                    ...reports.map(
                      (report) => ReportCard(
                        report: report,
                        onView: () => _onViewReport(report),
                        onDownload: () => _onDownloadReport(report),
                      ),
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
              CycleReportsFailure(:final message) => Center(
                child: EmptyContainer(txt: message),
              ),
              _ => const SizedBox.shrink(),
            };
          },
        ),
      ),
    );
  }

  void _onViewReport(CycleReportItemModel report) {
    // TODO: Navigate to report viewer when implemented
  }

  void _onDownloadReport(CycleReportItemModel report) {
    // TODO: Implement download when API is available
  }
}
