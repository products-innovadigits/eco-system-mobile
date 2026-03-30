import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/employee_learning_details/bloc/employee_learning_details_bloc.dart';
import 'package:pms_system/features/employee_learning_details/bloc/employee_learning_details_events.dart';
import 'package:pms_system/features/employee_learning_details/bloc/employee_learning_details_states.dart';
import 'package:pms_system/features/employee_learning_details/domain/employee_learning_details_repo.dart';
import 'package:pms_system/features/employee_learning_details/model/employee_learning_details_model.dart';
import 'package:pms_system/features/employee_learning_details/widgets/competency_highlights_section.dart';
import 'package:pms_system/features/employee_learning_details/widgets/employee_learning_details_header.dart';
import 'package:pms_system/features/employee_learning_details/widgets/employee_learning_details_shimmer.dart';
import 'package:pms_system/features/employee_learning_details/widgets/review_cycle_card.dart';

class EmployeeLearningDetailsView extends StatefulWidget {
  const EmployeeLearningDetailsView({
    super.key,
    required this.employeeId,
    required this.repo,
    this.employeeName,
  });

  final int employeeId;
  final EmployeeLearningDetailsRepo repo;
  final String? employeeName;

  @override
  State<EmployeeLearningDetailsView> createState() =>
      _EmployeeLearningDetailsViewState();
}

class _EmployeeLearningDetailsViewState
    extends State<EmployeeLearningDetailsView> {
  late EmployeeLearningDetailsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = EmployeeLearningDetailsBloc(repo: widget.repo)
      ..add(
        LoadEmployeeLearningDetails(
          employeeId: widget.employeeId,
          employeeName: widget.employeeName,
        ),
      );
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EmployeeLearningDetailsBloc>.value(
      value: _bloc,
      child: Scaffold(
        appBar: CustomAppBar(
          title: allTranslations.text(LocaleKeys.employee_learning_details),
          withCancelBtn: false,
        ),
        body:
            BlocBuilder<
              EmployeeLearningDetailsBloc,
              EmployeeLearningDetailsState
            >(
              builder: (context, state) {
                return switch (state) {
                  EmployeeLearningDetailsLoading() =>
                    const EmployeeLearningDetailsShimmer(),
                  EmployeeLearningDetailsLoaded(:final data) => _Body(
                    data: data,
                  ),
                  EmployeeLearningDetailsFailure(:final message) => Center(
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

class _Body extends StatelessWidget {
  const _Body({required this.data});

  final EmployeeLearningDetailsModel data;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          EmployeeLearningDetailsHeader(
            employeeName: data.employeeName ?? '',
            onRequestLearningPath: () {
              // TODO: Implement request for learning path
            },
          ),
          SizedBox(height: 20.h),
          CompetencyHighlightsSection(
            highestCompetency: data.highestCompetency,
            lowestCompetency: data.lowestCompetency,
          ),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                allTranslations.text(LocaleKeys.review_cycles),
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: context.color.onSurface,
                ),
              ),
              Text(
                '${data.reviewCycles.length} ${allTranslations.text(LocaleKeys.total)}',
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.color.outlineVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ...data.reviewCycles.map(
            (cycle) => ReviewCycleCard(
              cycle: cycle,
              onPreview: () => _onPreviewReport(cycle),
              onRequestLeaningPath: () => _onDownloadReport(cycle),
            ),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  void _onPreviewReport(ReviewCycleItem cycle) {
    // TODO: Navigate to report preview when implemented
  }

  void _onDownloadReport(ReviewCycleItem cycle) {
    // TODO: Implement download when API is available
  }
}
