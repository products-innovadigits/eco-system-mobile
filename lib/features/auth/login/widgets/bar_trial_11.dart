import 'package:eco_system/features/objective_details/model/objective_chart_month_model.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../helpers/styles.dart';

class BarChartTrial11 extends StatelessWidget {
  const BarChartTrial11({required this.list, super.key});

  final List<ObjectiveChartMonthModel> list;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.6,
      child: BarChart(
        BarChartData(
          barTouchData: BarTouchData(
            enabled: false,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (group) => Colors.transparent,
              tooltipPadding: EdgeInsets.zero,
              tooltipMargin: 8,
              getTooltipItem: (
                BarChartGroupData group,
                int groupIndex,
                BarChartRodData rod,
                int rodIndex,
              ) {
                return BarTooltipItem(
                  rod.toY.round().toString(),
                  const TextStyle(
                    color: Colors.cyan,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (i, t) => SideTitleWidget(
                  meta: t,
                  space: 4,
                  child: Text("",
                      style: AppTextStyles.w400
                          .copyWith(fontSize: 12, color: Styles.PRIMARY_COLOR)),
                ),
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (i, t) => SideTitleWidget(
                  meta: t,
                  space: 4,
                  child: Text("$i",
                      style: AppTextStyles.w400
                          .copyWith(fontSize: 12, color: Styles.PRIMARY_COLOR)),
                ),
              ),
            ),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          barGroups: List.generate(
              list.length,
              (i) => BarChartGroupData(
                    x: (list[i].value ?? 0).ceil(),
                    barRods: [
                      BarChartRodData(
                        toY: 50000000,
                        gradient: LinearGradient(
                          colors: [
                            Colors.black,
                            Colors.black,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      )
                    ],
                    showingTooltipIndicators: [0],
                  )),
          gridData: const FlGridData(show: false),
          alignment: BarChartAlignment.spaceAround,
        ),
      ),
    );
  }
}
