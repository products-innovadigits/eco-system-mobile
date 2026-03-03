import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/cycle_review/model/cycle_review_model.dart';

class OverallProgressSection extends StatelessWidget {
  final CycleDetailDataModel detail;

  const OverallProgressSection({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    final progress = (detail.overallProgress ?? 0).clamp(0, 100);
    final completed = detail.completedCount ?? 0;
    final total = detail.totalCount ?? 0;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: context.color.surfaceContainer,
        border: Border.all(color: context.color.outline),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                allTranslations.text(LocaleKeys.overall_progress),
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.color.outlineVariant,
                ),
              ),
              Row(
                children: [
                  Text(
                    '($completed/$total)',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.color.outlineVariant,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '${progress.toInt()}%',
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(
              value: progress / 100,
              minHeight: 10.h,
              color: LightColor.secondary,
              backgroundColor: LightColor.secondary.withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }
}
