

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
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                  color: Styles.WHITE_COLOR,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Styles.LIGHT_GREY_BORDER)),
              child: Column(
                children: [
                  SectionTitle(
                    title: allTranslations.text(LocaleKeys.objective_percentage_rate),
                    withView: true,
                    onViewTap: () => CustomNavigator.push(Routes.OBJECTIVES),
                  ),
                  Divider(color: Styles.BORDER_COLOR),
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
                                  size: 16,
                                ),
                                SizedBox(width: 4.w),
                                Flexible(
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      text: objectives[i].categoryName,
                                      style: AppTextStyles.w400.copyWith(
                                          fontFamily: 'ar',
                                          fontSize: 12,
                                          color: Styles.HEADER),
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
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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
