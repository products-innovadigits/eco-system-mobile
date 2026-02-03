import 'package:project_management/core/utility/pms_exports.dart';

class ProjectOutputsChart extends StatefulWidget {
  const ProjectOutputsChart({
    super.key,
    required this.data,
    this.showMoreButton = true,
  });

  final List<ProjectOutputModel> data;

  final bool showMoreButton;

  @override
  State<ProjectOutputsChart> createState() => _ProjectOutputsChartState();
}

class _ProjectOutputsChartState extends State<ProjectOutputsChart> {
  double? interval;

  @override
  void initState() {
    super.initState();
    interval = 20;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return const EmptyContainer();
    }

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1.4,
          child: Directionality(
            textDirection: TextDirection.ltr, // Force LTR for chart layout
            child: BarChart(
              BarChartData(
                minY: 0,
                maxY: _getMaxValue() + 20,
                alignment: BarChartAlignment.spaceAround,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) => outputsRightTitles(
                        value,
                        meta,
                        textColor: context.color.outlineVariant,
                      ),
                      reservedSize: 50,
                      interval: interval,
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) => outputsBottomTitles(
                        value,
                        meta,
                        widget.data,
                        textColor: context.color.outlineVariant,
                      ),
                      reservedSize: 50,
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  border: Border.all(color: Colors.transparent),
                ),
                gridData: FlGridData(
                  horizontalInterval: interval,
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: context.color.outline,
                    strokeWidth: 0.8,
                    dashArray: const [4, 4],
                  ),
                  drawHorizontalLine: true,
                ),
                barGroups: List.generate(
                  widget.data.length,
                  (index) => BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        fromY: 0,
                        toY: widget.data[index].count.toDouble(),
                        width: 35.w,
                        color: _getBarColor(widget.data[index].type),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  double _getMaxValue() {
    if (widget.data.isEmpty) return 100;
    return widget.data
        .map((e) => e.count.toDouble())
        .reduce((a, b) => a > b ? a : b);
  }

  Color _getBarColor(ProjectOutputType type) {
    switch (type) {
      case ProjectOutputType.total:
        return const Color(0xFF1B2951); // Dark blue
      case ProjectOutputType.completed:
        return const Color(0xFF2E7D32); // Green
      case ProjectOutputType.inProgress:
        return const Color(0xFF1976D2); // Blue
      case ProjectOutputType.notStarted:
        return const Color(0xFFFF8F00); // Orange
    }
  }
}

Widget outputsRightTitles(double value, TitleMeta meta, {Color? textColor}) {
  if (value % 20 != 0) return Container();
  return Text(
    '${allTranslations.text(LocaleKeys.output)} ${value.toInt()}',
    style: TextStyle(
      color: textColor,
      fontWeight: FontWeight.w400,
      fontSize: 10,
    ),
    textAlign: TextAlign.center,
  );
}

Widget outputsBottomTitles(
  double value,
  TitleMeta meta,
  List<ProjectOutputModel> data, {
  Color? textColor,
}) {
  if (value.toInt() >= data.length) return Container();

  final outputData = data[value.toInt()];
  return Padding(
    padding: const EdgeInsets.only(top: 4.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 8.h),
        Text(
          allTranslations.text(outputData.titleKey),
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w400,
            fontSize: 10,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  );
}

// Model classes for the chart data
class ProjectOutputModel {
  final ProjectOutputType type;
  final String titleKey;
  final int count;

  ProjectOutputModel({
    required this.type,
    required this.titleKey,
    required this.count,
  });
}

enum ProjectOutputType { total, completed, inProgress, notStarted }
