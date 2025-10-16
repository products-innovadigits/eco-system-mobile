import 'dart:math' as math;

import 'package:pms_system/shared/pms_exports.dart';

class ProjectMonthlyProgress extends StatefulWidget {
  const ProjectMonthlyProgress({super.key, required this.data});

  final List<ProjectCategoriesProgressModel> data;

  @override
  State<ProjectMonthlyProgress> createState() => _ProjectMonthlyProgressState();
}

class _ProjectMonthlyProgressState extends State<ProjectMonthlyProgress> {
  double? interval;

  @override
  void initState() {
    interval = 20;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return const SizedBox.shrink();
    }

    final List<ProjectCategoriesProgressModel> reversedData = widget
        .data
        .reversed
        .toList();
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double perPointWidth = 60.w;
    final double chartWidth = math.max(
      screenWidth,
      reversedData.length * perPointWidth,
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: screenWidth),
        child: SizedBox(
          width: chartWidth,
          child: AspectRatio(
            aspectRatio: reversedData.length > 6 ? 2.5 : 1.6,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: LineChart(
                LineChartData(
                  minX: -0.5,
                  maxX: (reversedData.length - 1).toDouble() + 0.5,
                  clipData: FlClipData.none(),
                  gridData: FlGridData(
                    horizontalInterval: 20,
                    show: true,
                    drawVerticalLine: false,
                    drawHorizontalLine: true,
                  ),
                  minY: 0,
                  maxY: 105,
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(
                        maxIncluded: false,
                        minIncluded: true,
                        showTitles: true,
                        reservedSize: 60,
                        getTitlesWidget: leftTitles,
                        interval: interval,
                      ),
                    ),
                    leftTitles: AxisTitles(
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
                        getTitlesWidget: (value, meta) => bottomTitles(
                          value,
                          meta,
                          reversedData.map((e) => e.name ?? "").toList(),
                        ),
                        reservedSize: 30,
                        interval: 1,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(
                        reversedData.length,
                        (i) =>
                            FlSpot(i.toDouble(), reversedData[i].progress ?? 0),
                      ),
                      isCurved: false,
                      gradient: LinearGradient(
                        colors: [
                          context.color.primary,
                          context.color.primary.withValues(alpha: 0.2),
                        ],
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            context.color.primary.withValues(alpha: 0.1),
                            Colors.transparent,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      barWidth: 4,
                      isStrokeCapRound: true,
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          return LineTooltipItem(
                            '${spot.y.toInt()}%',
                            TextStyle(color: Colors.white, fontSize: 14),
                          );
                        }).toList();
                      },
                    ),
                    handleBuiltInTouches: true,
                    touchSpotThreshold: 30,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget bottomTitles(
    double value,
    TitleMeta meta,
    List<String> bottomTilesData,
  ) {
    final int index = value.round();
    final String label = (index >= 0 && index < bottomTilesData.length)
        ? bottomTilesData[index]
        : '';
    final Widget text = Text(
      label,
      textAlign: TextAlign.center,
      style: context.textTheme.bodySmall?.copyWith(
        color: context.color.outlineVariant,
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
      "$formattedValue%",
      style: context.textTheme.bodySmall?.copyWith(
        color: context.color.outlineVariant,
      ),
    );

    return SideTitleWidget(space: 16, meta: meta, child: text);
  }
}
