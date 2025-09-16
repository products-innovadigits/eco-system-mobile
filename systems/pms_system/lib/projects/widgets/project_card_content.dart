import 'package:core_system/core/helpers/font_sizes.dart';
import 'package:pms_system/shared/pms_exports.dart';

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
                              "${allTranslations.text(LocaleKeys.time_left)} ${(project.endDate?.difference(DateTime.now()).inDays ?? 0) > 0 ? (project.endDate?.difference(DateTime.now()).inDays ?? 0) : 0} ${allTranslations.text(LocaleKeys.days)}",
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
                                  "${allTranslations.text(LocaleKeys.deliver_date)}: ${(project.endDate ?? DateTime.now()).format("d/M/yyyy")}",
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
              if (project.projectCategoryName != null && isDetails)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: LightColor.statusColors(
                      project.projectCategoryName ?? "",
                      isLineProgress: true,
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    project.projectCategoryName ?? "",
                    style: AppTextStyles.w500.copyWith(
                      fontSize: 12,
                      color: LightColor.statusColors(
                        project.projectCategoryName ?? "",
                        isLineProgress: true,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          if (!isDetails &&
              (project.riskLevel != null || project.priorityLevel != null)) ...[
            const SizedBox(height: 16),

            /// Risk and Priority levels
            Row(
              children: [
                // Risk Level
                if (project.riskLevel != null)
                  _RiskPriorityWidget(
                    title: allTranslations.text(LocaleKeys.risk_level),
                    level: project.riskLevel ?? "",
                    color: context.color.error,
                  ),

                SizedBox(width: 16.w),

                // Priority Level
                if (project.priorityLevel != null)
                  _RiskPriorityWidget(
                    title: allTranslations.text(LocaleKeys.priority),
                    level: project.priorityLevel ?? "",
                    color: context.color.tertiaryContainer,
                  ),
              ],
            ),
            const SizedBox(height: 10),
          ],

          /// Activities Progress
          _ActivitiesProgressSection(project: project),
        ],
      ),
    );
  }

  double getProgressBar() {
    return ((project.startDate ?? DateTime.now())
                .difference(DateTime.now())
                .inDays /
            (project.startDate ?? DateTime.now())
                .difference(project.endDate ?? DateTime.now())
                .inDays) *
        100;
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
      child: Row(
        children: [
          Text("$title:", style: context.textTheme.bodySmall),
          const SizedBox(width: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(25),
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
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(
              // value: getProgressBar() / 100,
              value: (project.progressRatio ?? 0.0).toDouble() / 100,
              minHeight: 8.h,
              color: LightColor.statusColors(
                project.status ?? '',
                isLineProgress: true,
              ),
              backgroundColor: LightColor.statusColors(
                project.status ?? '',
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
