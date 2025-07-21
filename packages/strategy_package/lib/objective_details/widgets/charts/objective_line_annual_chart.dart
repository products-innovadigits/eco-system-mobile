import '../../../shared/strategy_exports.dart';

class ObjectiveLineAnnualChart extends StatelessWidget {
  const ObjectiveLineAnnualChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ObjectiveChartAnnualBloc, AppState>(
      builder: (context, state) {
        if (state is Done) {
          List<ObjectiveChartModel> list =
              state.list as List<ObjectiveChartModel>;
          return Column(
            children: [
              // ObjectiveLineChart(data: list),
              // ObjectiveBarChartSyncfusion(data: list),
              ObjectiveBarChartSyncfusion(data: [
                ObjectiveChartModel(
                  objectValue: 60,
                  kpisValue: 30,
                  initiativesValue: 30,
                  year: 2025
                ),
                // ObjectiveChartModel(
                //   objectValue: 80,
                //   kpisValue: 50,
                //   initiativesValue: 30,
                //   year: 2026
                // ),
                // ObjectiveChartModel(
                //   objectValue: 100,
                //   kpisValue: 70,
                //   initiativesValue: 30,
                //   year: 2027
                // ),
              ]),
              Wrap(
                alignment: WrapAlignment.start,
                direction: Axis.horizontal,
                runSpacing: 8.w,
                spacing: 24.h,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.circle,
                        color: context.color.secondary,
                        size: 14,
                      ),
                      SizedBox(width: 4.w),
                      Flexible(
                        child: Text(
                          allTranslations.text(LocaleKeys.objectives),
                          style: context.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.circle,
                        color: context.color.primary,
                        size: 14,
                      ),
                      SizedBox(width: 4.w),
                      Flexible(
                        child: Text(
                          allTranslations.text(LocaleKeys.initiatives),
                          style: context.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.circle,
                        color: context.color.tertiary,
                        size: 14,
                      ),
                      SizedBox(width: 4.w),
                      Flexible(
                        child: Text(
                          allTranslations.text("kpis"),
                          style: context.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),


                ],
              ),
            ],
          );
        }
        if (state is Loading) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
            child: CustomShimmerContainer(height: 200.h, width: context.w),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
