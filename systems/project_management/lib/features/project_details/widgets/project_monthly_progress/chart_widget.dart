import '../../../../core/utility/pms_exports.dart';

class MonthlyProgressChart extends StatelessWidget {
  final List<ProgressItem> data;
  final double chartWidth;

  const MonthlyProgressChart({
    super.key,
    required this.data,
    required this.chartWidth,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: chartWidth,
      child: Padding(
        padding: EdgeInsets.only(right: 8.w),
        child: LineChart(
          LineChartData(
            minX: -0.5,
            maxX: (data.length - 1).toDouble() + 0.5,
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
              show: false, // Hide all titles on the chart itself
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: List.generate(
                  data.length,
                  (i) => FlSpot(i.toDouble(), data[i].progress ?? 0),
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
    );
  }
}
