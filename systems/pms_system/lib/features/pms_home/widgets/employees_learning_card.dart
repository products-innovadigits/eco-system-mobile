import '../../../core/utility/pms_exports.dart';

class EmployeesLearningCard extends StatelessWidget {
  const EmployeesLearningCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => CustomNavigator.push(Routes.EMPLOYEES_LEARNING),
      child: Container(
        width: context.w,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
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
              onViewTap: () => CustomNavigator.push(Routes.EMPLOYEES_LEARNING),
            ),
            Divider(color: context.color.outline),
            SizedBox(height: 12.h),
            Row(
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
                      9.toString(),
                      style: context.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Stack(
                  textDirection: TextDirection.ltr,
                  children: List.generate(
                    [1, 1, 1, 1, 1, 1, 1, 1, 1].length > 5
                        ? 5
                        : [1, 1, 1, 1, 1, 1, 1, 1, 1].length,
                    (index) => Container(
                      width: 32.w,
                      height: 32.h,
                      margin: index == 0
                          ? EdgeInsets.only(left: 0)
                          : EdgeInsets.only(left: index * 17.w),
                      decoration: BoxDecoration(
                        color: context.color.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: context.color.surfaceContainer,
                        ),
                      ),
                      child:
                          (index == 4 && [1, 1, 1, 1, 1, 1, 1, 1, 1].length > 5)
                          ? Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '+${9 - 5}',
                                  style: context.textTheme.bodySmall?.copyWith(
                                    color: context.color.onPrimary,
                                    fontSize: 9 > 99 ? 10 : 11,
                                  ),
                                ),
                              ),
                            )
                          : CustomNetworkImage.circleNewWorkImage(
                              backGroundColor: context.color.primary,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
