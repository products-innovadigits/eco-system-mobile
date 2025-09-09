import 'package:pms_system/shared/pms_exports.dart';

class ProjectDetailsGeneralProgressChart extends StatefulWidget {
  const ProjectDetailsGeneralProgressChart({
    super.key,
    this.withIntervals = true,
    required this.data,
    this.isPmsHome = false,
    this.textColor,
  });

  final List<ProjectCategoriesProgressModel> data;
  final Color? textColor;
  final bool withIntervals;
  final bool isPmsHome;

  @override
  State<ProjectDetailsGeneralProgressChart> createState() =>
      _ProjectDetailsGeneralProgressChartState();
}

class _ProjectDetailsGeneralProgressChartState
    extends State<ProjectDetailsGeneralProgressChart> {
  double? interval;

  @override
  void initState() {
    super.initState();
    interval = 20;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.4,
      child: BarChart(
        BarChartData(
          minY: 0,
          maxY: 100,
          barTouchData: BarTouchData(
            handleBuiltInTouches: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (touchedSpot) =>
                  context.color.secondary.withValues(alpha: 0.1),
            ),
          ),
          rotationQuarterTurns: 3,
          titlesData: FlTitlesData(
            show: true,
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                maxIncluded: true,
                minIncluded: true,
                showTitles: true,
                reservedSize: 35,
                interval: 20,
                getTitlesWidget: leftTitles,
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => rightSideTitles(
                  value,
                  meta,
                  widget.data.reversed.map((e) => e.name ?? "").toList(),
                  textColor: context.color.outlineVariant,
                ),
                reservedSize: 80,
                maxIncluded: true,
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
              dashArray: const [4, 4],
            ),
            drawHorizontalLine: true,
          ),
          barGroups: List.generate(widget.data.length, (index) {
            // Reverse the index to maintain correct order after rotation
            final reversedIndex = widget.data.length - 1 - index;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  fromY: 0,
                  toY: widget.data[reversedIndex].progress ?? 0,
                  width: 20.w,
                  color:
                      widget.data[reversedIndex].color ??
                      context.color.primary,
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    color: context.color.surfaceContainer,
                    fromY: widget.data[reversedIndex].progress ?? 0,
                    toY: 100,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

Widget rightSideTitles(
  double value,
  TitleMeta meta,
  List<String> bottomTilesData, {
  Color? textColor,
}) {
  final context = CustomNavigator.navigatorState.currentContext;
  final Widget text = Text(
    bottomTilesData[value.toInt()],
    textAlign: TextAlign.right,
    style: context?.textTheme.bodySmall?.copyWith(
      color: textColor ?? LightColor.projectCategoryColors[value.toInt()],
      fontSize: 11,
    ),
  );

  return SideTitleWidget(
    space: 8,
    meta: meta,
    child: Align(alignment: Alignment.centerRight, child: text),
  );
}

Widget leftTitles(double value, TitleMeta meta) {
  final context = CustomNavigator.navigatorState.currentContext;

  final Widget text = Text(
    "${value.toStringAsFixed(0)}%",
    style: context?.textTheme.bodySmall?.copyWith(
      color: context.color.outlineVariant,
    ),
  );

  return SideTitleWidget(space: 8, meta: meta, child: text);
}
