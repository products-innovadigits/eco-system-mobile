import 'package:core_package/core/utility/export.dart';
import 'package:core_package/core/widgets/custom_check_box_widget.dart';

import '../../../shared/ats_exports.dart';
import './status_widget.dart';

class AssignToJobList extends StatefulWidget {
  final Function(List<int>) onSelectJob;
  final List<int> selectedJobsList;

  const AssignToJobList(
      {super.key, required this.onSelectJob, required this.selectedJobsList});

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
        if (state is Loading) return LoadingShimmerList();
        if (state is Done) {
          return Column(
            children: [
              SizedBox(
                height: context.h * 0.6,
                child: ListAnimator(
                  controller: jobsBloc.scrollController,
                  separatorPadding: 16.h,
                  data: List.generate(jobsList.length, (index){
                    final job = jobsList[index];
                    return InkWell(
                      onTap: () {
                        if (job.id != null) {
                          _handleJobSelection(job.id!);
                        }
                      },
                      child: Container(
                        width: context.w,
                        decoration: BoxDecoration(
                            color: context.color.surfaceContainer,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Styles.BORDER)),
                        child: Column(
                          children: [
                            if (job.status != null)
                              StatusWidget(status: job.status!),
                            Padding(
                              padding: EdgeInsetsDirectional.only(
                                  start: 12.w, bottom: 24.h),
                              child: Row(
                                children: [
                                  CustomCheckBoxWidget(
                                      onCheck: () {
                                        if (job.id != null) {
                                          _handleJobSelection(job.id!);
                                        }
                                      },
                                      isChecked: job.id != null &&
                                          _selectedJobs.contains(job.id)),
                                  8.sw,
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        job.title ?? '',
                                        style: context.textTheme.titleSmall,
                                      ),
                                      4.sh,
                                      Text(
                                        '${job.chanceType} . ${job.address} . ${job.department}',
                                        style: AppTextStyles.w400.copyWith(
                                            color: Styles.SUB_TEXT_DARK_COLOR,
                                            fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                // child: ListView.separated(
                //   controller: jobsBloc.scrollController,
                //   physics: const BouncingScrollPhysics(),
                //   itemBuilder: (context, index) {
                //     final job = jobsList[index];
                //     return InkWell(
                //       onTap: () {
                //         if (job.id != null) {
                //           _handleJobSelection(job.id!);
                //         }
                //       },
                //       child: Container(
                //         width: context.w,
                //         decoration: BoxDecoration(
                //             color: context.color.surfaceContainer,
                //             borderRadius: BorderRadius.circular(16),
                //             border: Border.all(color: Styles.BORDER)),
                //         child: Column(
                //           children: [
                //             if (job.status != null)
                //               StatusWidget(status: job.status!),
                //             Padding(
                //               padding: EdgeInsetsDirectional.only(
                //                   start: 12.w, bottom: 24.h),
                //               child: Row(
                //                 children: [
                //                   CustomCheckBoxWidget(
                //                       onCheck: () {
                //                         if (job.id != null) {
                //                           _handleJobSelection(job.id!);
                //                         }
                //                       },
                //                       isChecked: job.id != null &&
                //                           _selectedJobs.contains(job.id)),
                //                   8.sw,
                //                   Column(
                //                     crossAxisAlignment:
                //                         CrossAxisAlignment.start,
                //                     children: [
                //                       Text(
                //                         job.title ?? '',
                //                         style: context.textTheme.titleSmall,
                //                       ),
                //                       4.sh,
                //                       Text(
                //                         '${job.chanceType} . ${job.address} . ${job.department}',
                //                         style: AppTextStyles.w400.copyWith(
                //                             color: Styles.SUB_TEXT_DARK_COLOR,
                //                             fontSize: 10),
                //                       ),
                //                     ],
                //                   ),
                //                 ],
                //               ),
                //             )
                //           ],
                //         ),
                //       ),
                //     );
                //   },
                //   separatorBuilder: (context, index) => 12.sh,
                //   itemCount: jobsList.length,
                // ),
              ),
              CustomLoading(isTextLoading: true, loading: state.loading)
            ],
          );
        }
        if (state is Empty || state is Error) {
          return EmptyContainer(
            txt: allTranslations.text("oops"),
            desc: allTranslations.text(state is Error
                ? LocaleKeys.something_went_wrong
                : LocaleKeys.there_is_no_data),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}
