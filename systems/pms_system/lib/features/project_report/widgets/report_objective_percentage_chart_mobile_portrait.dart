
import 'package:pms_system/core/utility/pms_exports.dart';

class ReportObjectivePercentageChartMobilePortrait extends StatefulWidget {
  final List<ActivityBarModel> activities;

  const ReportObjectivePercentageChartMobilePortrait({
    super.key,
    required this.activities,
  });

  @override
  State<ReportObjectivePercentageChartMobilePortrait> createState() =>
      _ReportObjectivePercentageChartMobilePortraitState();
}

class _ReportObjectivePercentageChartMobilePortraitState
    extends State<ReportObjectivePercentageChartMobilePortrait> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.4,
      child: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(
            touchCallback: (event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  touchedIndex = -1;
                  return;
                }
                touchedIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
              });
            },
          ),
          borderData: FlBorderData(
            show: false,
            border: Border.all(color: context.color.outline),
          ),
          sectionsSpace: 5.w,
          centerSpaceRadius: 50.w,
          sections: widget.activities.isEmpty
              ? _emptyState()
              : _showingSections(),
        ),
      ),
    );
  }

  List<PieChartSectionData> _showingSections() {
    final colors = widget.activities
        .map(
          (activity) =>
              Color(int.parse(activity.background!.replaceAll('#', '0xff'))),
        )
        .toList();
    return List.generate(widget.activities.length, (i) {
      final isTouched = i == touchedIndex;
      final radius = isTouched ? 60.w : 50.w;
      return PieChartSectionData(
        color: colors[i % colors.length],
        title: '${widget.activities[i].value?.toStringAsFixed(0)}%',
        titleStyle: AppTextStyles.w600.copyWith(
          color: Colors.white,
          fontSize: 14,
        ),
        value: widget.activities[i].value?.toDouble() ?? 0,
        radius: radius,
        borderSide: BorderSide(color: context.color.outline),
      );
    });
  }

  List<PieChartSectionData> _emptyState() {
    return [
      PieChartSectionData(
        color: Styles.SURFACE,
        title: "",
        value: 100,
        radius: 50,
        borderSide: const BorderSide(color: Styles.SURFACE),
      ),
    ];
  }
}
