import 'package:ats_system/shared/ats_exports.dart';
import 'package:core_system/core/utility/export.dart';

class JobCardWidget extends StatelessWidget {
  final bool? isExpanded;
  final int? index;
  final JobDataModel? jobDataModel;

  const JobCardWidget({
    super.key,
    this.isExpanded,
    this.index,
    this.jobDataModel,
  });

  @override
  Widget build(BuildContext context) {
    final int pipelineCandidatesCount =
        jobDataModel?.stages
            ?.map((e) => e.count ?? 0)
            .reduce((value, element) => value + element) ??
        0;
    return Container(
      width: context.w,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: context.color.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.color.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              context.read<AtsFiltrationBloc>().reset();
              CustomNavigator.push(
                Routes.CANDIDATES,
                arguments: InitCandidates(
                  stages: jobDataModel?.stages,
                  jobTitle: jobDataModel?.title,
                ),
              );
              context.read<JobsBloc>().add(Expand(arguments: -1));
            },
            child: JobDetailsWidget(
              jobTitle: jobDataModel?.title ?? '',
              address: jobDataModel?.address ?? '',
              jobType: jobDataModel?.chanceType ?? '',
              department: jobDataModel?.department ?? '',
            ),
          ),
          InkWell(
            onTap: () => context.read<JobsBloc>().add(Expand(arguments: index)),
            child: Row(
              children: [
                Images(image: Assets.svgs.multiUser.path),
                SizedBox(width: 8.w),
                Text(
                  '$pipelineCandidatesCount ${allTranslations.text(LocaleKeys.candidate_in_pipeline)}',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.color.secondary,
                  ),
                ),
                const Spacer(),
                AnimatedExpansionArrowWidget(isExpanded: isExpanded ?? false),
              ],
            ),
          ),
          StagesSection(isExpanded: isExpanded, jobDataModel: jobDataModel),
        ],
      ),
    );
  }
}
