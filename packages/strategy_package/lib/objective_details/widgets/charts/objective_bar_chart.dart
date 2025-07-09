

import '../../../shared/strategy_exports.dart';


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
    interval = 20;
  }

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
          child: BarChart(
            BarChartData(
              maxY: 100,
              barTouchData: BarTouchData(
                handleBuiltInTouches: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (touchedSpot) =>
                      context.color.secondary.withValues(alpha: 0.1),
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    maxIncluded: true,
                    minIncluded: false,
                    showTitles: true,
                    // showTitles: mainAppBloc.lang.valueOrNull == "en",
                    // reservedSize: 0,
                    reservedSize: 50,
                    getTitlesWidget: leftTitles,
                    interval: interval,
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(
                    maxIncluded: true,
                    minIncluded: false,
                    showTitles: false,
                    // showTitles: mainAppBloc.lang.valueOrNull == "ar",
                    // reservedSize: 0,
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
                        widget.data
                            .map((e) =>
                                "${AppCore.getMonthName(e.month ?? 13)}\n${e.year == 0 ? 2025 : e.year ?? 0}")
                            .toList()),
                    reservedSize: 60,
                    // interval: interval,
                  ),
                ),
              ),
              borderData: FlBorderData(
                border:  Border(
                  top: BorderSide.none,
                  right: BorderSide.none,
                  left: BorderSide(width: 1, color: Colors.transparent),
                  bottom: BorderSide(width: 1, color: context.color.outline),
                ),
              ),
              gridData: FlGridData(
                  horizontalInterval: 10,
                  show: true,
                  getDrawingHorizontalLine: (value) => FlLine(
                      color: context.color.secondary.withValues(alpha: 0.1),
                      dashArray: const [5, 5],
                      strokeWidth: 0.5),
                  drawVerticalLine: false,
                  drawHorizontalLine: true),
              barGroups: List.generate(
                widget.data.length,
                (index) => BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                        fromY: 0,
                        toY: widget.data[index].objectValue ?? 0,
                        width: 30,
                        color: (widget.data[index].objectValue ?? 0) >=
                                (widget.data
                                        .map((e) => e.objectValue ?? 0)
                                        .toList())
                                    .reduce((a, b) => a > b ? a : b)
                            ? context.color.primary
                            : context.color.secondary,
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(10),
                            topLeft: Radius.circular(10))),
                  ],
                ),
              ).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

Widget bottomTitles(
    double value, TitleMeta meta, List<String> bottomTilesData) {
  final Widget text = Text(
    bottomTilesData[value.toInt()],
    textAlign: TextAlign.center,
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
