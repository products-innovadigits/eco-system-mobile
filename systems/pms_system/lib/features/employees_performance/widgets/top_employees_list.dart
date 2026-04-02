import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/employees_performance/bloc/employees_performance_bloc.dart';
import 'package:pms_system/features/employees_performance/bloc/employees_performance_events.dart';
import 'package:pms_system/features/employees_performance/model/employees_performance_model.dart';

class TopEmployeesList extends StatelessWidget {
  final List<PerformanceEmployeeModel> employees;

  const TopEmployeesList({super.key, required this.employees});

  @override
  Widget build(BuildContext context) {
    if (employees.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            allTranslations.text(LocaleKeys.top_10),
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: context.color.onSurface,
            ),
          ),
          SizedBox(height: 12.h),
          ...employees.map((e) => _TopEmployeeCard(employee: e)),
        ],
      ),
    );
  }
}

class _TopEmployeeCard extends StatelessWidget {
  final PerformanceEmployeeModel employee;

  const _TopEmployeeCard({required this.employee});

  String get _rankEmoji {
    switch (employee.rank) {
      case 1:
        return '\u{1F947}';
      case 2:
        return '\u{1F948}';
      case 3:
        return '\u{1F949}';
      default:
        return '${employee.rank}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsetsDirectional.only(
        start: employee.rank!.toInt() > 3 ? 16.w : 6.w,
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
          Text(
            _rankEmoji,
            style: context.textTheme.bodyLarge?.copyWith(
              fontSize: employee.rank!.toInt() > 3 ? 16 : 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          employee.rank!.toInt() > 3
              ? SizedBox(width: 10.w)
              : SizedBox(width: 6.w),
          CustomNetworkImage.circleNewWorkImage(
            radius: 25,
            backGroundColor: context.color.primary,
            padding: EdgeInsets.all(2),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  employee.name ?? '',
                  style: context.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.color.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  employee.jobTitle ?? '',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: LightColor.grey,
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (employee.reviewCycleName != null) ...[
                  SizedBox(height: 2.h),
                  Text(
                    employee.reviewCycleName!,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: LightColor.grey,
                      fontSize: 10,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: LightColor.secondary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${employee.percentage?.toStringAsFixed(1) ?? '0'}%',
                  style: context.textTheme.labelSmall?.copyWith(
                    color: LightColor.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(
                  Icons.category_outlined,
                  color: LightColor.white,
                  size: 14,
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          InkWell(
            onTap: () {
              context
                  .read<EmployeesPerformanceBloc>()
                  .add(SetEmployeeOfTheMonth(employee: employee));
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: context.color.secondary.withValues(alpha: 0.1),
                border: Border.all(color: LightColor.border),
              ),
              child: Text(
                allTranslations.text(LocaleKeys.make_top_1),
                style: context.textTheme.labelSmall?.copyWith(
                  color: context.color.secondary,
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
