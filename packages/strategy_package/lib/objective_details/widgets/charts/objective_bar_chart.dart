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
    final isArabic = mainAppBloc.lang.valueOrNull == 'ar';
    // Step 1: Reverse the list
    final data =  widget.data.toList();

    // Step 2: Prepare bottom titles
    final bottomTitlesData = data
        .map(
          (e) =>
              "${AppCore.getMonthName(e.month ?? 13)}\n${e.year == 0 ? 2025 : e.year}",
        )
        .toList();

    // Step 3: Compute the max for coloring
    final maxValue = widget.data
        .map((e) => e.objectValue ?? 0)
        .reduce((a, b) => a > b ? a : b);

    // Step 4: Generate bar groups
    final barGroups = List.generate(
      data.length,
      (i) => BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            fromY: 0,
            toY: data[i].objectValue ?? 0,
            width: 30,
            color: (data[i].objectValue ?? 0) >= maxValue
                ? context.color.primary
                : context.color.secondary,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(10),
              topLeft: Radius.circular(10),
            ),
          ),
        ],
      ),
    );

    return SizedBox(
      width: context.w,
      height: context.h * 0.45,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        reverse: true,
        padding: EdgeInsets.only(top: 12.h),
        child: AspectRatio(
          aspectRatio: 1.8,
          child: BarChart(
            BarChartData(
              maxY: 100,
              barTouchData: BarTouchData(
                handleBuiltInTouches: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (t) =>
                      context.color.secondary.withValues(alpha: 0.1),
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 50,
                    getTitlesWidget: leftTitles,
                    interval: interval,
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) =>
                        bottomTitles(value, meta, bottomTitlesData),
                    reservedSize: 60,
                  ),
                ),
              ),
              borderData: FlBorderData(
                border: Border(
                  top: BorderSide.none,
                  right: BorderSide.none,
                  left: BorderSide(width: 1, color: Colors.transparent),
                  bottom: BorderSide(width: 1, color: context.color.outline),
                ),
              ),
              gridData: FlGridData(
                horizontalInterval: 10,
                show: true,
                getDrawingHorizontalLine: (v) => FlLine(
                  color: context.color.secondary.withValues(alpha: 0.1),
                  dashArray: const [5, 5],
                  strokeWidth: 0.5,
                ),
                drawVerticalLine: false,
              ),
              barGroups: barGroups,
            ),
          ),
        ),
      ),
    );
  }
}

/// Renders the bottom axis titles
Widget bottomTitles(
  double value,
  TitleMeta meta,
  List<String> bottomTilesData,
) {
  final text = Text(
    bottomTilesData[value.toInt()],
    textAlign: TextAlign.center,
    style: AppTextStyles.w400.copyWith(
      color: Styles.ACCENT_PRIMARY_COLOR,
      fontSize: 12,
    ),
  );
  return SideTitleWidget(space: 12, meta: meta, child: text);
}

/// Renders the right-side axis titles (percentages)
Widget leftTitles(double value, TitleMeta meta) {
  final formattedValue = value.toStringAsFixed(0);
  final text = Text(
    "$formattedValue%",
    style: AppTextStyles.w400.copyWith(
      color: Styles.ACCENT_PRIMARY_COLOR,
      fontSize: 12,
    ),
  );
  return SideTitleWidget(space: 16, meta: meta, child: text);
}
