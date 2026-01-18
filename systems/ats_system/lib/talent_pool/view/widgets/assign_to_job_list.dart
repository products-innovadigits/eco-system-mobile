import 'package:core_system/core/utility/export.dart';
import 'package:core_system/core/widgets/custom_check_box_widget.dart';

import '../../../shared/ats_exports.dart';
import './status_widget.dart';

class AssignToJobList extends StatefulWidget {
  final Function(List<int>) onSelectJob;
  final List<int> selectedJobsList;

  const AssignToJobList({
    super.key,
    required this.onSelectJob,
    required this.selectedJobsList,
  });

  @override
  State<AssignToJobList> createState() => _AssignToJobListState();
}

class _AssignToJobListState extends State<AssignToJobList> {
  List<int> _selectedJobs = [];

  @override
  void initState() {
    super.initState();
    _selectedJobs = List.from(widget.selectedJobsList);
  }

  void _handleJobSelection(int jobId) {
    setState(() {
      if (_selectedJobs.contains(jobId)) {
        _selectedJobs.remove(jobId);
      } else {
        _selectedJobs.add(jobId);
      }
    });
    widget.onSelectJob(_selectedJobs);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JobsBloc, AppState>(
      builder: (context, state) {
        final jobsBloc = context.read<JobsBloc>();
        final jobsList = jobsBloc.jobsList;

        return switch (state) {
          // ── Loading ─────────────────────────────
          Loading() => const ShimmerCardsList(),

          // ── Done ────────────────────────────────
          Done(:final loading) => Column(
            children: [
              SizedBox(
                height: context.h * 0.6,
                child: ListAnimator(
                  controller: jobsBloc.scrollController,
                  separatorPadding: 16.h,
                  data: List.generate(jobsList.length, (index) {
                    final job = jobsList[index];
                    final isChecked =
                        job.id != null && _selectedJobs.contains(job.id);
                    return _JobCard(
                      job: job,
                      isChecked: isChecked,
                      onToggle: () {
                        if (job.id != null) {
                          _handleJobSelection(job.id!);
                        }
                      },
                    );
                  }),
                ),
              ),
              CustomLoading(isTextLoading: true, loading: loading),
            ],
          ),

          // ── Empty or Error ──────────────────────
          Empty() || Error() => EmptyContainer(
            txt: allTranslations.text("oops"),
            desc: allTranslations.text(
              state is Error
                  ? LocaleKeys.something_went_wrong
                  : LocaleKeys.there_is_no_data,
            ),
          ),

          // ── Fallback (unexpected) ───────────────
          _ => const SizedBox(),
        };
      },
    );
  }
}

class _JobCard extends StatelessWidget {
  final JobDataModel job;
  final bool isChecked;
  final VoidCallback onToggle;

  const _JobCard({
    required this.job,
    required this.isChecked,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (job.id != null) onToggle();
      },
      child: Container(
        width: context.w,
        decoration: BoxDecoration(
          color: context.color.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.color.outline),
        ),
        child: Column(
          children: [
            if (job.status != null) StatusWidget(status: job.status!),
            Padding(
              padding: EdgeInsetsDirectional.only(start: 12.w, bottom: 24.h),
              child: Row(
                children: [
                  CustomCheckBoxWidget(
                    onCheck: () {
                      if (job.id != null) onToggle();
                    },
                    isChecked: isChecked,
                  ),
                  SizedBox(width: 8.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.title ?? '',
                        style: context.textTheme.titleSmall,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '${job.chanceType} . ${job.address} . ${job.department}',
                        style: AppTextStyles.w400.copyWith(
                          color: Styles.subTextDarkColor,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
