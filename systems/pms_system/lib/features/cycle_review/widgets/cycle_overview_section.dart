import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/cycle_review/model/cycle_review_model.dart';

class CycleOverviewSection extends StatelessWidget {
  final CycleDetailDataModel detail;

  const CycleOverviewSection({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    final roleGroups = detail.roleGroups ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          allTranslations.text(LocaleKeys.cycle_overview),
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        // SizedBox(height: 14.h),
        // Row(
        //   children: [
        //     Expanded(
        //       child: _StatCard(
        //         icon: Icons.star_rounded,
        //         iconColor: LightColor.secondary,
        //         label: allTranslations.text(LocaleKeys.total_score),
        //         value: '${detail.totalScore?.toInt() ?? 0}%',
        //       ),
        //     ),
        //     SizedBox(width: 12.w),
        //     Expanded(
        //       child: _RevieweesStatCard(count: detail.revieweesCount ?? 0),
        //     ),
        //   ],
        // ),
        // SizedBox(height: 16.h),
        ...roleGroups.map(
          (group) => Padding(
            padding: EdgeInsets.only(bottom: 4.r),
            child: _RoleGroupItem(group: group),
          ),
        ),
      ],
    );
  }
}

class _RoleGroupItem extends StatelessWidget {
  final CycleRoleGroupModel group;

  const _RoleGroupItem({required this.group});

  IconData _iconForRole(String? role) {
    switch (role) {
      case 'Managers':
        return Icons.assignment_ind_outlined;
      case 'Direct Reports':
        return Icons.people_outline;
      case 'Peers':
        return Icons.groups_outlined;
      default:
        return Icons.person_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: context.color.outline, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Icon(_iconForRole(group.role), size: 20.r, color: LightColor.primary),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${group.count ?? 0} ${group.role ?? ''}',
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  '${allTranslations.text(LocaleKeys.due).toUpperCase()} ${group.dueDate ?? ''}',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.color.outlineVariant,
                    fontSize: FontSizes.f10,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.calendar_today, color: context.color.outlineVariant),
        ],
      ),
    );
  }
}
