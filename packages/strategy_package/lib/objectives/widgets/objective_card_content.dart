import 'package:core_package/core/helpers/font_sizes.dart';

import '../../shared/strategy_exports.dart';

class ObjectiveCardContent extends StatelessWidget {
  const ObjectiveCardContent({super.key, required this.objective , this.isDetails = false});

  final ObjectiveDetailsModel objective;
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
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      objective.title ?? "",
                      style: context.textTheme.displaySmall?.copyWith(
                        fontSize: FontSizes.f14,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text:
                            "${allTranslations.text("time_left")} ${(objective.endDate?.difference(DateTime.now()).inDays ?? 0) > 0 ? (objective.endDate?.difference(DateTime.now()).inDays ?? 0) : 0} ${allTranslations.text("days")}",
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
                                "${allTranslations.text("deliver_date")}: ${(objective.endDate ?? DateTime.now()).format("d/M/yyyy")}",
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: context.color.outlineVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 16.h, bottom: 8.h),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: LinearProgressIndicator(
                value: (objective.weight ?? 0) / 100,
                minHeight: 8.h,
                color: Styles.statusColors(
                  objective.status ?? '',
                  isLineProgress: true,
                ),
                backgroundColor: Styles.statusColors(
                  objective.status ?? '',
                  isLineProgress: true,
                ).withValues(alpha: 0.2),
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
                "${objective.weight?.toStringAsFixed(1) ?? ""}%",
                style: context.textTheme.labelSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
