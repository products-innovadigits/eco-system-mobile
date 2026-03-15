import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/cycle_reports/model/cycle_reports_model.dart';

class ReportCard extends StatelessWidget {
  const ReportCard({
    super.key,
    required this.report,
    required this.onView,
    required this.onDownload,
  });

  final CycleReportItemModel report;
  final VoidCallback onView;
  final VoidCallback onDownload;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: context.color.surfaceContainer,
        border: Border.all(color: context.color.outline),
        borderRadius: BorderRadius.circular(12.w),
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: context.color.outlineVariant.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: CustomNetworkImage.circleNewWorkImage(
              image: report.imageUrl,
              backGroundColor: context.color.outlineVariant.withValues(alpha: 0.2),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  report.name,
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.color.onSurface,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  report.jobTitle,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.color.outlineVariant,
                    fontSize: FontSizes.f12,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ActionButton(
                icon: Icons.visibility_outlined,
                onPressed: onView,
                tooltip: allTranslations.text(LocaleKeys.view_report),
              ),
              SizedBox(width: 8.w),
              _ActionButton(
                icon: Icons.download_outlined,
                onPressed: onDownload,
                tooltip: allTranslations.text(LocaleKeys.download_report),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.color.outlineVariant.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(24),
        child: Tooltip(
          message: tooltip,
          child: Padding(
            padding: EdgeInsets.all(10.w),
            child: Icon(
              icon,
              size: 20.w,
              color: context.color.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
