import 'package:pms_package/shared/pms_exports.dart';

class ProjectCategoryHBarChart extends StatefulWidget {
  const ProjectCategoryHBarChart(
      {super.key,
      this.withIntervals = true,
      required this.data,
      this.textColor,
      this.barColor,
      this.isHome = false});

  final List<ProjectCategoriesProgressModel> data;
  final Color? textColor, barColor;
  final bool withIntervals;
  final bool isHome;

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
    return AspectRatio(
      aspectRatio: 1.2,
      child: BarChart(
        BarChartData(
          minY: 0,
          maxY: 100,
          barTouchData: BarTouchData(
            handleBuiltInTouches: true,
            touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (touchedSpot) =>
                    context.color.secondary.withValues(alpha: 0.1)),
          ),
          rotationQuarterTurns: 3,
          titlesData: FlTitlesData(
            show: true,
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                maxIncluded: true,
                minIncluded: true,
                showTitles: widget.isHome ? true : false,
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
              sideTitles: SideTitles(
                showTitles: widget.isHome ? false : true,
                maxIncluded: true,
                minIncluded: true,
                getTitlesWidget: (value, meta) => topTitles(
                  value,
                  meta,
                  widget.data
                      .map((e) => e.progress.toString())
                      .toList()
                      .reversed
                      .toList(),
                ),
                reservedSize: 35,
                interval: interval,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => bottomTitles(
                    value,
                    meta,
                    widget.data
                        .map((e) => e.name ?? "")
                        .toList()
                        .reversed
                        .toList(),
                    textColor: context.color.outlineVariant),
                reservedSize: 80,
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
              getDrawingHorizontalLine: (value) => FlLine(
                  color: context.color.outline,
                  strokeWidth: 0.8,
                  dashArray: const [4, 4]),
              drawHorizontalLine: true),
          barGroups: List.generate(
            widget.data.length,
            (index) => BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                    fromY: 0,
                    toY: widget.data[index].progress ?? 0,
                    width: 20.w,
                    color:
                        widget.barColor ?? Styles.projectCategoryColors[index],
                    backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        color: context.color.secondary.withValues(alpha: 0.1),
                        fromY: widget.data[index].progress ?? 0,
                        toY: 100),
                    borderRadius: BorderRadius.circular(2)),
              ],
            ),
          ).toList(),
        ),
      ),
    );
  }
}

Widget bottomTitles(double value, TitleMeta meta, List<String> bottomTilesData,
    {Color? textColor}) {
  final context = CustomNavigator.navigatorState.currentContext;
  final Widget text = Text(bottomTilesData[value.toInt()],
      textAlign: TextAlign.center,
      style: context?.textTheme.bodySmall?.copyWith(
          color: textColor ?? Styles.projectCategoryColors[value.toInt()],
          fontSize: 11));

  return SideTitleWidget(
    // axisSide: meta.axisSide,
    space: 10,
    meta: meta,
    child: text,
  );
}

Widget leftTitles(double value, TitleMeta meta) {
  final context = CustomNavigator.navigatorState.currentContext;
  final formattedValue = (value).toStringAsFixed(0);
  final Widget text = Text(
    "$formattedValue%",
    style: context?.textTheme.bodySmall
        ?.copyWith(color: context.color.outlineVariant),
  );

  return SideTitleWidget(
    space: 10,
    meta: meta,
    child: text,
  );
}

Widget topTitles(double value, TitleMeta meta, List<String> progressTilesData) {
  final context = CustomNavigator.navigatorState.currentContext;
  final Widget text = Text('${progressTilesData[value.toInt()]}%',
      textAlign: TextAlign.center,
      style: context?.textTheme.bodySmall
          ?.copyWith(color: context.color.outlineVariant, fontSize: 11));

  return SideTitleWidget(
    space: 5,
    meta: meta,
    child: text,
  );
}
