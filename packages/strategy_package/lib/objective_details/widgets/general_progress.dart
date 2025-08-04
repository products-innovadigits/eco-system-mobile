import 'package:core_package/core/helpers/font_sizes.dart';
import 'package:strategy_package/objective_details/model/general_progress_chart_model.dart';
import 'package:strategy_package/objective_details/widgets/charts/general_progress_chart.dart';

import '../../shared/strategy_exports.dart';
import '../../shared/widgets/monthly_annaul_chart_filter_widget.dart';

class GeneralProgress extends StatefulWidget {
  const GeneralProgress({super.key});

  @override
  State<GeneralProgress> createState() => _GeneralProgressState();
}

class _GeneralProgressState extends State<GeneralProgress> {
  ChartTime currentTime = ChartTime.Month;

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
                  allTranslations.text(LocaleKeys.general_progress),
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
          currentTime == ChartTime.Month
              ? GeneralProgressChart(
                  isMonthly: true,
                  data: GeneralProgressChartModel(
                    actual: [
                      YearPercent(month: 2, value: 30),
                      YearPercent(month: 4, value: 60),
                      YearPercent(month: 7, value: 35),
                      YearPercent(month: 9, value: 10),
                      YearPercent(month: 12, value: 15),
                    ],
                    all: [
                      YearPercent(month: 1, value: 18),
                      YearPercent(month: 2, value: 40),
                      YearPercent(month: 6, value: 15),
                      YearPercent(month: 8, value: 25),
                      YearPercent(month: 11, value: 20),
                    ],
                  ),
                )
              : GeneralProgressChart(
                  data: GeneralProgressChartModel(
                    actual: [
                      YearPercent(year: 2022, value: 30),
                      YearPercent(year: 2023, value: 60),
                      YearPercent(year: 2024, value: 35),
                      YearPercent(year: 2025, value: 10),
                      YearPercent(year: 2026, value: 15),
                    ],
                    all: [
                      YearPercent(year: 2022, value: 18),
                      YearPercent(year: 2023, value: 40),
                      YearPercent(year: 2024, value: 15),
                      YearPercent(year: 2025, value: 25),
                      YearPercent(year: 2026, value: 20),
                    ],
                  ),
                ),
          Wrap(
            alignment: WrapAlignment.start,
            direction: Axis.horizontal,
            runSpacing: 8.w,
            spacing: 24.h,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.circle, color: context.color.secondary, size: 14),
                  SizedBox(width: 4.w),
                  Flexible(
                    child: Text('الكلي', style: context.textTheme.bodySmall),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.circle, color: context.color.primary, size: 14),
                  SizedBox(width: 4.w),
                  Flexible(
                    child: Text('الفعلي', style: context.textTheme.bodySmall),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
