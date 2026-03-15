import 'package:intl/intl.dart';
import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/employee_learning_details/model/employee_learning_details_model.dart';

class ReviewCycleCard extends StatelessWidget {
  const ReviewCycleCard({
    super.key,
    required this.cycle,
    required this.onPreview,
    required this.onDownload,
  });

  final ReviewCycleItem cycle;
  final VoidCallback onPreview;
  final VoidCallback onDownload;

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('MM/dd/yyyy').format(cycle.dateOfCycle);

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
            cycle.role,
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
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: CustomBtn(
                  text: allTranslations.text(LocaleKeys.preview_report),
                  onPressed: onPreview,
                  height: 40,
                  fontSize: FontSizes.f14,
                  color: context.color.surfaceContainer,
                  textColor: context.color.onSurface,
                  borderColor: context.color.outline,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: CustomBtn(
                  text: allTranslations.text(LocaleKeys.download_report),
                  onPressed: onDownload,
                  height: 40,
                  fontSize: FontSizes.f14,
                  color: LightColor.secondary,
                  textColor: Colors.white,
                  borderColor: Colors.transparent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
