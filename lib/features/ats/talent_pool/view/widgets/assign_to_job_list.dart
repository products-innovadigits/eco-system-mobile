import 'package:eco_system/features/ats/talent_pool/view/widgets/status_widget.dart';
import 'package:eco_system/utility/export.dart';

class AssignToJobList extends StatelessWidget {
  final Function(List<int>) onSelectJob;
  final List<int> selectedJobsList;

  const AssignToJobList(
      {super.key, required this.onSelectJob, required this.selectedJobsList});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JobsBloc, AppState>(
      builder: (context, state) {
        final bloc = context.read<JobsBloc>();
        final jobsList = bloc.jobsList;
        return SizedBox(
          height: context.h * 0.6,
          child: ListView.separated(
            itemBuilder: (context, index) {
              final job = jobsList[index];
              return InkWell(
                onTap: () {
                  bloc.add(Select(arguments: job.id));
                  onSelectJob(bloc.selectedJobsList);
                },
                child: Container(
                  width: context.w,
                  decoration: BoxDecoration(
                      color: Styles.WHITE_COLOR,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Styles.BORDER)),
                  child: Column(
                    children: [
                      if (job.status != null) StatusWidget(status: job.status!),
                      Padding(
                        padding: EdgeInsetsDirectional.only(
                            start: 12.w, bottom: 24.h),
                        child: Row(
                          children: [
                            CustomCheckBoxWidget(
                                onCheck: () {
                                  bloc.add(Select(arguments: job.id));
                                  onSelectJob(bloc.selectedJobsList);
                                },
                                isChecked: selectedJobsList.contains(job.id)),
                            8.sw,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  job.title ?? '',
                                  style: AppTextStyles.w500
                                      .copyWith(color: Styles.TEXT_COLOR),
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
            },
            separatorBuilder: (context, index) => 12.sh,
            itemCount: jobsList.length,
          ),
        );
      },
    );
  }
}
