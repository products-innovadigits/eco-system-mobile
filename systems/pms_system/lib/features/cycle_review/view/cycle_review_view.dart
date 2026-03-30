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
              CycleReviewLoaded(:final detail) => _CycleReviewBody(
                detail: detail,
              ),
              ReviewCycleSummaryLoaded(
                :final summary,
                :final revieweeStatusItems,
                :final totalReviewees,
              ) =>
                _CycleReviewBody(
                  detail: summary.toCycleDetailDataModel(
                    reviewees: revieweeStatusItems
                        .map((e) => e.toCycleRevieweeModel())
                        .toList(),
                  ),
                  totalReviewees: totalReviewees,
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
  final CycleDetailDataModel detail;
  final int? totalReviewees;

  const _CycleReviewBody({required this.detail, this.totalReviewees});

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
                  cycleId: detail.id,
                  totalReviewees: totalReviewees ?? detail.revieweesCount ?? 0,
                ),
                SizedBox(height: 24.h),
                CycleOverviewSection(detail: detail),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 24.0, left: 16, right: 16),
          child: Row(
            children: [
              Expanded(
                child: CustomBtn(
                  text: allTranslations.text(LocaleKeys.close_review_cycle),
                  onPressed: () {},
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: CustomBtn(
                  text: allTranslations.text(LocaleKeys.reports),
                  onPressed: () {
                    CustomNavigator.push(Routes.CYCLE_REPORT);
                  },
                  color: context.color.surfaceContainer,
                  textColor: context.color.primary,
                  borderColor: context.color.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CloseButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
        child: SizedBox(
          width: double.infinity,
          height: 50.h,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: LightColor.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              allTranslations.text(LocaleKeys.close_review_cycle),
              style: context.textTheme.titleSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
