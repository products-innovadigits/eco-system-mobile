import 'package:eco_system/helpers/text_styles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../helpers/styles.dart';
import '../../model/objective_chart_model.dart';

class ObjectiveBarChart extends StatefulWidget {
  const ObjectiveBarChart({super.key, required this.data});
  final List<ObjectiveChartModel> data;

  @override
  State<ObjectiveBarChart> createState() => _ObjectiveBarChartState();
}

class _ObjectiveBarChartState extends State<ObjectiveBarChart> {
  late double interval;

  @override
  void initState() {
    super.initState();
    interval = 10;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: BarChart(
        BarChartData(
          titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => bottomTitles(value, meta,
                    widget.data.map((e) => "${e.month ?? ""}").toList()),
                reservedSize: 40,
                // interval: interval,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                maxIncluded: false,
                minIncluded: false,
                showTitles: true,
                // reservedSize: 0,
                reservedSize: 40,
                getTitlesWidget: leftTitles,
                interval: interval,
              ),
            ),
          ),
          borderData: FlBorderData(
            border: const Border(
              top: BorderSide.none,
              right: BorderSide.none,
              left: BorderSide(width: 1, color: Colors.transparent),
              bottom: BorderSide(width: 1, color: Styles.LIGHT_GREY_BORDER),
            ),
          ),
          gridData: FlGridData(
              horizontalInterval: 5,
              show: true,
              drawVerticalLine: false,
              drawHorizontalLine: true),
          barGroups: List.generate(
            widget.data.length,
            (index) => BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                    toY: widget.data[index].objectValue ?? 0,
                    width: 30,
                    color: (widget.data[index].objectValue ?? 0) >=
                            (widget.data
                                    .map((e) => e.objectValue ?? 0)
                                    .toList())
                                .reduce((a, b) => a > b ? a : b)
                        ? Styles.PRIMARY_COLOR
                        : Styles.ACCENT_PRIMARY_COLOR,
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10))),
              ],
            ),
          ).toList(),
        ),
      ),
    );
  }
}

Widget bottomTitles(
    double value, TitleMeta meta, List<String> bottomTilesData) {
  final Widget text = Text(
    bottomTilesData[value.toInt()],
    style: AppTextStyles.w400.copyWith(
      color: Styles.ACCENT_PRIMARY_COLOR,
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
