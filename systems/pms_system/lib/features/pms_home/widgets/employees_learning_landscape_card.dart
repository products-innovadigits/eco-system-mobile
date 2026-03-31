import 'package:pms_system/features/employees_learning/bloc/employees_learning_bloc.dart';
import 'package:pms_system/features/employees_learning/bloc/employees_learning_states.dart';
import 'package:pms_system/features/employees_learning/model/employees_learning_model.dart';

import '../../../core/utility/pms_exports.dart';

class EmployeesLearningLandscapeCard extends StatelessWidget {
  const EmployeesLearningLandscapeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeesLearningBloc, EmployeesLearningState>(
      builder: (context, state) {
        return InkWell(
          onTap: () => CustomNavigator.push(Routes.EMPLOYEES_LEARNING),
          child: Container(
            width: context.w,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: context.color.surfaceContainer,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: context.color.outline),
            ),
            child: Column(
              children: [
                SectionTitle(
                  title: allTranslations.text(LocaleKeys.employees_leaning),
                  icon: Assets.svgs.tripleUser.path,
                  onViewTap: () =>
                      CustomNavigator.push(Routes.EMPLOYEES_LEARNING),
                ),
                Divider(color: context.color.outline),
                SizedBox(height: 8),
                switch (state) {
                  EmployeesLoading() => const _ShimmerContent(),
                  EmployeesLoaded(:final employees, :final totalCount) =>
                    _LoadedContent(
                      employees: employees,
                      totalCount: totalCount,
                    ),
                  _ => const SizedBox.shrink(),
                },
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ShimmerContent extends StatelessWidget {
  const _ShimmerContent();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomShimmerText(width: 80),
            SizedBox(height: 6),
            CustomShimmerText(width: 30),
          ],
        ),
        Row(
          children: List.generate(
            4,
            (index) => Padding(
              padding: EdgeInsets.only(left: index == 0 ? 0 : 4),
              child: CustomShimmerCircleImage(radius: 28),
            ),
          ),
        ),
      ],
    );
  }
}

class _LoadedContent extends StatelessWidget {
  final List<EmployeeItemModel> employees;
  final int totalCount;

  const _LoadedContent({
    required this.employees,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              allTranslations.text(LocaleKeys.employee_numbers),
              style: context.textTheme.bodySmall?.copyWith(
                color: context.color.outlineVariant,
              ),
            ),
            SizedBox(height: 4),
            Text(
              totalCount.toString(),
              style: context.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        if (employees.isNotEmpty)
          _EmployeesAvatarStack(
            employees: employees,
            totalCount: totalCount,
          ),
      ],
    );
  }
}

class _EmployeesAvatarStack extends StatelessWidget {
  final List<EmployeeItemModel> employees;
  final int totalCount;

  const _EmployeesAvatarStack({
    required this.employees,
    required this.totalCount,
  });

  static const int _maxVisible = 5;
  static const double _avatarSize = 28;

  @override
  Widget build(BuildContext context) {
    final visibleCount =
        employees.length > _maxVisible ? _maxVisible : employees.length;
    final hasOverflow = totalCount > _maxVisible;

    return Stack(
      textDirection: TextDirection.ltr,
      children: List.generate(visibleCount, (index) {
        final employee = employees[index];
        final isLast = index == _maxVisible - 1 && hasOverflow;

        return Container(
          width: _avatarSize,
          height: _avatarSize,
          margin: index == 0
              ? EdgeInsets.only(left: 0)
              : EdgeInsets.only(left: index * 15),
          decoration: BoxDecoration(
            color: context.color.primary,
            shape: BoxShape.circle,
            border: Border.all(color: context.color.surfaceContainer),
          ),
          child: isLast
              ? Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '+${totalCount - _maxVisible}',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.color.onPrimary,
                        fontSize: (totalCount - _maxVisible) > 99 ? 9 : 10,
                      ),
                    ),
                  ),
                )
              : Center(
                  child: Text(
                    employee.initials ?? '',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.color.onPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 9,
                    ),
                  ),
                ),
        );
      }),
    );
  }
}
