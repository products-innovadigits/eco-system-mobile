

import '../../shared/strategy_exports.dart';

class ObjectivePercentageSection extends StatelessWidget {
  const ObjectivePercentageSection({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ObjectiveCategorizedBloc()..add(Click()),
        ),
        BlocProvider(
          create: (context) => ObjectivePercentageBloc()..add(Click()),
        ),
      ],
      child: BlocBuilder<ObjectiveCategorizedBloc, AppState>(
        builder: (context, state) {
          if (state is Done) {
            List<ObjectivePercentageModel> objectives =
                state.list as List<ObjectivePercentageModel>;
            return Container(
              width: context.w,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              decoration: BoxDecoration(
                  color: context.color.surfaceContainer,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: context.color.outline)),
              child: Column(
                children: [
                  SectionTitle(
                    title: allTranslations.text(LocaleKeys.objective_percentage_rate),
                    withView: true,
                    onViewTap: () => CustomNavigator.push(Routes.OBJECTIVES),
                  ),
                  Divider(color: context.color.outline),
                  SizedBox(height: 12.h),
                  ObjectivePercentageChart(objectives: objectives),
                  SizedBox(height: 12.h),
                  Wrap(
                    alignment: WrapAlignment.start,
                    direction: Axis.horizontal,
                    runSpacing: 8.w,
                    spacing: 24.h,
                    children: List.generate(
                        objectives.length,
                        (i) => Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.circle,
                                  color: Styles.statusColors(
                                      objectives[i].categoryName ?? ""),
                                  size: 14,
                                ),
                                SizedBox(width: 4.w),
                                Flexible(
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      text: objectives[i].categoryName,
                                      style: context.textTheme.bodyMedium,
                                      children: [
                                        // TextSpan(
                                        //   text: " ${78}",
                                        //   style: AppTextStyles.w400.copyWith(
                                        //       fontSize: 12,
                                        //       color: Styles.DETAILS),
                                        // )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )),
                  )
                ],
              ),
            );
          }
          if (state is Loading) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: CustomShimmerContainer(
                height: context.h * 0.2,
                width: context.w,
              ),
            );
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}
