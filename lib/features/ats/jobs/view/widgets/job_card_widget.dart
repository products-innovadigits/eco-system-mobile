import 'package:eco_system/features/ats/candidates/view/sections/candidate_stages_list_section.dart';
import 'package:eco_system/features/ats/jobs/view/widgets/job_details_widget.dart';
import 'package:eco_system/utility/export.dart';

class JobCardWidget extends StatelessWidget {
  final bool? isExpanded;
  final int? index;
  final JobDataModel? jobDataModel;

  const JobCardWidget(
      {super.key, this.isExpanded, this.index, this.jobDataModel});

  @override
  Widget build(BuildContext context) {
    final int pipelineCandidatesCount = jobDataModel?.stages
            ?.map((e) => e.count ?? 0)
            .reduce((value, element) => value + element) ??
        0;
    return Container(
      width: context.w,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
          color: Styles.WHITE_COLOR,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Styles.BORDER)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
              onTap: () {
                CustomNavigator.push(Routes.CANDIDATES,
                    arguments: InitCandidates(
                        stages: jobDataModel?.stages,
                        jobTitle: jobDataModel?.title));
                context.read<JobsBloc>().add(Expand(arguments: -1));
              },
              child: JobDetailsWidget(
                jobTitle: jobDataModel?.title ?? '',
                address: jobDataModel?.address ?? '',
                jobType: jobDataModel?.chanceType ?? '',
                department: jobDataModel?.department ?? '',
              )),
          InkWell(
            onTap: () => context.read<JobsBloc>().add(Expand(arguments: index)),
            child: Row(
              children: [
                Images(image: Assets.svgs.multiUser.path),
                8.sw,
                Text(
                  '${pipelineCandidatesCount} ${allTranslations.text(LocaleKeys.candidate_in_pipeline)}',
                  style: AppTextStyles.w400
                      .copyWith(color: Styles.PRIMARY_COLOR, fontSize: 12),
                ),
                const Spacer(),
                Icon(
                    isExpanded == false
                        ? Icons.keyboard_arrow_down_rounded
                        : Icons.keyboard_arrow_up_rounded,
                    color: isExpanded == false
                        ? Styles.ICON_GREY_COLOR
                        : Styles.PRIMARY_COLOR)
              ],
            ),
          ),
          if (isExpanded == true) ...[
            CandidateStagesListSection(
                stages: jobDataModel?.stages ?? [],
                jobTitle: jobDataModel?.title ?? ''),
          ]
        ],
      ),
    );
  }
}
