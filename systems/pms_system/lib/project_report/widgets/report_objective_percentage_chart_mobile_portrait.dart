import '../../shared/pms_exports.dart';

class ReportObjectivePercentageChartMobilePortrait extends StatefulWidget {
  const ReportObjectivePercentageChartMobilePortrait({
    super.key,
    required this.objectives,
    this.colors,
  });

  final List<ReportObjectivePercentageModel> objectives;
  final List<Color>? colors;

  @override
  State<ReportObjectivePercentageChartMobilePortrait> createState() =>
      _ReportObjectivePercentageChartMobilePortraitState();
}

class _ReportObjectivePercentageChartMobilePortraitState
    extends State<ReportObjectivePercentageChartMobilePortrait> {
  int touchedIndex = -1;
  bool isEmpty = true;

  @override
  Widget build(BuildContext context) {
    final total = widget.objectives
        .map((e) => e.value ?? 0)
        .fold<double>(0, (p, c) => p + c);
    isEmpty = total <= 0;
    final colors = widget.colors ?? _defaultPalette(context);

    return AspectRatio(
      aspectRatio: 1.4,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
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
              sections: isEmpty || _showingSections(colors).isEmpty
                  ? _emptyState()
                  : _showingSections(colors),
            ),
          ),
          SizedBox(
            width: 80.w,
            child: FittedBox(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: allTranslations.text("objective_percentage"),
                  style: context.textTheme.labelSmall,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _showingSections(List<Color> colors) {
    return List.generate(widget.objectives.length, (i) {
      final isTouched = i == touchedIndex;
      final radius = isTouched ? 60.w : 50.w;
      return PieChartSectionData(
        color: colors[i % colors.length],
        title: '${widget.objectives[i].value?.toStringAsFixed(0)}%',
        titleStyle: AppTextStyles.w600.copyWith(
          color: Colors.white,
          fontSize: 10,
        ),
        // push title slightly towards the center for readability
        titlePositionPercentageOffset: .6,
        value: widget.objectives[i].value ?? 0,
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

  List<Color> _defaultPalette(BuildContext context) => const [
    Color(0xFF175CD3),
    Color(0xFFDC6803),
    Color(0xFF12B76A),
    Color(0xFF667085),
    Color(0xFF7A5AF8),
  ];
}
