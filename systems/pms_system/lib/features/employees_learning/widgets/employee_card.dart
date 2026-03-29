import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/employees_learning/model/employees_learning_model.dart';

class EmployeeCard extends StatelessWidget {
  const EmployeeCard({super.key, required this.employee, this.onTap});

  final EmployeeItemModel employee;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:
          onTap ??
          () => CustomNavigator.push(
            Routes.EMPLOYEE_LEARNING_DETAILS,
            arguments: {
              'employeeId': employee.id ?? 0,
              'employeeName': employee.name,
            },
          ),
      borderRadius: BorderRadius.circular(12.w),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: context.color.surfaceContainer,
          border: Border.all(color: context.color.outline),
          borderRadius: BorderRadius.circular(12.w),
        ),
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            _EmployeeHeader(employee: employee),
            SizedBox(height: 16.h),
            _EmployeeInfoGrid(employee: employee),
          ],
        ),
      ),
    );
  }
}

class _EmployeeHeader extends StatelessWidget {
  final EmployeeItemModel employee;

  const _EmployeeHeader({required this.employee});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            color: LightColor.secondary,
            shape: BoxShape.circle,
          ),
          child: employee.imageUrl != null && employee.imageUrl!.isNotEmpty
              ? CustomNetworkImage.circleNewWorkImage(
                  image: employee.imageUrl,
                  backGroundColor: LightColor.secondary,
                )
              : Center(
                  child: Text(
                    employee.initials ?? '',
                    style: context.textTheme.titleSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                employee.name ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                employee.jobTitle ?? '',
                style: context.textTheme.bodySmall?.copyWith(
                  color: LightColor.secondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EmployeeInfoGrid extends StatelessWidget {
  final EmployeeItemModel employee;

  const _EmployeeInfoGrid({required this.employee});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: context.color.surfaceContainer,
        border: Border.all(color: context.color.outline),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _InfoItem(
                  icon: Icons.email_outlined,
                  label: allTranslations.text(LocaleKeys.email).toUpperCase(),
                  value: employee.email ?? '',
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _InfoItem(
                  icon: Icons.phone_outlined,
                  label: allTranslations.text(LocaleKeys.phone).toUpperCase(),
                  value: employee.phone ?? '',
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: _InfoItem(
                  icon: Icons.workspace_premium_outlined,
                  label: allTranslations
                      .text(LocaleKeys.seniority_level)
                      .toUpperCase(),
                  value: employee.seniority ?? '',
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _InfoItem(
                  icon: Icons.groups_outlined,
                  label: allTranslations.text(LocaleKeys.team).toUpperCase(),
                  value: employee.team ?? '',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: context.color.outline,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, size: 16.w, color: context.color.outlineVariant),
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.color.outlineVariant,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 2.h),
              value.isNotEmpty
                  ? Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: FontSizes.f12,
                      ),
                    )
                  : Padding(
                      padding: EdgeInsetsDirectional.only(start: 16.w),
                      child: Text(
                        '--',
                        style: context.textTheme.headlineLarge?.copyWith(
                          fontSize: 14,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
