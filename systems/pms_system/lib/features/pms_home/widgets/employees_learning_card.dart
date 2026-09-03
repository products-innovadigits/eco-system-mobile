import 'package:pms_system/features/employees_learning/bloc/employees_learning_bloc.dart';
import 'package:pms_system/features/employees_learning/bloc/employees_learning_states.dart';
import 'package:pms_system/features/employees_learning/model/employees_learning_model.dart';
import 'package:pms_system/features/pms_home/widgets/home_card_state_message.dart';

import '../../../core/utility/pms_exports.dart';

class EmployeesLearningCard extends StatelessWidget {
  const EmployeesLearningCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeesLearningBloc, EmployeesLearningState>(
      builder: (context, state) {
        final hasData = state is EmployeesLoaded && state.employees.isNotEmpty;
        final onTap = !hasData
            ? null
            : () => CustomNavigator.push(Routes.EMPLOYEES_LEARNING);
        return state is! EmployeesFailure
            ? InkWell(
                onTap: onTap,
                child: Container(
                  width: context.w,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  decoration: BoxDecoration(
                    color: context.color.surfaceContainer,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: context.color.outline),
                  ),
                  child: Column(
                    children: [
                      SectionTitle(
                        title: allTranslations.text(
                          LocaleKeys.employees_leaning,
                        ),
                        icon: Assets.svgs.tripleUser.path,
                        withView: hasData,
                        onViewTap: onTap,
                      ),
                      Divider(color: context.color.outline),
                      SizedBox(height: 12.h),
                      switch (state) {
                        EmployeesLoading() => const _ShimmerContent(),
                        EmployeesLoaded(:final employees, :final totalCount)
                            when employees.isNotEmpty =>
                          _LoadedContent(
                            employees: employees,
                            totalCount: totalCount,
                          ),
                        // EmployeesFailure(:final message) => HomeCardStateMessage(
                        //   message: message,
                        //   isError: true,
                        // ),
                        EmployeesLoaded() ||
                        EmployeesEmpty() => HomeCardStateMessage(
                          message: allTranslations.text(
                            LocaleKeys.no_employees_found,
                          ),
                        ),
                        _ => const SizedBox.shrink(),
                      },
                    ],
                  ),
                ),
              )
            : const SizedBox.shrink();
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
            CustomShimmerText(width: 80.w),
            SizedBox(height: 8.h),
            CustomShimmerText(width: 30.w),
          ],
        ),
        Row(
          children: List.generate(
            4,
            (index) => Padding(
              padding: EdgeInsets.only(left: index == 0 ? 0 : 4.w),
              child: CustomShimmerCircleImage(radius: 32.w),
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

  const _LoadedContent({required this.employees, required this.totalCount});

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
            SizedBox(height: 4.h),
            Text(
              totalCount.toString(),
              style: context.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        if (employees.isNotEmpty)
          _EmployeesAvatarStack(employees: employees, totalCount: totalCount),
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

  @override
  Widget build(BuildContext context) {
    final visibleCount = employees.length > _maxVisible
        ? _maxVisible
        : employees.length;
    final hasOverflow = totalCount > _maxVisible;

    return Stack(
      textDirection: TextDirection.ltr,
      children: List.generate(visibleCount, (index) {
        final employee = employees[index];
        final isLast = index == _maxVisible - 1 && hasOverflow;

        return Container(
          width: 32.w,
          height: 32.h,
          margin: index == 0
              ? EdgeInsets.only(left: 0)
              : EdgeInsets.only(left: index * 17.w),
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
                        fontSize: (totalCount - _maxVisible) > 99 ? 10 : 11,
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
                      fontSize: 10,
                    ),
                  ),
                ),
        );
      }),
    );
  }
}
