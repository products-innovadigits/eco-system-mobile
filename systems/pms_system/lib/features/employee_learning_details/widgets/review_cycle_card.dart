import 'dart:ui' as ui;

import 'package:intl/intl.dart';
import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/employee_learning_details/model/employee_learning_details_model.dart';

class ReviewCycleCard extends StatelessWidget {
  const ReviewCycleCard({
    super.key,
    required this.cycle,
    required this.onPreview,
    required this.onRequestLeaningPath,
  });

  final ReviewCycleItem cycle;
  final VoidCallback onPreview;
  final VoidCallback onRequestLeaningPath;

  @override
  Widget build(BuildContext context) {
    final dateStr = cycle.startDate != null
        ? DateFormat('MM/dd/yyyy').format(cycle.startDate!)
        : '--';

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: context.color.surfaceContainer,
        border: Border.all(color: context.color.outline),
        borderRadius: BorderRadius.circular(12.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cycle.name,
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: context.color.onSurface,
            ),
          ),
          SizedBox(height: 8.h),
          RichText(
            text: TextSpan(
              style: context.textTheme.bodySmall?.copyWith(
                color: context.color.outlineVariant,
              ),
              children: [
                TextSpan(
                  text: '${allTranslations.text(LocaleKeys.date_of_cycle)} ',
                ),
                TextSpan(
                  text: dateStr,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.color.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              SizedBox(width: 12.w),
              cycle.isLearningAssignmentSent == false
                  ? Expanded(
                      child: CustomBtn(
                        text: allTranslations.text(
                          LocaleKeys.request_for_learning_path,
                        ),
                        onPressed: onRequestLeaningPath,
                        height: 40,
                      ),
                    )
                  : CustomBtn(
                      text: allTranslations.text(LocaleKeys.requested),
                      onPressed: () {},
                      height: 40,
                      width: 100,
                      color: context.color.primary.withValues(alpha: 0.2),
                    ),
              SizedBox(width: 12.w),
              Expanded(
                child: CustomBtn(
                  text: allTranslations.text(LocaleKeys.download_report),
                  onPressed: onPreview,
                  height: 40,
                  fontSize: FontSizes.f14,
                  color: context.color.surfaceContainer,
                  textColor: context.color.onSurface,
                  borderColor: context.color.outline,
                ),
              ),
            ],
          ),
          if (cycle.report != null &&
              cycle.isLearningAssignmentSent != false) ...[
            SizedBox(height: 12.h),
            _WeakestFactorCard(cycle: cycle),
          ],
        ],
      ),
    );
  }
}

class _WeakestFactorCard extends StatelessWidget {
  final ReviewCycleItem cycle;

  const _WeakestFactorCard({super.key, required this.cycle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: LightColor.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12.w),
      ),
      child: Row(
        children: [
          Container(
            width: 25.w,
            height: 25.w,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: context.color.onPrimary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.trending_down,
              size: 15.w,
              color: LightColor.warning,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  allTranslations.text(LocaleKeys.lowest_competency),
                  style: context.textTheme.labelSmall?.copyWith(
                    color: context.color.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        cycle.report!.weakestFactor!.name!,
                        style: context.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: LightColor.warning,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        '(${cycle.report!.weakestFactor!.avg!.toStringAsFixed(2)} / 5)',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: LightColor.warning,
                          fontSize: FontSizes.f14,
                          fontWeight: FontWeight.w600,
                        ),
                        textDirection: ui.TextDirection.ltr,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
