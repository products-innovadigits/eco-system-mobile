import 'package:pms_system/core/di/pms_locator.dart';
import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/cycle_review/bloc/cycle_review_bloc.dart';
import 'package:pms_system/features/cycle_review/bloc/cycle_review_events.dart';
import 'package:pms_system/features/cycle_review/bloc/cycle_review_states.dart';
import 'package:pms_system/features/cycle_review/widgets/cycle_overview_section.dart';
import 'package:pms_system/features/cycle_review/widgets/cycle_review_header.dart';
import 'package:pms_system/features/cycle_review/widgets/cycle_review_shimmer.dart';
import 'package:pms_system/features/cycle_review/widgets/overall_progress_section.dart';
import 'package:pms_system/features/cycle_review/widgets/reviewees_section.dart';

import '../model/cycle_review_model.dart';

class CycleReviewView extends StatefulWidget {
  final int cycleId;

  const CycleReviewView({super.key, required this.cycleId});

  @override
  State<CycleReviewView> createState() => _CycleReviewViewState();
}

class _CycleReviewViewState extends State<CycleReviewView> {
  late CycleReviewBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = CycleReviewBloc(repo: pmsSl())
      ..add(LoadReviewCycleSummary(cycleId: widget.cycleId));
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CycleReviewBloc>.value(
      value: _bloc,
      child: Scaffold(
        appBar: CustomAppBar(
          title: allTranslations.text(LocaleKeys.cycle_details),
          withCancelBtn: false,
        ),
        body: BlocBuilder<CycleReviewBloc, CycleReviewState>(
          builder: (context, state) {
            return switch (state) {
              CycleReviewLoading() ||
              ReviewCycleSummaryLoading() => const CycleReviewShimmer(),
              CycleReviewLoaded(:final detail, :final isClosingReviewCycle) =>
                _CycleReviewBody(
                  cycleId: widget.cycleId,
                  detail: detail,
                  isClosingReviewCycle: isClosingReviewCycle,
                ),
              ReviewCycleSummaryLoaded(
                :final summary,
                :final revieweeStatusItems,
                :final totalReviewees,
                :final isClosingReviewCycle,
              ) =>
                _CycleReviewBody(
                  cycleId: widget.cycleId,
                  detail: summary.toCycleDetailDataModel(
                    reviewees: revieweeStatusItems
                        .map((e) => e.toCycleRevieweeModel())
                        .toList(),
                  ),
                  totalReviewees: totalReviewees,
                  isClosingReviewCycle: isClosingReviewCycle,
                ),
              CycleReviewFailure(:final message) => Center(
                child: EmptyContainer(txt: message),
              ),
              ReviewCycleSummaryFailure(:final message) => Center(
                child: EmptyContainer(txt: message),
              ),
              _ => const SizedBox.shrink(),
            };
          },
        ),
      ),
    );
  }
}

class _CycleReviewBody extends StatelessWidget {
  final int cycleId;
  final CycleDetailDataModel detail;
  final int? totalReviewees;
  final bool isClosingReviewCycle;

  const _CycleReviewBody({
    required this.cycleId,
    required this.detail,
    this.totalReviewees,
    this.isClosingReviewCycle = false,
  });

  int get _effectiveCycleId => detail.id ?? cycleId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                CycleReviewHeader(detail: detail),
                SizedBox(height: 20.h),
                OverallProgressSection(detail: detail),
                SizedBox(height: 24.h),
                ReviewersSection(
                  reviewers: detail.reviewees ?? [],
                  cycleId: _effectiveCycleId,
                  totalReviewees: totalReviewees ?? detail.revieweesCount ?? 0,
                ),
                SizedBox(height: 24.h),
                CycleOverviewSection(detail: detail),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
        if (detail.status == 'active' || detail.status == 'overdue')
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0, left: 16, right: 16),
            child: CustomBtn(
              text: allTranslations.text(LocaleKeys.close_review_cycle),
              loading: isClosingReviewCycle,
              onPressed: isClosingReviewCycle
                  ? null
                  : () {
                      YesNoDialogHelper.showCloseReviewCycleConfirmationDialog(
                        context: context,
                        onClosePressed: () {
                          context.read<CycleReviewBloc>().add(
                            CloseReviewCycle(cycleId: _effectiveCycleId),
                          );
                        },
                      );
                    },
            ),
          ),
      ],
    );
  }
}
