import 'package:core_package/core/helpers/font_sizes.dart';
import 'package:eco_system/features/reports/model/report_model.dart';
import 'package:pms_package/shared/pms_exports.dart';

class ReportCardContent extends StatelessWidget {
  const ReportCardContent({super.key, required this.report , this.isDetails = false});

  final ReportData report;
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
                  image: Assets.svgs.ppt.path,
                  width: 24.w,
                  height: 24.w,
                ),
              ),
              16.sw,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            report.title ?? "",
                            style: context.textTheme.bodyMedium
                          ),
                        ),
                        if (report.status != null)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: Styles.statusColors(report.status ?? "",
                                  isLineProgress: true)
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(report.status ?? "",
                                style: AppTextStyles.w500.copyWith(
                                    fontSize: 12,
                                    color: Styles.statusColors(report.status ?? "",
                                        isLineProgress: true))),
                          ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Text(report.date ?? '' , style: context.textTheme.bodySmall?.copyWith(color: context.color.outlineVariant)),
                  ],
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}
