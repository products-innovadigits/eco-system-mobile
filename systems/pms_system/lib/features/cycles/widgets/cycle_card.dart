import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/cycles/model/cycles_model.dart';

class CycleCard extends StatelessWidget {
  const CycleCard({super.key, required this.cycle});

  final CycleItemModel cycle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>
          CustomNavigator.push(Routes.CYCLE_REVIEW, arguments: cycle.id),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: context.color.surfaceContainer,
          border: Border.all(color: context.color.outline),
          borderRadius: BorderRadius.circular(12.w),
        ),
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CycleCardHeader(cycle: cycle),
            SizedBox(height: 12.h),
            _CycleCardAssignees(cycle: cycle),
            SizedBox(height: 16.h),
            _CycleCardReviews(cycle: cycle),
          ],
        ),
      ),
    );
  }
}

class _CycleCardHeader extends StatelessWidget {
  final CycleItemModel cycle;

  const _CycleCardHeader({required this.cycle});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: context.color.surfaceContainer,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(color: context.color.outline),
          ),
          child: Icon(Icons.sync, size: 24.h, color: LightColor.secondary),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Text(
                  cycle.title ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.displaySmall?.copyWith(
                    fontSize: FontSizes.f14,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              _StatusBadge(status: cycle.status ?? ''),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  Color _statusColor() {
    switch (status) {
      case 'Completed':
        return LightColor.tertiary;
      case 'Active':
        return LightColor.secondary;
      case 'Overdue':
        return LightColor.error;
      case 'Not Started':
        return LightColor.grey;
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

class _CycleCardAssignees extends StatelessWidget {
  final CycleItemModel cycle;

  const _CycleCardAssignees({required this.cycle});

  @override
  Widget build(BuildContext context) {
    final assignees = cycle.assignees ?? [];
    final displayCount = assignees.length > 3 ? 3 : assignees.length;
    final extraCount = assignees.length - displayCount;

    return Row(
      children: [
        if (assignees.isNotEmpty)
          SizedBox(
            width: (displayCount * 17.w) + 15.w + (extraCount > 0 ? 20.w : 0),
            height: 28.h,
            child: Stack(
              textDirection: TextDirection.ltr,
              children: [
                ...List.generate(
                  displayCount,
                  (index) => Positioned(
                    left: index * 17.w,
                    child: Container(
                      width: 28.w,
                      height: 28.h,
                      decoration: BoxDecoration(
                        color: context.color.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: context.color.surfaceContainer,
                          width: 1.5,
                        ),
                      ),
                      child: CustomNetworkImage.circleNewWorkImage(
                        backGroundColor: context.color.primary,
                      ),
                    ),
                  ),
                ),
                if (extraCount > 0)
                  Positioned(
                    left: displayCount * 17.w,
                    child: Container(
                      width: 28.w,
                      height: 28.h,
                      decoration: BoxDecoration(
                        color: context.color.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: context.color.surfaceContainer,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '+$extraCount',
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.color.onPrimary,
                            fontSize: 9,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            '${allTranslations.text(LocaleKeys.done_by)} ${cycle.dueDate ?? ''}',
            style: context.textTheme.bodySmall?.copyWith(
              color: context.color.outlineVariant,
            ),
          ),
        ),
      ],
    );
  }
}

class _CycleCardReviews extends StatelessWidget {
  final CycleItemModel cycle;

  const _CycleCardReviews({required this.cycle});

  static const List<Color> _reviewColors = [
    Color(0xff079455),
    Color(0xff175CD3),
    Color(0xff020F4C),
  ];

  @override
  Widget build(BuildContext context) {
    final reviews = cycle.reviews ?? [];
    return Column(
      children: List.generate(reviews.length, (index) {
        final review = reviews[index];
        final color = index < _reviewColors.length
            ? _reviewColors[index]
            : LightColor.secondary;
        return Padding(
          padding: EdgeInsets.only(
            bottom: index < reviews.length - 1 ? 10.h : 0,
          ),
          child: _ReviewProgressItem(
            label: review.name ?? '',
            percentage: (review.percentage ?? 0).toInt(),
            color: color,
          ),
        );
      }),
    );
  }
}

class _ReviewProgressItem extends StatelessWidget {
  final String label;
  final int percentage;
  final Color color;

  const _ReviewProgressItem({
    required this.label,
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final progress = percentage.clamp(0, 100);
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.color.outlineVariant,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          flex: 3,
          child: Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: LinearProgressIndicator(
                    value: progress / 100,
                    minHeight: 6.h,
                    color: color,
                    backgroundColor: color.withValues(alpha: 0.1),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              SizedBox(
                width: 32.w,
                child: Text(
                  '$progress%',
                  textAlign: TextAlign.end,
                  style: context.textTheme.labelSmall?.copyWith(fontSize: 11),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
