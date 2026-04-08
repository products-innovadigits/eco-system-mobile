import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/employee_of_month_history/model/employee_of_month_history_model.dart';

class EmployeeOfMonthHistoryCard extends StatelessWidget {
  final EmployeeOfMonthHistoryItemModel item;

  const EmployeeOfMonthHistoryCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final periodLabel = [
      if (item.month != null && item.month!.isNotEmpty) item.month,
      if (item.year != null && item.year!.isNotEmpty) item.year,
    ].join(' ');

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsetsDirectional.only(
        start: 12.w,
        top: 12.h,
        bottom: 12.h,
        end: 12.w,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: LightColor.border),
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.color.secondary.withValues(alpha: 0.1),
            ),
            child: Center(
              child: Text(
                '${item.percentage?.toStringAsFixed(1) ?? '0'}%',
                style: context.textTheme.labelSmall?.copyWith(
                  color: LightColor.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name ?? '',
                  style: context.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.color.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  item.jobTitle ?? '',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: LightColor.grey,
                    fontSize: FontSizes.f12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                // if (periodLabel.isNotEmpty) ...[
                //   SizedBox(height: 2.h),
                //   Text(
                //     periodLabel,
                //     style: context.textTheme.bodySmall?.copyWith(
                //       color: LightColor.grey,
                //       fontSize: 10,
                //     ),
                //     maxLines: 1,
                //     overflow: TextOverflow.ellipsis,
                //   ),
                // ],
              ],
            ),
          ),
          SizedBox(width: 8.w),
          if (periodLabel.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                color: LightColor.grey.withValues(alpha: 0.1),
              ),
              child: Column(
                children: [
                  Text(
                    periodLabel,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: LightColor.grey,
                      fontSize: FontSizes.f12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
