import 'package:eco_system/features/project_categories_progress/model/project_progress_model.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../helpers/styles.dart';

class ProjectCategoryHBarChart extends StatefulWidget {
  const ProjectCategoryHBarChart(
      {super.key,
      this.withIntervals = true,
      required this.data,
      this.textColor,
      this.barColor});
  final List<ProjectProgressModel> data;
  final Color? textColor, barColor;
  final bool withIntervals;

  @override
  State<ProjectCategoryHBarChart> createState() =>
      _ProjectCategoryHBarChartState();
}

class _ProjectCategoryHBarChartState extends State<ProjectCategoryHBarChart> {
  double? interval;

  @override
  void initState() {
    super.initState();
    interval = 20;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: AspectRatio(
        aspectRatio: 1.2,
        child: BarChart(
          BarChartData(
            minY: 0,
            maxY: 100,
            barTouchData: BarTouchData(
              handleBuiltInTouches: true,
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (touchedSpot) =>
                    Styles.PRIMARY_COLOR.withOpacity(0.1),
              ),
            ),
            rotationQuarterTurns: 3,
            titlesData: FlTitlesData(
              show: true,
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  maxIncluded: true,
                  minIncluded: true,
                  showTitles: true,
                  reservedSize: 35,
                  getTitlesWidget: leftTitles,
                  interval: interval,
                ),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(
                  maxIncluded: true,
                  minIncluded: true,
                  showTitles: false,
                  reservedSize: 50,
                  getTitlesWidget: leftTitles,
                  interval: interval,
                ),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) => bottomTitles(value, meta,
                      widget.data.map((e) => "${e.name ?? ""}").toList(),
                      textColor: widget.textColor),
                  reservedSize: 60,
                  interval: interval,
                ),
              ),
            ),
            borderData: FlBorderData(
              border: Border.all(color: Colors.transparent),
            ),
            gridData: FlGridData(
                horizontalInterval: interval,
                show: widget.withIntervals,
                drawVerticalLine: false,
                drawHorizontalLine: true),
            barGroups: List.generate(
              widget.data.length,
              (index) => BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                      fromY: 0,
                      toY: widget.data[index].progress ?? 0,
                      width: 30,
                      color: widget.barColor ??
                          Styles.projectCategoryColors[index],
                      backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          color: Styles.LIGHT_GREY_BORDER,
                          fromY: widget.data[index].progress ?? 0,
                          toY: 100),
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(2),
                          topLeft: Radius.circular(2))),
                ],
              ),
            ).toList(),
          ),
        ),
      ),
    );
  }
}

Widget bottomTitles(double value, TitleMeta meta, List<String> bottomTilesData,
    {Color? textColor}) {
  final Widget text = Text(
    bottomTilesData[value.toInt()],
    textAlign: TextAlign.center,
    style: AppTextStyles.w400.copyWith(
      color: textColor ?? Styles.projectCategoryColors[value.toInt()],
      fontSize: 12,
    ),
  );

  return SideTitleWidget(
    // axisSide: meta.axisSide,
    space: 12,
    meta: meta,
    child: text,
  );
}

Widget leftTitles(double value, TitleMeta meta) {
  final formattedValue = (value).toStringAsFixed(0);
  final Widget text = Text(
    formattedValue + "%",
    style: AppTextStyles.w400.copyWith(
      color: Styles.ACCENT_PRIMARY_COLOR,
      fontSize: 12,
    ),
  );

  return SideTitleWidget(
    space: 16,
    meta: meta,
    child: text,
  );
}
