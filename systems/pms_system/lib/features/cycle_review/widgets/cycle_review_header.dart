import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/cycle_review/model/cycle_review_model.dart';

class CycleReviewHeader extends StatelessWidget {
  final CycleDetailDataModel detail;

  const CycleReviewHeader({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: LightColor.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.assessment_outlined,
            size: 22.w,
            color: Colors.white,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                detail.title ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.displaySmall?.copyWith(
                  fontSize: FontSizes.f16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (detail.subtitle != null && detail.subtitle!.isNotEmpty) ...[
                SizedBox(height: 4.h),
                Text(
                  detail.subtitle ?? '',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.color.outlineVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
        SizedBox(width: 12.w),
        _StatusBadge(status: detail.status ?? ''),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  Color _statusColor() {
    switch (status) {
      case 'Active':
        return LightColor.tertiary;
      case 'Completed':
        return LightColor.secondary;
      case 'Overdue':
        return LightColor.error;
      default:
        return LightColor.secondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _statusColor();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status.toUpperCase(),
        style: context.textTheme.labelSmall?.copyWith(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
