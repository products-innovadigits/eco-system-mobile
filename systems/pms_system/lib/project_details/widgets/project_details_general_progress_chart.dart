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
  int? selectedBarIndex;
  Offset? tooltipPosition;

  @override
  void initState() {
    super.initState();
    interval = 20;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.4,
      child: Stack(
        children: [
          BarChart(
            BarChartData(
              minY: 0,
              maxY: 100,
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
          if (selectedBarIndex != null && tooltipPosition != null)
            Positioned(
              left: tooltipPosition!.dx - 30,
              top: tooltipPosition!.dy,
              child: _buildCustomTooltip(),
            ),
        ],
      ),
    );
  }

  Widget _buildCustomTooltip() {
    if (selectedBarIndex == null) return const SizedBox.shrink();

    final reversedIndex = widget.data.length - 1 - selectedBarIndex!;
    final progress = widget.data[reversedIndex].progress ?? 0;
    final categoryName = widget.data[reversedIndex].name ?? '';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFF001244),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${progress.toStringAsFixed(0)}%',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (categoryName.isNotEmpty) ...[
            SizedBox(height: 2.h),
            Text(
              categoryName,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
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
