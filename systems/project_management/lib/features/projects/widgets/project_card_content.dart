import 'package:project_management/core/utility/project_management_exports.dart';

class ProjectCardContent extends StatelessWidget {
  const ProjectCardContent({
    super.key,
    required this.project,
    this.isDetails = false,
  });

  final ProjectDetailsModel project;
  final bool isDetails;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final endDate = project.endDate;
    final daysLeft = endDate != null
        ? (endDate.difference(now).inDays > 0
              ? endDate.difference(now).inDays
              : 0)
        : 0;
    final formattedEndDate = (endDate ?? now).format("d/M/yyyy");

    return Container(
      color: context.color.surfaceContainer,
      padding: isDetails ? EdgeInsets.all(16.w) : EdgeInsets.zero,
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
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
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
                      Text(
                        project.title ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.displaySmall?.copyWith(
                          fontSize: FontSizes.f14,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          text:
                              "${allTranslations.text(LocaleKeys.time_left)} $daysLeft ${allTranslations.text(LocaleKeys.days)}",
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.color.error,
                          ),
                          children: [
                            TextSpan(
                              text: " | ",
                              style: context.textTheme.bodySmall?.copyWith(
                                color: context.color.outlineVariant,
                              ),
                            ),
                            TextSpan(
                              text:
                                  "${allTranslations.text(LocaleKeys.deliver_date)}: $formattedEndDate",
                              style: context.textTheme.bodySmall?.copyWith(
                                color: context.color.outlineVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (project.statusAr != null && isDetails)
                CustomInfoContainerWidget(
                  color: LightColor.statusColors(
                    project.statusAr ?? '',
                    isLineProgress: true,
                  ),
                  title: project.statusAr ?? '',
                  radius: 16,
                ),
            ],
          ),

          if (!isDetails &&
              (project.riskLevelName != null ||
                  project.periortyLevelName != null)) ...[
            SizedBox(height: 12.h),

            /// Risk and Priority levels
            Row(
              children: [
                // Risk Level
                if (project.riskLevelName != null)
                  _RiskPriorityWidget(
                    title: allTranslations.text(LocaleKeys.risk_level),
                    level: project.riskLevelName ?? "",
                    color: context.color.error,
                  ),

                SizedBox(width: 16.w),

                // Priority Level
                if (project.periortyLevelName != null)
                  _RiskPriorityWidget(
                    title: allTranslations.text(LocaleKeys.priority),
                    level: project.periortyLevelName ?? "",
                    color: context.color.tertiaryContainer,
                  ),
              ],
            ),
            SizedBox(height: 10.h),
          ],

          /// Activities Progress
          _ActivitiesProgressSection(project: project),
        ],
      ),
    );
  }
}

class _RiskPriorityWidget extends StatelessWidget {
  final String title;
  final String level;
  final Color color;

  const _RiskPriorityWidget({
    required this.title,
    required this.level,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Wrap(
        runSpacing: 4.h,
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        children: [
          Text("$title:", style: context.textTheme.bodySmall),
          SizedBox(width: 8.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.all(Radius.circular(25)),
            ),
            child: Text(
              level,
              style: context.textTheme.bodySmall?.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivitiesProgressSection extends StatelessWidget {
  final ProjectDetailsModel project;

  const _ActivitiesProgressSection({required this.project});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 16.h, bottom: 8.h),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(100)),
            child: LinearProgressIndicator(
              // value: getProgressBar() / 100,
              value: (project.progressRatio ?? 0.0).toDouble() / 100,
              minHeight: 8.h,
              color: LightColor.statusColors(
                project.statusAr ?? '',
                isLineProgress: true,
              ),
              backgroundColor: LightColor.statusColors(
                project.statusAr ?? '',
                isLineProgress: true,
              ).withValues(alpha: 0.1),
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                allTranslations.text(LocaleKeys.activities_progress),
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.color.outlineVariant,
                ),
              ),
            ),
            SizedBox(width: 6.w),
            Text(
              // "${getProgressBar().toStringAsFixed(1)}%",
              "${((project.progressRatio ?? 0.0).toDouble()).toStringAsFixed(1)}%",
              style: context.textTheme.labelSmall,
            ),
          ],
        ),
      ],
    );
  }
}
