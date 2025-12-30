import 'package:pms_system/core/utility/pms_exports.dart';

class ProjectOutputsChart extends StatefulWidget {
  const ProjectOutputsChart({
    super.key,
    required this.data,
    this.showMoreButton = true,
  });

  final List<MobileOutputsSummaryModel> data;

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
      return const SizedBox();
    }
    final reversedData = widget.data.reversed.toList();
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
                        reversedData,
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
                        toY: (reversedData[index].value ?? 0).toDouble(),
                        width: 35.w,
                        color: Color(
                          int.parse(
                            (reversedData[index].background ?? '#000000')
                                .replaceFirst('#', '0xff'),
                          ),
                        ),
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
        .map((e) => (e.value ?? 0).toDouble())
        .reduce((a, b) => a > b ? a : b);
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
  List<MobileOutputsSummaryModel> data, {
  Color? textColor,
}) {
  if (value.toInt() >= data.length) return Container();

  final outputData = data[value.toInt()];
  return Padding(
    padding: const EdgeInsets.only(top: 4.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        8.sh,
        Text(
          outputData.label ?? '',
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
