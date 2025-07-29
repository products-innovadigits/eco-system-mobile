import 'package:core_package/core/helpers/font_sizes.dart';

import '../../../shared/strategy_exports.dart';

class KpisInitiativesProgressChart extends StatefulWidget {
  const KpisInitiativesProgressChart({super.key});

  @override
  State<KpisInitiativesProgressChart> createState() =>
      _KpisInitiativesProgressChartState();
}

class _KpisInitiativesProgressChartState
    extends State<KpisInitiativesProgressChart> {
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
                  allTranslations.text(LocaleKeys.kpis_initiatives_progress),
                  style: context.textTheme.titleLarge?.copyWith(
                    fontSize: FontSizes.f14,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              PopupMenuButton<ChartTime>(
                initialValue: currentTime,
                onSelected: (ChartTime time) {
                  setState(() => currentTime = time);
                },

                itemBuilder: (BuildContext ctx) {
                  return ChartTime.values.map((ChartTime time) {
                    return PopupMenuItem<ChartTime>(
                      value: time,
                      child: Text(
                        allTranslations.text(time.name),
                        style: context.textTheme.labelSmall,
                      ),
                    );
                  }).toList();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 4.h,
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 6.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: context.color.surfaceContainer,
                    border: Border.all(color: context.color.outline),
                  ),
                  child: Row(
                    children: [
                      Text(
                        allTranslations.text(currentTime.name),
                        style: context.textTheme.bodySmall,
                      ),
                      8.sw,
                      Images(
                        image: Assets.svgs.arrowDown.path,
                        width: 6,
                        height: 6,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Divider(color: context.color.outline),
          ),
          currentTime == ChartTime.Month
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
                  Icon(Icons.circle, color: context.color.primary, size: 14),
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
                  Icon(Icons.circle, color: context.color.tertiary, size: 14),
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
      ),
    );
  }
}
