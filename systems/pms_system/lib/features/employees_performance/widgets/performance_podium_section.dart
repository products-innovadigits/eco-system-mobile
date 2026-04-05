import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/employees_performance/model/employees_performance_model.dart';

class PerformancePodiumSection extends StatelessWidget {
  final List<PerformanceEmployeeModel> topEmployees;

  const PerformancePodiumSection({super.key, required this.topEmployees});

  @override
  Widget build(BuildContext context) {
    if (topEmployees.isEmpty) return const SizedBox.shrink();

    final first = topEmployees.isNotEmpty ? topEmployees[0] : null;
    final second = topEmployees.length > 1 ? topEmployees[1] : null;
    final third = topEmployees.length > 2 ? topEmployees[2] : null;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: LightColor.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: AlignmentDirectional.topEnd,
            child: InkWell(
              onTap: () =>
                  CustomNavigator.push(Routes.EMPLOYEE_OF_MONTH_HISTORY),
              borderRadius: BorderRadius.circular(8.r),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      allTranslations.text(LocaleKeys.view_history),
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.color.secondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 10,
                      color: context.color.secondary,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (second != null)
                Expanded(
                  child: _PodiumItem(
                    employee: second,
                    rank: 2,
                    avatarSize: 70,
                    podiumHeight: 80,
                    color: const Color(0xffC0C0C0),
                    podiumColor: const Color(0xffF1F5F9),
                  ),
                ),
              if (first != null)
                Expanded(
                  child: _PodiumItem(
                    employee: first,
                    rank: 1,
                    avatarSize: 90,
                    podiumHeight: 120,
                    color: const Color(0xffE6C16B),
                    podiumColor: const Color(0xffFFF9E6),
                    isFirst: true,
                  ),
                ),
              if (third != null)
                Expanded(
                  child: _PodiumItem(
                    employee: third,
                    rank: 3,
                    avatarSize: 70,
                    podiumHeight: 60,
                    color: const Color(0xffCD7F32),
                    podiumColor: const Color(0xffFEF3E6),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PodiumItem extends StatelessWidget {
  final PerformanceEmployeeModel employee;
  final int rank;
  final double avatarSize;
  final double podiumHeight;
  final Color color;
  final Color podiumColor;
  final bool isFirst;

  const _PodiumItem({
    required this.employee,
    required this.rank,
    required this.avatarSize,
    required this.podiumHeight,
    required this.color,
    required this.podiumColor,
    this.isFirst = false,
  });

  String get _rankLabel {
    switch (rank) {
      case 1:
        return '1st';
      case 2:
        return '2nd';
      case 3:
        return '3rd';
      default:
        return '${rank}th';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: avatarSize + 4,
          height: avatarSize + 4,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                width: avatarSize,
                height: avatarSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 4),
                ),
                child: CustomNetworkImage.circleNewWorkImage(
                  radius: avatarSize,
                  backGroundColor: context.color.primary,
                  padding: EdgeInsets.all(4),
                ),
              ),
              PositionedDirectional(
                top: -4,
                end: -2,
                child: Container(
                  width: 28.w,
                  height: 28.w,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$rank',
                    style: context.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              PositionedDirectional(
                bottom: -8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${employee.percentage?.toStringAsFixed(1) ?? '0'}%',
                    style: context.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 14.h),
        Text(
          employee.name ?? '',
          style: isFirst
              ? context.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: context.color.onSurface,
                )
              : context.textTheme.bodySmall?.copyWith(
                  color: context.color.onSurface,
                ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 2.h),
        Text(
          employee.jobTitle ?? '',
          style: context.textTheme.bodySmall?.copyWith(
            color: LightColor.grey,
            fontSize: 10,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          height: podiumHeight.h,
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            color: podiumColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            _rankLabel,
            style: context.textTheme.titleLarge?.copyWith(
              color: color.withOpacity(0.6),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
