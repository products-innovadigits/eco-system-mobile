import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../helpers/styles.dart';
import '../../model/objective_chart_model.dart';

class ObjectiveLineChart extends StatelessWidget {
  const ObjectiveLineChart({required this.data});

  final List<ObjectiveChartModel> data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.w,
      height: context.h * 0.45,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(top: 12.h),
        child: AspectRatio(
          aspectRatio: 1.8,
          child: LineChart(
            LineChartData(
              lineTouchData: LineTouchData(
                handleBuiltInTouches: true,
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (touchedSpot) =>
                      Styles.PRIMARY_COLOR.withOpacity(0.1),
                ),
              ),
              gridData: FlGridData(
                  horizontalInterval: 10,
                  show: true,
                  drawVerticalLine: false,
                  drawHorizontalLine: true),
              titlesData: titles,
              borderData: FlBorderData(
                border: const Border(
                  top: BorderSide.none,
                  right: BorderSide.none,
                  left: BorderSide(width: 1, color: Colors.transparent),
                  bottom: BorderSide(width: 1, color: Styles.LIGHT_GREY_BORDER),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  isCurved: true,
                  color: Styles.PRIMARY_COLOR,
                  barWidth: 4,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(show: false),
                  spots: List.generate(data.length,
                      (i) => FlSpot(i.toDouble(), data[i].kpisValue ?? 0)),
                ),
                LineChartBarData(
                  isCurved: true,
                  color: Styles.SECONDARY_COLOR,
                  barWidth: 4,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(show: false),
                  spots: List.generate(
                      data.length,
                      (i) =>
                          FlSpot(i.toDouble(), data[i].initiativesValue ?? 0)),
                ),
              ],
              maxY: 100,
            ),
            duration: const Duration(milliseconds: 250),
          ),
        ),
      ),
    );
  }

  FlTitlesData get titles => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) => bottomTitles(
                value, meta, data.map((e) => "${e.year ?? 0}").toList()),
            reservedSize: 40,
            interval: 1,
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
              maxIncluded: true,
              // minIncluded: true,
              showTitles: false,
              // showTitles: mainAppBloc.lang.valueOrNull == "ar",
              reservedSize: 50,
              getTitlesWidget: leftTitles,
              interval: 20),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
              maxIncluded: true,
              // minIncluded: true,
              showTitles: true,
              // showTitles: mainAppBloc.lang.valueOrNull == "en",
              reservedSize: 50,
              getTitlesWidget: leftTitles,
              interval: 20),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

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

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('SEPT', style: style);
        break;
      case 7:
        text = const Text('OCT', style: style);
        break;
      case 12:
        text = const Text('DEC', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      meta: meta,
      space: 10,
      child: text,
    );
  }

  FlGridData get gridData => const FlGridData(show: false);
}
