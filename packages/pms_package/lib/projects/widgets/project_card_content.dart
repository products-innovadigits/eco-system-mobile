import 'package:core_package/core/helpers/font_sizes.dart';
import 'package:pms_package/shared/pms_exports.dart';

class ProjectCardContent extends StatelessWidget {
  const ProjectCardContent({super.key, required this.project , this.isDetails = false});

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
                    border: Border.all(color: context.color.outline)),
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
                        style: context.textTheme.displaySmall?.copyWith(
                          fontSize: FontSizes.f14,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          text:
                              "${allTranslations.text("time_left")} ${(project.endDate?.difference(DateTime.now()).inDays ?? 0) > 0 ? (project.endDate?.difference(DateTime.now()).inDays ?? 0) : 0} ${allTranslations.text("days")}",
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.color.error,
                          ),
                          children: [
                            TextSpan(
                              text: " | ",
                              style: context.textTheme.bodyMedium?.copyWith(
                                color: context.color.outlineVariant,
                              ),
                            ),
                            TextSpan(
                              text:
                                  "${allTranslations.text(LocaleKeys.deliver_date)}: ${(project.endDate ?? DateTime.now()).format("d/M/yyyy")}",
                              style: context.textTheme.bodyMedium?.copyWith(
                                color: context.color.outlineVariant,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (project.status != null)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Styles.statusColors(project.status ?? "",
                            isLineProgress: true)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(project.status ?? "",
                      style: AppTextStyles.w500.copyWith(
                          fontSize: 12,
                          color: Styles.statusColors(project.status ?? "",
                              isLineProgress: true))),
                ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 16.h, bottom: 8.h),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: LinearProgressIndicator(
                value: getProgressBar() / 100,
                minHeight: 8.h,
                color: Styles.statusColors(
                  project.status ?? '',
                  isLineProgress: true,
                ),
                backgroundColor: Styles.statusColors(
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
                  allTranslations.text(LocaleKeys.progress),
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.color.outlineVariant,
                  ),
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                "${getProgressBar().toStringAsFixed(1)}%",
                style: context.textTheme.labelSmall,
              ),
            ],
          ),
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
