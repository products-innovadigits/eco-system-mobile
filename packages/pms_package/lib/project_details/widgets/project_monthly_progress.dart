import 'package:pms_package/shared/pms_exports.dart';

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
    return AspectRatio(
      aspectRatio: 1.3,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
                horizontalInterval: 20,
                show: true,
                drawVerticalLine: false,
                drawHorizontalLine: true),
            minY: 0,
            maxY: 100,
            titlesData: FlTitlesData(
              show: true,
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  maxIncluded: true,
                  minIncluded: true,
                  showTitles: true,
                  reservedSize: 50,
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
                  getTitlesWidget: (value, meta) => bottomTitles(
                    value,
                    meta,
                    widget.data.map((e) => e.name ?? "").toList(),
                  ),
                  reservedSize: 30,
                  interval: 1,
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: List.generate(
              widget.data.length,
              (index) => LineChartBarData(
                spots: List.generate(
                    widget.data.length,
                    (i) => FlSpot(double.parse(i.toString()),
                        widget.data[i].progress ?? 0)),
                isCurved: false,
                gradient: LinearGradient(
                  colors: [context.color.primary, context.color.primary.withValues(alpha: 0.2)],
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
            ).toList(),
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((spot) {
                    if (spot.barIndex == spot.spotIndex) {
                      return LineTooltipItem(
                        '${spot.y.toInt()}%',
                        TextStyle(color: Colors.white, fontSize: 14),
                      );
                    }
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

  Widget bottomTitles(
      double value, TitleMeta meta, List<String> bottomTilesData) {
    final Widget text = Text(
      bottomTilesData[value.toInt()],
      textAlign: TextAlign.center,
      style: context.textTheme.bodySmall?.copyWith(color: context.color.outlineVariant)
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
      style: context.textTheme.bodySmall?.copyWith(color: context.color.outlineVariant)
    );

    return SideTitleWidget(
      space: 16,
      meta: meta,
      child: text,
    );
  }
}
