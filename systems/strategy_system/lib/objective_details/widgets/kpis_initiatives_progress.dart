import 'package:core_system/core/helpers/font_sizes.dart';
import 'package:strategy_system/objective_details/widgets/chart_titles_widget.dart';

import '../../shared/strategy_exports.dart';
import '../../shared/widgets/monthly_annaul_chart_filter_widget.dart';

class KpisInitiativesProgress extends StatefulWidget {
  const KpisInitiativesProgress({super.key});

  @override
  State<KpisInitiativesProgress> createState() =>
      _KpisInitiativesProgressState();
}

class _KpisInitiativesProgressState extends State<KpisInitiativesProgress> {
  ChartTime currentTime = ChartTime.month;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: context.color.surfaceContainer,
        border: Border.all(color: context.color.outline),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  allTranslations.text(LocaleKeys.kpis_initiatives_progress),
                  style: context.textTheme.titleLarge?.copyWith(
                    fontSize: FontSizes.f14,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              MonthlyAnnualChartFilterWidget(
                onSelect: (time) {
                  setState(() {
                    currentTime = time;
                  });
                },
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Divider(color: context.color.outline),
          ),
          currentTime == ChartTime.month
              ? ObjectiveLineChart(
                  data: [
                    ObjectiveChartModel(
                      objectValue: 60,
                      kpisValue: 30,
                      initiativesValue: 30,
                      month: 1,
                    ),
                    ObjectiveChartModel(
                      objectValue: 90,
                      kpisValue: 50,
                      initiativesValue: 40,
                      month: 2,
                    ),
                    ObjectiveChartModel(
                      objectValue: 70,
                      kpisValue: 30,
                      initiativesValue: 40,
                      month: 3,
                    ),
                    ObjectiveChartModel(
                      objectValue: 70,
                      kpisValue: 30,
                      initiativesValue: 40,
                      month: 4,
                    ),
                    ObjectiveChartModel(
                      objectValue: 70,
                      kpisValue: 30,
                      initiativesValue: 40,
                      month: 5,
                    ),
                    // ObjectiveChartModel(
                    //   objectValue: 70,
                    //   kpisValue: 30,
                    //   initiativesValue: 40,
                    //   year: 2020,
                    // ),
                  ],
                  isMonthly: true,
                )
              : ObjectiveLineChart(
                  data: [
                    ObjectiveChartModel(
                      objectValue: 60,
                      kpisValue: 30,
                      initiativesValue: 30,
                      year: 2025,
                      month: 1,
                    ),
                    ObjectiveChartModel(
                      objectValue: 90,
                      kpisValue: 50,
                      initiativesValue: 40,
                      year: 2024,
                    ),
                    ObjectiveChartModel(
                      objectValue: 70,
                      kpisValue: 30,
                      initiativesValue: 40,
                      year: 2023,
                    ),
                  ],
                ),
          ChartTitlesWidget(),
        ],
      ),
    );
  }
}
