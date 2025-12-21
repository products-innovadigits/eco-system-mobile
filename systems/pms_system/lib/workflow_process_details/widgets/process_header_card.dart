import '../../shared/pms_exports.dart';

class ProcessHeaderCard extends StatelessWidget {
  const ProcessHeaderCard({
    super.key,
    required this.project,
    required this.stageName,
  });

  final ProjectDetailsModel project;
  final String stageName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: context.color.surfaceContainer,
        border: Border(bottom: BorderSide(color: context.color.outline)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: context.color.surfaceContainer,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: context.color.outline),
                ),
                child: Images(
                  image: Assets.svgs.moneys.path,
                  width: 24.w,
                  height: 24.w,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: project.title ?? "",
                          style: context.textTheme.displaySmall?.copyWith(
                            fontSize: FontSizes.f14,
                          ),
                          // children: [
                          //   TextSpan(text: ' '),
                          //   TextSpan(
                          //     text:
                          //         "(${(project.startDate ?? DateTime.now()).format("d/M/yyyy")} : ${(project.endDate ?? DateTime.now()).format("d/M/yyyy")})",
                          //     style: context.textTheme.labelSmall?.copyWith(
                          //       fontSize: FontSizes.f10,
                          //       color: context.color.outlineVariant,
                          //     ),
                          //   ),
                          // ],
                        ),
                      ),
                      // Text(
                      //   project.title ?? "",
                      //   maxLines: 2,
                      //   overflow: TextOverflow.ellipsis,
                      //   style: context.textTheme.displaySmall?.copyWith(
                      //     fontSize: FontSizes.f14,
                      //   ),
                      // ),
                      SizedBox(height: 4.h),
                      Text(
                        '${allTranslations.text(LocaleKeys.stage_name)} : $stageName',
                        style: context.textTheme.labelSmall?.copyWith(
                          fontSize: FontSizes.f10,
                          color: context.color.secondary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${allTranslations.text(LocaleKeys.current_step)} : ${context.read<WorkflowProcessDetailsBloc>().stageDocsData?.currentStep?.text ?? ''}',
                        style: context.textTheme.labelSmall?.copyWith(
                          fontSize: FontSizes.f10,
                          color: context.color.secondary,
                        ),
                      ),
                      RichText(
                        textAlign: TextAlign.start,

                        text: TextSpan(
                          text:
                              "${allTranslations.text(LocaleKeys.start_time)} ${(project.startDate ?? DateTime.now()).format("d/M/yyyy")}",
                          style: context.textTheme.labelSmall?.copyWith(
                            color: context.color.outlineVariant,
                            fontSize: FontSizes.f10,
                          ),
                          children: [
                            TextSpan(
                              text: "  |  ",
                              style: context.textTheme.labelSmall?.copyWith(
                                color: context.color.outlineVariant,
                              ),
                            ),
                            TextSpan(
                              text:
                                  "${allTranslations.text(LocaleKeys.end_time)}: ${(project.endDate ?? DateTime.now()).format("d/M/yyyy")}",
                              style: context.textTheme.labelSmall?.copyWith(
                                color: context.color.outlineVariant,
                                fontSize: FontSizes.f10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Wrap(
                        runSpacing: 8,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: context.color.tertiaryContainer.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${allTranslations.text(LocaleKeys.project_fund)}: ${project.budget}',
                              style: context.textTheme.bodySmall?.copyWith(
                                color: context.color.tertiary,
                                fontSize: FontSizes.f10,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: context.color.tertiaryContainer.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${allTranslations.text(LocaleKeys.project_manager)}:  ${project.managerName}',
                              style: context.textTheme.bodySmall?.copyWith(
                                color: context.color.tertiary,
                                fontSize: FontSizes.f10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
